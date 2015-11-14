class API::V1::SessionsController < API::V1::BaseController

   def create 
    user_password = params[:password]
    user_email = params[:email]

    @user = User.where(email: user_email).first

    if @user && @user.valid_password?(user_password)
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render "api/v1/users/show", status: 201
    else
      render json: { errors: "Invalid email or/and password" }, status: 422
    end 
  end

  def destroy
    user = User.where(auth_token: params[:id]).first   
    user.generate_authentication_token!
    user.save
    head 204
  end

end 