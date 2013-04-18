module DefaultAssignProjectPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable

      safe_attributes :default_assignee_id
      belongs_to :default_assignee, :class_name => "Principal"
      before_save :set_default_assignee
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def find_default_assignee
      return self.default_assignee if self.default_assignee
      return nil if self.assignable_users.empty?
      default_assignee_id = Setting.plugin_redmine_default_assign['default_assignee_id']
      return Principal.find(default_assignee_id) unless default_assignee_id.blank? or
            not self.assignable_users.member?(Principal.find(default_assignee_id))
      # Try to use the first principal (presumably the manager/creator)
      first_principal = self.member_principals.detect{ |m| self.assignable_users.member?(m.user) }
      return first_principal.user if first_principal
    end
    
    def set_default_assignee
      self.default_assignee = self.find_default_assignee
    end
  end
end
