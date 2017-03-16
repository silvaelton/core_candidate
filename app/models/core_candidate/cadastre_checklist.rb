module CoreCandidate
  class CadastreChecklist < ApplicationRecord
    self.table_name = 'extranet.candidate_cadastre_checklists'

    belongs_to :cadastre_mirror
    belongs_to :checklist

    def self.checked?(check_id)
      self.find_by_checklist_id(check_id).present?
    end

    def self.authenticate?(check_id)
      self.where(checklist_id: check_id, document_authenticate: true).present?
    end
  end
end
