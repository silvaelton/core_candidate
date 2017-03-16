module Candidate
  class CadastreCreate < ::Candidate::Cadastre 

    attr_accessor :observation

    default_scope { where(created_by: 1)}


    validates :cpf, :name, presence: true
    validates :cpf, uniqueness: true

    validates :observation, presence: true

    after_create :set_observation
    after_create :set_situation

    private

    def set_observation
      ::Candidate::CadastreObservation.new({
        cadastre_id: self.id,
        observation: self.observation,
        staff_id: self.creator_id
      }).save
    end

    def set_situation
      self.cadastre_situations.new({
        situation_status_id: 53,
        observation: self.observation
      }).save
    end

  end
end