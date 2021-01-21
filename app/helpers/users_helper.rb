module UsersHelper
  def active_if_current_tab(tab_name, current_tab)
    'active' if tab_name == current_tab
  end
end
