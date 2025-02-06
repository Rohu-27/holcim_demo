class V1::CategoryController < ApplicationController

  before_action :set_category, only:[:show, :update, :destroy]

  before_action :authenticate_request!

  before_action :role_check, only:[:create,:update,:destroy]

  def create
    @category=Category.new(category_params)
    if @category.save
      render json:{data: V1::CategorySerializer.new(@category), status:"SUCCESS"},status: :created
    else
      render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
    end
  rescue => e
    render json: { message: e.message, status: "FAILED" }, status: :unprocessable_entity
  end

  def update
    if @category.update(category_params)
      render json:{data: V1::CategorySerializer.new(@category),status:"SUCCESS"},status: :ok
    else
      render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
    end
  rescue => e
    render json: { message: e.message, status: "FAILED" }, status: :unprocessable_entity

  end

  def index
    @categories=Category.order(:id)
    @categories = @categories.where(ticket_type: params[:type])
    render json: @categories, each_serializer: V1::CategorySerializer, meta:{status:"SUCCESS"},status: :ok
  end

  def show
    render json:{data: V1::CategorySerializer.new(@category),status: "SUCCESS"},status: :ok
  end

  def destroy
      @category.destroy
      head :no_content
  rescue =>e
    render json:{message:e.message,status:"FAILED"},status: :unprocessable_entity
  end

  private

  def category_params
    params.require(:category).permit(:name, sub_categories_attributes:[:id, :name, :_destroy] )
  end
  
  def set_category
    @category=Category.find(params[:id])
  rescue =>e
    render json:{message: e.message, status:"NOT FOUND"},status: :not_found 
  end

  def role_check
    unless @current_user.admin?
      render json:{message: "Unauthorized Person to access the Resouce ", status:"UnAuthorized"},status: :unauthorized 
    end
  end

end