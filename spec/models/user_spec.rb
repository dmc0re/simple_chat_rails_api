require 'rails_helper'

describe User do
  before(:each) { @user = FactoryGirl.create(:user) }

  describe "#generate_authentication_token!" do
    it "generates token after created" do
      expect(@user.auth_token).to_not eq("")
    end

    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("qwerty")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "qwerty"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "qwerty")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  it { expect(@user).to be_valid }
end