module Candidate
  class Program < ActiveRecord::Base
    has_many :positions

    def validations
      Candidate::Validation.where("'#{self.id}' = ANY(program_id)")
    end
  end
end
