class V1::AlbumController < ApplicationController
  before_action :authenticate_request!
  def show
    album = Album.find(params[:id])
    if album
      render json: {data: V1::AlbumSerializer.new(album), status: "SUCCESS"}, status: :ok
    else
      render json: {error: album.errors.full_messages, status: "FAILURE"}, status: :unprocessable_entity
    end
  end
end
