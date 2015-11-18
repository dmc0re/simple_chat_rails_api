class Api::V1::MessagesController < Api::V1::BaseController
    before_action :authenticate_with_token!

  def index

    channel = Channel.where(id: params[:channel_id]).first

    if channel
      scope = channel.messages
      scope = scope.where("id > ?", params[:after_id]) unless params[:after_id].blank?
      scope = scope.where("id <= ?", params[:before_id]) unless params[:before_id].blank?

      @messages = scope.includes(:user).order(id: :DESC).page(params[:page])
    else
      render text: "404 Not Found", status: 404
    end
  end

  def create
   channel = Channel.where(id: params[:channel_id]).first

    if channel
      @message = channel.messages.build(message_params)
      @message.user = current_user

      if @message.save
        render :show, status: 201
      else
        render text: "422 Unprocessable Entity", status: 422
      end      
    else
      render text: "404 Not Found", status: 404
    end
  end

  private

    def message_params
      params.permit(:text)
    end
end