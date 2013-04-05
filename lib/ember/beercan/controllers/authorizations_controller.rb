class AuthorizationsController < EmberController
  def show
    
    object = cName.capitalize.constantize
    
    object = object.find(id) unless id.blank?
    
    authorized = can? action, object
    
    render json: {status: (authorized ? 200 : 401)}
  end

  protected

  def cName
    params[:cName]
  end

  def action
    params[:action]
  end

  def id
    params[:id]
  end
end
