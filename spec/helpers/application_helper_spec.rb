require 'rails_helper'

describe ApplicationHelper do
  describe '#controller_stylesheet_link_tag' do
    subject(:tag) { helper.controller_stylesheet_link_tag }

    before do
      allow(helper).to receive(:params) { {controller: controller_name} }
    end

    context "assetsにファイルがないとき" do
      let(:controller_name) { 'hoge/fuga' }

      it "linkタグが生成されないこと" do
        expect(tag).to be_nil
      end
    end

    context "assetsにファイルがあるとき" do
      let(:controller_name) { 'custom_devise/registrations' }

      it "linkタグが生成されること" do
        expect(tag).to match /link/
        expect(tag).to match /assets\/#{controller_name.gsub('/','\/')}\.css/
      end
    end
  end

  describe '#controller_javascript_include_tag' do
    subject(:tag) { helper.controller_javascript_include_tag }

    before do
      allow(helper).to receive(:params) { {controller: controller_name} }
    end

    context "assetsにファイルがないとき" do
      let(:controller_name) { 'hoge/fuga' }

      it "scriptタグが生成されないこと" do
        expect(tag).to be_nil
      end
    end

    context "assetsにファイルがあるとき" do
      let(:controller_name) { 'articles' }

      it "scriptタグが生成されること" do
        expect(tag).to match /script/
        expect(tag).to match /assets\/#{controller_name.gsub('/','\/')}\.js/
      end
    end
  end
end
