module Candidate
  class Inheritor < ActiveRecord::Base
    belongs_to :cadastre
    belongs_to :inheritor_type
    belongs_to :civil_state

    scope :name_inheritor,  -> (name_inheritor) {where(name: name_inheritor)}
    scope :cpf,  -> (cpf) {where(cpf: cpf)}
    scope :type_inheritor,  -> (type_inheritor) {where(type_inheritor_id: type_inheritor)}

    enum gender: ['N/D', 'masculino', 'feminino']

    validates :cpf, cpf: true

    validates :name, :cpf, :born, presence: true


    def self.log_inheritor!(cadastre, user, status, observation)
      @cadastre =  Candidate::CadastreActivity.new(
        cadastre_id: cadastre,
        staff_id: user,
        activity_status_id: status,
        type_activity: 2,
        observation: observation
      )
      @cadastre.save
    end

  end
end
