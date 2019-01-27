module ControllerMacros
  def login_admin(admin)
    @request.env["device.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  def login_user(user)
    # controller.stub(:authenticate_user!).and_return true
    allow(controller).to receive(:authenticate_user!).and_return true
    @request.env["device.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end