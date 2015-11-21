require 'rails_helper'

describe Api::V1::MessagesController, type: :controller do
  describe "GET #index" do
    before do
      @messages_count = 10

      @channel = FactoryGirl.create :channel

      @messages_count.times { FactoryGirl.create :message, channel_id: @channel.id, user_id: @channel.user.id  }
      api_authorization_header @channel.user.auth_token
    end

    context "when is not receiving \"before_id\" parameter" do
      before do
        get "index", channel_id: @channel.id
      end

      it "returns #{@messages_count} record from db" do
        response = json_response
        messages_response = response[:data][:messages]
        pagination_respons = response[:pagination]
        expect(messages_response.size).to eq(pagination_respons[:total_count].to_i)
      end

      it "returns the user name into each channel" do
        messages_response = json_response[:data][:messages]
        messages_response.each do |message_response|
          expect(message_response[:user_name]).to eq(@channel.user.name)
        end
      end

      it { expect(response).to have_http_status(200) }
    end

    context "when \"before_id\"  parameter is sent" do
      before do
        @rand_index = rand(@messages_count)
        get :index, channel_id: @channel.id, before_id: Message.all[@rand_index].id
      end

      it "returns valid channels count from db" do
        messages_response = json_response[:data][:messages]
        expect(messages_response.size).to eq(@rand_index + 1)
      end

      it { expect(response).to have_http_status(200) }
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before do
        channel = FactoryGirl.create :channel

        @message_attributes = FactoryGirl.attributes_for :message
        api_authorization_header channel.user.auth_token

        @message_attributes[:channel_id] = channel.id

        post :create, @message_attributes
      end

      it "render json representation for the channel record just created" do
        message_response = json_response
        expect(message_response[:text]).to eq @message_attributes[:text]
      end

      it { expect(response).to have_http_status(201) }
    end

    context "when is not created" do
      before do
        channel = FactoryGirl.create :channel

        api_authorization_header channel.user.auth_token
        post :create, channel_id: channel.id
      end

      it "renders an errors json" do
        channel_response = json_response
        expect(channel_response).to have_key(:errors)
      end

      it "renders the json errors on why the message could not be created" do
        product_response = json_response
        expect(product_response[:errors][:text]).to include "can't be blank"
      end

      it { expect(response).to have_http_status(422) }
    end
  end
end
