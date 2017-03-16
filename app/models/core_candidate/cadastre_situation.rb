module Candidate
  class CadastreSituation < ActiveRecord::Base
    belongs_to :situation_status
    belongs_to :cadastre_convocation
    belongs_to :cadastre

    audited

    #validates :situation_status, presence: true
    #validate  :situation_uniq, on: :create

    def self.contemplated_day_count(day)
      self.where(created_at: day, situation_status_id: 7).count
    end

    def self.enabled_day_count(day)
      self.where(created_at: day, situation_status_id: 4).count
    end

    def self.halted_day_count(day)
      self.where(created_at: day, situation_status_id: 50).count
    end

    def self.create_status(mirror_id, cadastre_id, situation_status)
      @cadastre_situation = Candidate::CadastreSituation.new
      @cadastre_situation.cadastre_mirror_id = mirror_id
      @cadastre_situation.cadastre_id = cadastre_id
      @cadastre_situation.situation_status_id = situation_status
      @cadastre_situation.save
    end

    private

    def situation_uniq
      if cadastre.cadastre_situations.present?
        if cadastre.cadastre_situations.order('created_at ASC').last.present?
          if cadastre.cadastre_situations.order('created_at ASC').last.situation_status_id == self.situation_status_id
            errors.add(:situation_status, "Candidato já se encontra neste situação. Favor selecionar outra.")
          end
        end
      end
    end


  end
end
