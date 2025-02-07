class V1::SubCategoriesController < ApplicationController

  before_action :set_category, only: [:create, :index]

  before_action :set_sub_category,only: [:update, :show, :destroy]

  before_action :authenticate_request!

  before_action :role_check, only:[:create,:update,:destroy]

  def create
    @sub_category=@category.sub_categories.build(sub_category_params)
    if @sub_category.save
      render json: {data: V1::SubCategorySerializer.new(@sub_category),status:"SUCCESS"},status: :created
    else
      render json: { message: @sub_category.errors.full_messages.join(", "), status: "FAILED" }, status: :unprocessable_entity
    end
  rescue => e
      render json:{message:e.message,status:"FAILED"},status: :unprocessable_entity
  end

  def update
    if @sub_category.update(sub_category_params)
      render json:{data: V1::SubCategorySerializer.new(@sub_category),status:"SUCCESS"},status: :ok
    else
      render json: { message: @sub_category.errors.full_messages.join(", "), status: "FAILED" }, status: :unprocessable_entity
    end
  rescue => e
    render json:{message:e.message,status:"FAILED"},status: :unprocessable_entity
  end

  def index
    @sub_categories=@category.sub_categories.order(:id)
    if @sub_categories.empty?
        render json:{status:"SUCCESS", message:"there is no sub categories for this catgory id = #{:id}"}
    end
    sub_category_serializer=@sub_categories.map {|sub_categorie| V1::SubCategorySerializer.new(sub_categorie)}
    render json:{ data: sub_category_serializer, status:"SUCCESS" },status: :ok
  end

  def show
    render json:{data: V1::SubCategorySerializer.new(@sub_category),status:"SUCCESS"},status: :ok
  end

  def destroy
      @sub_category.destroy
      head :no_content
  rescue =>e
    render json:{message:e.message,status:"FAILED"},status: :unprocessable_entity  
  end

  private

  def sub_category_params
    params.require(:sub_category).permit(:name)
  end

  def set_category
    @category=Category.find(params[:category_id])
  rescue => e
    render json:{message:e.message, status:"Category Not Found"},status: :not_found
  end

  def set_sub_category
      @sub_category=SubCategory.find(params[:id])
  rescue =>e
    render json:{message: e.message, status:"NOT FOUND"},status: :not_found 
  end

  def role_check
    unless @current_user.admin?
      render json:{message: "Unauthorized Person to acsess the Resouce ", status:"Un Authorized"},status: :unauthorized 
    end
  end

end