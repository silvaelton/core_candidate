module CoreCandidate
  module Entity
    class Old < ApplicationRecord
      self.table_name = 'extranet.entity_olds'

      belongs_to :old
    end
  end
end
