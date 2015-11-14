class API::V1::UsersController < API::V1::BaseController
  
  def create
    @user = User.new(user_params)

     if @user.save
      render :show, status: 201
    else
      render json: {errors: @user.errors}, status: 422
    end
  end

    private
      def user_params
        params.permit(:email, :password)
      end
end