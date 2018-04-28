module ApplicationHelper
  def default_dashboard
    dashboard_path
  end

  def layout_name
    current_user.nil? ? 'unauthenticated' : 'authenticated'
  end
end
