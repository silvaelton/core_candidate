module CoreCandidate
  class DependentMirror < ApplicationRecord

    self.table_name = 'extranet.candidate_dependent_mirrors'

    belongs_to :special_condition
    belongs_to :civil_state
    belongs_to :kinship
    belongs_to :special_condition
    belongs_to :special_condition_type
    belongs_to :cadastre_mirror

    enum gender: ['N/D', 'masculino', 'feminino']

    def age
      if self.born.present?
        (Date.today - self.born).to_i / 365
      else
        0
      end
    end

  end
end
