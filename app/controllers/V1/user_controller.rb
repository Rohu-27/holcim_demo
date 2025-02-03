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
   end

   def update
      begin
         @user.update(user_params)
         render json: {data: V1::UserSerializer.new(@user),status: "SUCCESS"},status: :ok
      rescue => e
         render json: {status: "FAILURE", message: e.message}, status: :unprocessable_entity
      end
   end

   def index
      @users=User.order(:id)
      render json: @users, each_serializer: V1::UserSerializer ,meta:{status:"SUCCESS"} ,status: :ok
   end

   def show
      render json: {data: V1::UserSerializer.new(@user), status:"SUCCESS"},status: :ok
   end

   def destroy
      begin 
         @user.destroy
         head :no_content 
      rescue =>e
         render json:{message: e.message,status:"FAILURE"},status: :unprocessable_entity
      end
   end

  private

  def set_user
      begin
         @user=User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
         render json:{error: "User Not Found", status: "NOT FOUND"},status: :not_found
      end
  end

   def user_params
      params.require(:user).permit(:email,:password,:role)
   end

   def role_check
      unless @current_user.admin?
         render json:{message: "Unauthorized Person to access the Resouce ", status:"Un Authorized"},status: :UnAuthorized 
      end
   end
 
end