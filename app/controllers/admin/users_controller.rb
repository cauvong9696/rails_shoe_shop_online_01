class Admin::UsersController < AdminController
  before_action :logged_in_user, only: [:index, :edit, :destroy]
  before_action :load_user, only: [:edit, :destroy, :update, :show]
  before_action :check_pass, only: :edit

  def index
    @users = User.user("user").page(params[:user_page]).per Settings.paginates_per
    @admins = User.user("admin").page(params[:admin_page]).per Settings.paginates_per
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t("add_success")
      redirect_to admin_users_url
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t("page_edit")
      redirect_to admin_users_url
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("del_user")
    else
      flash[:danger] = t("error")
    end
    redirect_back fallback_location: root_path
  end

  private

  def check_pass
    user = User.find_by id: params[:id]

    return if user&.authenticate params[:user][:password]
    flash[:danger] = t "pass_fail"
    redirect_back fallback_location: root_path
  end

  def user_params
    params.require(:user).permit :name, :username, :birth_date, :phone,
      :email, :address, :picture, :role, :activated
  end
end
