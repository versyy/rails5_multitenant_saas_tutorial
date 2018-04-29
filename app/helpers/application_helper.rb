module ApplicationHelper
  def default_dashboard
    dashboard_path
  end

  def flash_class(level)
    case level.to_sym
    when :notice  then 'alert-info'
    when :success then 'alert-success'
    when :alert   then 'alert-warning'
    when :error   then 'alert-danger'
    else "alert-#{level}"
    end
  end

  def layout_name
    current_user.nil? ? 'unauthenticated' : 'authenticated'
  end
end
