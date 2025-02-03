class V1::StatusController < ApplicationController

  before_action :authenticate_request!, :is_admin?
  before_action :set_status, only: [:update,:show,:destroy]

  def create
    @status=Status.new(status_param)
    if @status.save
      render json:{data:@status, message:"Status Created Successfully", status:"SUCCESS" },status: :created
    else
      render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
    end
  rescue => e
    render json: { message: e.message, status: "FAILURE" }, status: :unprocessable_entity
  end

  def update
    if @status.update(status_param)
      render json:{data:@status, message:"Status Updated Successfully", status:"SUCCESS" },status: :ok
    else
      render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
    end
  rescue => e
    render json: { message: e.message, status: "FAILURE" }, status: :unprocessable_entity
  end

  def show
    render json: {data: @status, status:"SUCCESS"},status: :ok
  end

  def index
    @status_all=Status.all
    render json: {data: @status_all, status:"SUCCESS"},status: :ok
  end

  def destroy
    @status.destroy
    head :no_content
  rescue=>e
    render json:{message: e.message,status:"FAILURE"},status: :unprocessable_entity
  end

  private

  def status_param
    params.require(:status).permit(:name)
  end

  def set_status
    @status=Status.find(params[:id])
  rescue
    render json:{error: "Status Not Found", status: "NOT FOUND"},status: :not_found
  end

  def is_admin?
    unless @current_user.admin?
      render json: {message: "Unauthorized Person to acsess the Resouce ", status:"UnAuthorized"},status: :unauthorized
    end
  end
  
end
