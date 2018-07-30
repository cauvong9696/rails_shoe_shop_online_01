class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_admin user
    else
      flash.now[:danger] = t("login_fail")
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def active_and_redirect user
    if user.activated?
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or root_url
    else
      flash[:warning] = t "require_check_email"
      redirect_to root_url
    end
  end

  def check_admin user
    if user.admin?
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or admin_url
    else
      active_and_redirect user
    end
  end
end
