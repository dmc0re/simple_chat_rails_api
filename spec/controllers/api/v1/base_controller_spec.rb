require 'rails_helper'


describe Api::V1::BaseController do

  let(:base_controller) { Api::V1::BaseController.new }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      allow(base_controller).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(base_controller.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe "#authenticate_with_token" do
    before do
      @user = FactoryGirl.create :user
      allow(base_controller).to receive(:current_user).and_return(nil)
      allow(response).to receive(:status).and_return(401)
      allow(response).to receive(:body).and_return({"errors" => "Not authenticated"}.to_json)
      allow(base_controller).to receive(:response).and_return(response)
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

    it {  expect(response).to have_http_status(401) }
  end

  describe "#user_signed_in?" do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(base_controller).to receive(:current_user).and_return(@user)
      end

      it { expect(base_controller).to be_user_signed_in }
    end

    context "when there is no user on session'" do
      before do
        @user = FactoryGirl.create :user
        allow(base_controller).to receive(:current_user).and_return(nil)
      end

      it { expect(base_controller).to_not  be_user_signed_in }
    end
  end
end
