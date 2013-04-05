class TokensController < EmberController
  skip_before_filter :verify_authenticity_token
    
  def create
    email = params[:email]
    password = params[:password]
    if request.format != :json
      render :status => 406, :json => {:message => "The request must be json"}
      return
    end

    if email.nil? or password.nil?
      render json: {:status => 400, :message => "The request must contain the user email and password."}
    end

    invalidMsg = "Invalid email or passoword."

    @user=User.find_by_email(email)
    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status => 401, :json => {:message => invalidMsg}
      return
    end

    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token!

    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, invalid password")
      render :status => 401, :json => {:message => invalidMsg}
    else
      render :status => 200, :json => {:token => @user.authentication_token}
    end
  end

  def destroy
    @user=User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info('Token not found.')
      render :status=>404, :json=>{:message=> 'Invalid token.'}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end
end