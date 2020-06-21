require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create :user }
  let(:youtube_url) { 'https://www.youtube.com/watch?v=JorWrNjjQos' }

  it { should belong_to(:user) }
  it { should validate_presence_of :youtube_url }

  context 'validate youtube_url' do
    let(:youtube_url) { 'invalid_url' }
    let(:post) { build :post, youtube_url: youtube_url, user: user }

    it 'return errors' do
      expect(post.valid?).to eq(false)
      expect(post.errors.full_messages).to eq(['Youtube url is invalid', 'Youtube url has invalid video'])
    end
  end

  context 'attributes' do
    let(:post) { create :post, youtube_url: youtube_url, user: user }
    let(:mock_info) { { title: 'title', description: 'description' } }

    before { allow(FetchYoutubeVideoInfo).to receive_message_chain(:new, :call).and_return(mock_info) }

    it 'return all' do
      expect(post.user).to eq(user)
      expect(post.title).to eq('title')
      expect(post.description).to eq('description')
      expect(post.youtube_code).to eq('JorWrNjjQos')
      expect(post.embed_url).to eq('https://www.youtube.com/embed/JorWrNjjQos')
    end
   end
end
