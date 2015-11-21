require 'rails_helper'

describe Api::V1::ChannelsController, type: :controller do
  describe "GET #index" do
    before do
      @channels_count = 10

      @user = FactoryGirl.create :user

      @channels_count.times { FactoryGirl.create :channel, user_id: @user.id}
      api_authorization_header @user.auth_token
    end

    context "when is not receiving \"before_id\" parameter" do
      before do
        get "index"
      end

      it "returns #{@channel_count} record from db" do
        response = json_response
        channels_response = response[:data][:channels]
        pagination_respons = response[:pagination]
        expect(channels_response.size).to eq(pagination_respons[:total_count].to_i)
      end

      it "returns the user name into each channel" do
        channels_response = json_response[:data][:channels]
        channels_response.each do |channel_response|
          expect(channel_response[:owner_name]).to eq(@user.name)
        end
      end

      it { expect(response).to have_http_status(200) }
    end

    context "when \"before_id\"  parameter is sent" do
      before do
        @rand_index = rand(@channels_count)
        get :index, before_id: Channel.all[@rand_index].id
      end

      it "returns valid channels count from db" do
        channels_response = json_response[:data][:channels]
        expect(channels_response.size).to eq(@rand_index + 1)
      end

      it { expect(response).to have_http_status(200) }
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before do
        user = FactoryGirl.create :user
        @channel_attributes = FactoryGirl.attributes_for :channel
        api_authorization_header user.auth_token
        post :create, @channel_attributes
      end

      it "render json representation for the channel record just created" do
        channel_response = json_response
        expect(channel_response[:name]).to eq @channel_attributes[:name]
      end

      it { expect(response).to have_http_status(201) }
    end

    context "when is not created" do
      before do
        user = FactoryGirl.create :user
        @invalid_channel_attributes = {  }
        api_authorization_header user.auth_token
        post :create, @invalid_product_attributes
      end

      it "renders an errors json" do
        channel_response = json_response
        expect(channel_response).to have_key(:errors)
      end

      it "renders the json errors on why the channel could not be created" do
        product_response = json_response
        expect(product_response[:errors][:name]).to include "can't be blank"
      end

      it { expect(response).to have_http_status(422) }
    end
  end

   describe "DELETE #destroy" do
    before do
      @user = FactoryGirl.create :user
      @channel = FactoryGirl.create :channel, user: @user
      api_authorization_header @user.auth_token 
      delete :destroy, { user_id: @user.id, id: @channel.id }
    end

    it { expect(response).to have_http_status(204) }
  end

end
