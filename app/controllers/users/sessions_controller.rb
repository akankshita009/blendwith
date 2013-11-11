class Users::SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    unless resource.approved
      # first need to logout
      sign_out resource
      set_flash_message(:notice, :not_approved)
      redirect_to '/users/sign_in'
      return
    end
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    # sync social network data
    SocialWorker.perform_async resource.id
    # refresh google token
    RefreshOauthWorker.perform_async resource.id
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

end
