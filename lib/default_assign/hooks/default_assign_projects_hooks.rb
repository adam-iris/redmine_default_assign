class DefaultAssignProjectHook < Redmine::Hook::ViewListener
 
  # context:
  # * :form - the form builder
  # * :project - the current project
  def view_projects_form(context={})
    return  if context[:project].assignable_users.empty?
    return content_tag(:p, context[:form].select(:default_assignee_id,  
      principals_options_for_select(context[:project].assignable_users, context[:project].find_default_assignee), 
      {:include_blank => :none})
    )
 
  end

end
