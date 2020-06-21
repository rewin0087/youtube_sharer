require 'rails_helper'

RSpec.describe 'Posts' do

  describe 'GET index' do
    let!(:user) { create :user }
    let!(:existing_post) { create :post, title: 'title', description: 'description', youtube_url: 'https://www.youtube.com/watch?v=JorWrNjjQos', user: user }

    context 'user authenticated' do
      before do
        sign_in user
        get '/posts'
      end

      it 'return response' do
        expect(response).to have_http_status :ok
        expect(response).to render_template('posts/index')

        new_post = assigns(:new_post)

        expect(new_post.id).to be_nil
        expect(new_post.user).to eq(user)

        posts = assigns(:posts).to_a

        expect(posts).to eq([existing_post])
      end
    end

    context 'no user authenticated' do
      before { get '/posts' }

      it 'return response' do
        expect(response).to have_http_status :ok
        expect(response).to render_template('posts/index')

        new_post = assigns(:new_post)

        expect(new_post.id).to be_nil
        expect(new_post.user).to be_nil

        posts = assigns(:posts).to_a

        expect(posts).to eq([existing_post])
      end
    end
  end

  describe 'POST create' do
    let!(:user) { create :user }
    let(:youtube_url) { 'https://www.youtube.com/watch?v=JorWrNjjQos' }
    let(:params) {  { post: { youtube_url: youtube_url, user_id: user.id } } }

    context 'user authenticated' do
      let(:mock_youtube_info) { { title: 'Funny Youtube Video', description: 'Description' } }

      before do
        allow(FetchYoutubeVideoInfo).to receive_message_chain(:new, :call).and_return(mock_youtube_info)
      end

      context 'with valid youtube_url' do
        before do
          sign_in user
          post '/posts.js', params: params
        end

        it 'be successful' do
          expect(response).to have_http_status :ok
          expect(response).to render_template('posts/create')
          created_post = assigns(:post)

          expect(created_post.id).not_to be_nil
          expect(created_post.title).to eq('Funny Youtube Video')
          expect(created_post.description).to eq('Description')
          expect(created_post.user).to eq(user)
        end
      end

      context 'with invalid youtube_url' do
        let(:youtube_url) { 'http://youtube.com/test' }

        before do
          sign_in user
          post '/posts.js', params: params
        end

        it 'be successful' do
          expect(response).to have_http_status :ok
          expect(response).to render_template('posts/create')
          created_post = assigns(:post)

          expect(created_post.id).to be_nil
          expect(created_post.errors.full_messages).to eq(['Youtube url has invalid video'])
        end
      end

      context 'with empty required params' do
        let(:youtube_url) { 'http://youtube.com/test' }

        before do
          sign_in user
          post '/posts.js', params: { post: { user_id: nil, youtube_url: nil } }
        end

        it 'be successful' do
          expect(response).to have_http_status :ok
          expect(response).to render_template('posts/create')
          created_post = assigns(:post)

          expect(created_post.id).to be_nil
          expect(created_post.errors.full_messages).to eq(['User must exist', 'Youtube url can\'t be blank'])
        end
      end
    end

    context 'no user authenticated' do
      before { post '/posts.js', params: params }

      it { expect(response).to have_http_status :unauthorized }
    end
  end
end
