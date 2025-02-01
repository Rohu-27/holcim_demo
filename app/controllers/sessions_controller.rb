class SessionsController < ApplicationController

  def create
    @user=User.find_by(email: params[:email])
    if @user &.authenticate(params[:password])
      token=JwtToken.encode(user_email: @user.email,role: @user.role)
      render json:{token: token}
    else
      render json:{error: "Invalid Email or Password"},status: :unauthorized
    end
  end
  
end
