class UsersController < ApplicationController
  def show
    # User.find(1)과 같은 의미임. find는 정수로 알아서 표현됨.
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                               :password_confirmation)
    end
end
