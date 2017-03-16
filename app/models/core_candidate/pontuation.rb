module Candidate
  class Pontuation < ActiveRecord::Base
    belongs_to :cadastre_mirror
    belongs_to :situation_status
    
    default_scope { order('created_at DESC')}
      
    def year
      if self.code.present?
        Date.parse(self.code.to_s)
      else
        self.created_at 
      end
    end
  end
end
