class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_user, only: [:update, :destroy]

  protected
  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def ensure_user
    if resource.email == 'guest@example.com'
      redirect_to edit_user_registration_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end
end
