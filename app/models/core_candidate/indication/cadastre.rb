module CoreCandidate
  module Indication
    class Cadastre < ApplicationRecord
      self.table_name = 'extranet.indication_cadastres'

      belongs_to :allotment
    end
  end
end
