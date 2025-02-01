class V1::CategoryController < ApplicationController

  before_action :set_category, only:[:show, :update, :destroy]

  before_action :authenticate_request!

  before_action :role_check, only:[:create,:update,:destroy]

  def create
    begin
      @category=Category.new(category_params)
      @category.save
      render json:{data: V1::CategorySerializer.new(@category), status:"SUCCESS"},status: :created
    rescue => e
      render json:{message: e.message},status: :unprocessable_entity
    end
  end

  def update
    begin
      @category.update(category_params)
      render json:{data: V1::CategorySerializer.new(@category),status:"SUCCESS"},status: :ok
    rescue => e
      render json:{message: e.message},status: :unprocessable_entity
    end

  end

  def index
    @categories=Category.order(:id)
    render json: @categories, each_serializer: V1::CategorySerializer, meta:{status:"SUCCESS"},status: :ok
  end

  def show
    render json:{data: V1::CategorySerializer.new(@category),status: "SUCCESS"},status: :ok
  end

  def destroy
    begin
      @category.destroy
      head :no_content
    rescue =>e
      render json:{message:e.message,status:"FAILED"},status: :unprocessable_entity  
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, sub_categories_attributes:[:id, :name, :_destroy] )
  end
  
  def set_category
    begin
      @category=Category.find(params[:id])
    rescue =>e
      render json:{message: e.message, status:"NOT FOUND"},status: :not_found 
    end
  end

  def role_check
    unless @current_user.admi n?
      render json:{message: "UnAuthorized Person to acsess the Resouce ", status:"Un Authorized"},status: :unauthorized 
    end
  end

end