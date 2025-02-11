class V1::CategoriesController < ApplicationController

  before_action :set_category, only:[:show, :update, :destroy]

  before_action :authenticate_request!

  before_action :role_check, only:[:create,:update,:destroy]

  def create
    if (params[:parent_id].present? && params[:ticket_type].present?) || (params[:parent_id].nil? && params[:ticket_type].nil?)
      render json:{message:"Please provide either parent_id or type", status:"FAILED"},status: :unprocessable_entity
      return
    end
    if params[:parent_id].nil? && (params[:ticket_type].nil? || !["CM","RQ"].include?(params[:ticket_type]))
      render json: { message: "Invalid type. It must be 'CM' or 'RQ'.", status: "FAILED" }, status: :unprocessable_entity
      return
    end
    category=Category.new(category_params)
    if category.save
      render json:{data: V1::CategorySerializer.new(category), status:"SUCCESS"},status: :created
    else
      render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
    end
  rescue => e
    render json: { message: e.message, status: "FAILED" }, status: :unprocessable_entity
  end

  def update
    if @category.update(category_update_params)
      render json:{data: V1::CategorySerializer.new(@category),status:"SUCCESS"},status: :ok
    else
      render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
    end
  rescue => e
    render json: { message: e.message, status: "FAILED" }, status: :unprocessable_entity
  end

  def index
    if (params[:parent_id].present? && params[:ticket_type].present?) || (params[:parent_id].nil? && params[:ticket_type].nil?)
      render json:{message:"Please provide either parent_id or type", status:"FAILED"},status: :unprocessable_entity
      return
    end
    categories=Category.order(:id)
    categories = categories.where(ticket_type: params[:ticket_type]) if params[:type].present?
    categories = categories.where(parent_id: params[:parent_id]) if params[:parent_id].present?
    if categories.empty?
      render json: {status: 'SUCCESS', message: "There are no categories"}, status: :ok
      return
    end
    categories_serializer=categories.map { |category| V1::CategorySerializer.new(category) }
    render json:{ data: categories_serializer, status:"SUCCESS"},status: :ok
  end

  def show
    render json:{data: V1::CategorySerializer.new(@category),status: "SUCCESS"},status: :ok
  end

  def destroy
      sub_categories=Category.where(parent_id: params[:id])
      sub_categories.each do |sub_category|
        sub_category.destroy
      end
      @category.destroy
      head :no_content
  rescue =>e
    render json:{message:e.message,status:"FAILED"},status: :unprocessable_entity
  end

  private

  def category_params
    params.permit(:name, :ticket_type, :parent_id)
  end

  def category_update_params
    params.permit(:name)
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