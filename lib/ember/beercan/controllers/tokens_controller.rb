class TokensController < APIController
  skip_before_filter :verify_authenticity_token

  class NotJsonError          < StandardError; end
  class InsufficientDataError < StandardError; end    
  class UserError             < StandardError; end
  class TokenNotFoundError    < StandardError; end

  def create    
    validate_json!    
    retrieve_user
    tokener.authenticate_token

    render_json 200, :token => tokener.token

  rescue UserError    
    render_msg 401, invalid_msg
  rescue InsufficientDataError
    render_msg 400, insufficient_data_msg
  rescue NotJsonError    
    render_msg 406, not_json_msg
  end

  def destroy    
    validate_token!
    tokener.reset_token
    render_json 200, token: id
  rescue TokenNotFoundError
    render_msg 404, invalid_token_msg
  end

  protected

  def retrieve_user
    user_by(:email)
    validate_user!
  end    

  def invalid_token_msg 
    'Invalid token'
  end

  def validate_token!
    if user_by(:token).nil?
      logger.info('Token not found.')
      raise TokenNotFoundError
    end      
  end    

  def render_json code, json
    render :status => code, json: json
  end

  def render_msg code, msg
    render :status => code, json: {:message => msg}
  end

  def log msg
    logger.info msg if logging? && logger
  end

  def logging?
    true
  end

  def tokener
    @tokener ||= DeviseTokener.new user
  end

  def validate_password!    
    unless valid_password?
      log "User #{email} failed signin, invalid password"
      raise UserError 
    end
  end    

  def valid_password?
    @user.valid_password?(password)
  end

  def validate_user!
    validate_email!
    validate_password!
  end

  def validate_email!
    unless @user
      log "User #{email} failed signin, user cannot be found."
      raise UserError 
    end
  end    

  def user
    @user
  end

  def user_by type = :token
    @user ||= type == :token ? user_by_token : user_by_email
  end

  def user_by_email
    User.find_by email: email
  end

  def user_by_token
    User.find_by authentication_token: id
  end

  def validate_json!
    raise NotJsonError if request.format != :json
    raise NotJsonError if insufficient_data?
  end

  def invalid_msg
    "Invalid email or password."
  end

  def insufficient_data_msg
    "The request must contain the user email and password."
  end

  def not_json_msg
    "The request must be json"
  end

  def insufficient_data?
    email.nil? or password.nil?
  end

  def id
    params[:id]
  end

  def password
    params[:password]
  end

  def email
    params[:email]
  end
end