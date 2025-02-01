class ApplicationController < ActionController::API
  def authenticate_request!
      token=request.headers['Authorization']&.split(" ")&.last
      if token
        decoded_token=JwtToken.decode(token)
        if decoded_token
          @current_user=User.find_by(email: decoded_token["user_email"])
        else
          render json:{error: "Invalid Token"},status: :unauthorized
        end
      else
        render json:{error: "Token Missing"},status: :unauthorized
      end
  end
end
