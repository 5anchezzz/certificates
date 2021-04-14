class ApplicationController < ActionController::Base


  rescue_from ActiveRecord::RecordNotFound,    with: :route_not_found
  rescue_from ActionController::RoutingError,  with: :route_not_found
  rescue_from ActionController::UnknownFormat, with: :route_not_found


  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def type_device
    agent = request.user_agent
    @device = "desktop"
    @device = "tablet" if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    @device = "mobile" if agent =~ /Mobile/
    @device
  end

  private
  def after_sign_out_path_for(resource)
    admin_root_path
  end

end
