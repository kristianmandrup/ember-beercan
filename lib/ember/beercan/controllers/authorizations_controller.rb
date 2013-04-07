class AuthorizationsController < APIController
  def show      
    render json: {status: status}
  end

  protected

  def status
    authorized ? 200 : 401
  end

  def authorized
    can? action, object
  end

  def cancan?
    unless self.respond_to? :can?
      raise "You must have a can? method available in this controller ('cancan' gem)."
    end
  end      

  def clazz 
    @clazz = cName.capitalize.constantize
  end

  def object
    clazz.find(id) unless id.blank?
  end

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
