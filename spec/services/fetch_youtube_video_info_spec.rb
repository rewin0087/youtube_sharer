require 'rails_helper'

RSpec.describe FetchYoutubeVideoInfo do
  let(:url) { URI.parse('http://test.com/page') }
  let(:doc) { File.read("#{Rails.root}/spec/fixtures/youtube_page.html") }

  before do
    allow(OpenURI).to receive(:open_uri).with(url).and_return(doc)
  end

  subject { described_class.new(url.to_s) }

  describe '#call' do
    context 'with existing content' do
      let(:expected_result) { { title: 'Funny Youtube Video', description: 'Description' } }

      it { expect(subject.call).to eq(expected_result) }
    end

    context 'with non-existing content' do
      let(:doc) { 'test' }
      let(:expected_result) { { title: '', description: '' } }

      it { expect(subject.call).to eq(expected_result) }
    end
  end
end