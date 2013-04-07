class SorceryTokener
  attr_reader :user, :controller

  def initialize user, controller = nil
    @user = user
    @controller = controller
  end

  def token    
    user.token
  end

  def reset_token
    controller.destroy_access_token
  end
  
  def authenticate_token
    # should fire after_login hook, which performs token authentication
    controller.login_from_access_token
  end
end
