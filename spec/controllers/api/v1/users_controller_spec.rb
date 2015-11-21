require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe "POST #create" do
    context "when is successfully created" do
      before do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, @user_attributes
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { expect(response).to have_http_status(201) }
    end

    context "when is not created" do
      before do

        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { expect(response).to have_http_status(422) }
    end
  end
end