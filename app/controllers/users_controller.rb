class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :re_login, only: [:new, :create]

  def show
    redirect_to(root_url) && return unless @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params.merge(role: "user")
    if @user.save
      @user.send_activation_email
      flash[:info] = t("require_check_email")
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t("edit_success")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :username, :birth_date, :phone,
      :email, :password, :password_confirmation, :address, :picture
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user?(@user)
  end
end
