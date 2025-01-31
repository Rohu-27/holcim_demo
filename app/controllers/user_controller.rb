class UserController<ApplicationController

    def create
       @user=User.create(user_param)
       if @user.save
          render json:{user: @user,status: :created},status: :created
       else
          render json:{error: @user.errors.full_messages.join(", ")},status: :unprocessable_entity
       end
    end

  private

    def user_param
      params.require(:user).permit(:email,:password,:role)
    end
end