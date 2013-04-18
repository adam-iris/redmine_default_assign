class DefaultAssignIssueHook < Redmine::Hook::ViewListener
  def view_issues_form_details_top(context={})
    # new issues haven't been assigned an id yet
    if context[:issue].id == nil
      context[:issue].assigned_to = context[:project].find_default_assignee
    end
    
    return
 
  end  
end
