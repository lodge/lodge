require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do
  sign_in

  describe '.create' do
    render_views
    subject { post :create, params }

    before { request.accept = "application/json" }
    let(:image) { fixture_file_upload '/test.png', 'image/png' }

    context '画像が0枚' do
      let(:params) { { files: [] } }
      let(:result) { { error: 'image data not contain' }.to_json }
      it 'エラーメッセージが返ってくる' do
        subject
        expect(response.body).to eq result
      end
    end

    context '画像が1枚' do
      let(:params) { { files: [image] } }

      it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
      it '正しいjsonが返ってくる' do
        subject
        json = JSON.parse(response.body)
        expect(json['image']['image']['image_url']) =~ /\/test.png\z/
      end
      it { expect { subject }.to change { Image.all.reload.count }.by(1) }
    end

    context '画像が2枚' do
      let(:params) { { files: [image, image2] } }
      let(:image2) { fixture_file_upload '/test2.png', 'image/png' }

      it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
      it '正しいjsonが返ってくる' do
        subject
        json = JSON.parse(response.body)
        expect(json['image']['image']['image_url']) =~ /\/test2.png\z/
      end
      it { expect { subject }.to change { Image.all.reload.count }.by(1) }
    end
  end
end
