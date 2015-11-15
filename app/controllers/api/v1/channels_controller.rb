class Api::V1::ChannelsController < Api::V1::BaseController
  before_action :authenticate_with_token!

  def index
    scope = Channel
    scope = scope.where("id < ?", params[:before_id]) unless params[:before_id].blank?
    @channels = scope.order(id: :DESC).page(params[:page])
  end

  def create
    channel = Channel.new(channel_params)

    if channel.save
      render text: "201 Created", status: 201
    else
      render text: "422 Unprocessable Entity", status: 422
    end
  end

   def destroy
    channel = Channel.where(id: params[:id]).first

    if channel.user == current_user
      if channel
        if channel.destroy
          head status: 204
        else
          render text: "500 Internal Server Error", status: 500
        end
      else  
        render text: "404 Not Found", status: 404
      end
    else
      render text: "403 Forbidden ", status: 403
    end  
  end

  private

    def channel_params
      params.permit(:name)
    end
end