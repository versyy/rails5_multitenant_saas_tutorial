module ApplicationHelper
  def layout_name
    current_user.nil? ? 'unauthenticated' : 'authenticated'
  end
end
