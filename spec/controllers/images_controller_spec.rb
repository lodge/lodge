require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
  end

  describe '.create' do
    render_views
    subject { post :create, params }

    before { request.accept = "application/json" }
    let(:image) { fixture_file_upload '/test.png', 'image/png' }

    context 'with no image' do
      let(:params) { { files: [] } }
      let(:result) { { error: 'image data not contain' }.to_json }
      it 'returns error message' do
        subject
        expect(response.body).to eq result
      end
    end

    context 'with a image' do
      let(:params) { { files: [image] } }

      it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
      it 'returns collect JSON' do
        subject
        json = JSON.parse(response.body)
        expect(json['image']['image']['image_url']) =~ /\/test.png\z/
      end
      it { expect { subject }.to change { Image.all.reload.count }.by(1) }
    end

    context 'with two images' do
      let(:params) { { files: [image, image2] } }
      let(:image2) { fixture_file_upload '/test2.png', 'image/png' }

      it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
      it 'returns collect JSON' do
        subject
        json = JSON.parse(response.body)
        expect(json['image']['image']['image_url']) =~ /\/test2.png\z/
      end
      it { expect { subject }.to change { Image.all.reload.count }.by(1) }
    end
  end
end
