class Api::V1::ChannelsController < Api::V1::BaseController

  def index
    @channels = Channel.order(id: :DESC).page(params[:page])
  end

  def create
    channel = Channel.new(channel_params)

    unless channel.valid?
      return render text: "422 Unprocessable Entity", status: 422
    end

    channel.save!

    render text: "201 Created", status: 201
  end

   def destroy
    channel = Channel.find(params[:id])

    if !channel.destroy
      return render text: "500 Internal Server Error", status: 500
    end

    head status: 204
  end

  private

    def channel_params
      params.permit(:name)
    end
end