class Api::V1::MessagesController < Api::V1::BaseController
    before_action :authenticate_with_token!

  def index
    channel = Channel.find_by(id: params[:channel_id])

    if channel
      @messages = channel.messages
      @messages = @messages.where("id < ?", params[:before_id])  if params[:before_id] 
      @messages = @messages.order(id: :DESC).page(params[:page])
    else
      render text: "404 Not Found", status: 404
    end
  end

  def create
   channel = Channel.find_by(id: params[:channel_id])

   if channel
      message = channel.messages.build(message_params)
      message.user = current_user
      return render text: "422 Unprocessable Entity", status: 422 unless message.valid?

      message.save!

      render text: "201 Created", status: 201
    else
      render text: "404 Not Found", status: 404
    end
  end

  private

    def message_params
      params.permit(:text)
    end
end