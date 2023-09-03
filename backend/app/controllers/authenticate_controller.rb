class AuthenticateController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    return render json: create_user, status: :created if user.blank?

    if user.valid_password?(params[:password])
      render json: { user: user.as_json(only: [:id, :email]), token: "Bearer " + get_token(user) }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def create_user
    user = User.create!(user_params)
    {
      user: user.as_json(only: [:id, :email]),
      token: "Bearer " + get_token(user)
    }
  end

  def get_token(user)
    Auth.issue({user_id: user.id, email: user.email})
  end
end
