class V1::UserController<ApplicationController

   before_action :set_user, only: [:show,:destroy,:update]

   before_action :authenticate_request!, except: [:create]

   before_action :role_check, only: [:index]
   before_action :set_time_zone, except: %i[create]

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
      # render json: @users, each_serializer: V1::UserSerializer ,meta:{status:"SUCCESS"} ,status: :ok
      page=params[:page].to_i
      page=1 if page < 1
      per_page=params[:per_page].to_i
      per_page= 10 if per_page < 1
      offset=(page-1)*per_page
      if params[:email].present?
         @users=@users.where('email LIKE ?',"%#{params[:email]}%") 
      end
      if params[:date].present?
         @users=@users.where('created_at::text LIKE ?',"%#{params[:date]}%") 
      end
      @users=@users.limit(per_page).offset(offset)

      @totalUsers= User.count.to_i

      serialized_users= @users.map{ |user| V1::UserSerializer.new(user,{content:{action:"index"}}) }

      render json:{data: serialized_users, meta:{status:"SUCCESS",totalUsers:@totalUsers,current_page:page}},status: :ok
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
      render json:{error: "User Not Found", status: "NOT FOUND"},status: :not_found
  end

   def user_params
      params.require(:user).permit(:email,:password,:role)
   end

   def role_check
      unless @current_user.admin?
         render json:{message: "Unauthorized Person to access the Resouce ", status:"Un Authorized"},status: :unauthorized 
      end
   end
 
end