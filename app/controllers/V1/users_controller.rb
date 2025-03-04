class V1::UsersController < ApplicationController

   before_action :set_user, only: [:show,:destroy,:update]

   before_action :authenticate_request!, except: [:create]

   before_action :role_check, only: [:index]

   def create
      begin
         @user=User.new(user_params)
         if @user.save
           render json: {data: V1::UserSerializer.new(@user), status: "SUCCESS"}, status: :created
         else
            render json: {status: "FAILURE", message: @user.errors.full_messages}, status: :unprocessable_entity
         end
      rescue => e
         render json: {status: "FAILURE", message: e.message}, status: :unprocessable_entity
      end
   rescue => e
       render json: { message: e.message, status: "FAILED" }, status: :unprocessable_entity
   end

   def update
      if @user.update(user_params)
         render json: {data: V1::UserSerializer.new(@user),status: "SUCCESS"},status: :ok
      else
         render json:{message:@status.errors.full_messages, status:"FAILED" },status: :unprocessable_entity
      end
   rescue => e
       render json: { message: e.message, status: "FAILED" }, status: :unprocessable_entity
   end

   def index
      @users=User.order(:id)
      if @users.empty?
         render json:{status:"SUCCESS",message:"there is no users"},status: :ok
         return
      end
      page=params[:page].to_i
      page=1 if page < 1
      per_page=params[:per_page].to_i
      per_page= 10 if per_page < 1
      offset=(page-1)*per_page
      @users=@users.limit(per_page).offset(offset)
      total_users= User.count.to_i

      serialized_users= @users.map{ |user| V1::UserSerializer.new(user) }

      render json:{data: serialized_users, meta:{status:"SUCCESS",total_users:total_users,current_page:page}},status: :ok
   end

   def show
      render json: {data: V1::UserSerializer.new(@user), status:"SUCCESS"},status: :ok
   end

   def destroy
      @user.destroy
      head :no_content 
   rescue =>e
      render json:{message: e.message,status:"FAILED"},status: :unprocessable_entity
   end

  private

  def set_user
      @user=User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
      render json:{error: "User Not Found", status: "FAILED"},status: :not_found
  end

   def user_params
      params.permit(:email,:password,:role)
   end

   def role_check
      unless @current_user.admin?
         render json:{message: "You don't have necessary permissions", status:"FAILED"},status: :forbidden 
      end
   end
 
end