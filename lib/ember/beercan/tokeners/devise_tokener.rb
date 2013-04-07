class DeviseTokener
  attr_reader :user

  def initialize user
    @user = user
  end

  def token    
    user.authentication_token
  end

  def reset_token
    user.reset_authentication_token!
  end

  # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
  def authenticate_token
    user.ensure_authentication_token!
  end
end
