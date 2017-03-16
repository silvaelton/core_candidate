module CoreCandidate
  module Entity
    class OldCandidate < ApplicationRecord
      self.table_name = 'extranet.entity_old_candidates'

      has_many :old_candidates
    end
  end
end
