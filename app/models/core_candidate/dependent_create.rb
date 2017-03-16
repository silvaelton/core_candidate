module Candidate
  class DependentCreate < ::Candidate::Dependent

    attr_accessor :observation, :creator_id

    validates :name, :born, :place_birth, presence: true
    validates :civil_state, :special_condition, :kinship, presence: true  

    validates :observation, presence: true

    after_create :set_observation

    private

    def set_observation
      ::Candidate::CadastreObservation.new({
        cadastre_id: self.id,
        observation: self.observation,
        staff_id: self.creator_id
      }).save
    end



  end
end
