module BeerCan::FindMe
  def me
    current_user || guest_user
  end

  protected

  def current_user 
    @current_user ||= User.find_by token_hash if authenticity_token
  end

  def guest_user
    {}
  end

  def token_hash
    {token: authenticity_token}
  end

  def authenticity_token
    @authenticity_token ||= token_params.select do |name|
      params[name]
    end.first
  end

  def token_params
    [:authenticity_token, :auth_token, :token, :id]
  end
end
