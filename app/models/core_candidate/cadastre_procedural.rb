module Candidate
  class CadastreProcedural < ActiveRecord::Base
    belongs_to :procedural_status
    belongs_to :convocation
    belongs_to :cadastre
    belongs_to :assessment, class_name: "Protocol::Assessment"
    belongs_to :old_assessment, class_name: "Protocol::Assessment", foreign_key: 'old_process', primary_key: "document_number"
    validates :observation, :old_process, :procedural_status_id, presence: true
    #validate  :situation_uniq


    before_validation :validate_process

    audited

    def current_status_procedural
        self.procedural_status.name rescue nil
    end

    def self.create_procedural(mirror_id, cadastre_id, procedural_status,convocation,assessment, process, staff,observation,transfer_process,transfer_assessment_id)
         @cadastre_procedurals = Candidate::CadastreProcedural.new
         @cadastre_procedurals.cadastre_mirror_id = mirror_id
         @cadastre_procedurals.cadastre_id = cadastre_id
         @cadastre_procedurals.procedural_status_id = procedural_status
         @cadastre_procedurals.convocation_id = convocation
         @cadastre_procedurals.assessment_id = assessment
         @cadastre_procedurals.old_process = process
         @cadastre_procedurals.staff_id = staff
         @cadastre_procedurals.observation = observation
         @cadastre_procedurals.observation = transfer_process
         @cadastre_procedurals.observation = transfer_assessment_id
         @cadastre_procedurals.save
    end


    def set_before_data!
      procedural = cadastre.current_procedural rescue nil

       if procedural.present?
        self.convocation_id = procedural.convocation_id
        self.old_process    = procedural.old_process
       self.assessment_id  = procedural.assessment_id
      end
    end

    private

    def validate_process
      assessment = ::Protocol::Assessment.find_by_document_number(self.old_process)
      
      if assessment.present?
        self.assessment_id = assessment.id
      else
        errors.add(:old_process, "Número de processo não encontrado.")
      end
    end

    def situation_uniq
      if cadastre.current_procedural_id == self.procedural_status_id
        errors.add(:procedural_status, "Candidato já se encontra neste situação. Favor selecionar outra.")
      end
    end


  end
end
