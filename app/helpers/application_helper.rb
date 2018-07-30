module ApplicationHelper
  def full_title page_title = ""
    base_title = t("name_shop")
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def params_present id_params
    id_params ? admin_user_path : admin_users_path
  end
end
