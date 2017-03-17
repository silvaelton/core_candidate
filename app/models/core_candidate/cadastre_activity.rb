module CoreCandidate
  class CadastreActivity < ApplicationRecord
    self.table_name = 'extranet.candidate_cadastre_activities'

    belongs_to :cadastre
    belongs_to :staff, class_name: "CoreCandidate::Person::Staff"
    belongs_to :activity_status

    default_scope { order('created_at DESC') }

    enum type_activity:   ['simples', 'judicial','crítico', 'corretiva', 'sistema']



  end
end
