class GuardedBaseController < EmberController
  doorkeeper_for :all, :if => lambda { request.xhr? }
  
  private
  
  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
