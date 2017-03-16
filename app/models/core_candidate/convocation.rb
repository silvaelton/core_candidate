module Candidate
  class Convocation < ActiveRecord::Base
    scope :regularization, -> { where(program_id: 3)}
    
    has_many :convocation_cadastres
    
    def description_with_id
      "#{self.id} - #{self.description}"
    end

    def attendances
      0
    end

    def schedules
    end

  end
end
