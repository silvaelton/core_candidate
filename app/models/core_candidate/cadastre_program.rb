module Candidate
  class CadastreProgram < ::Candidate::Cadastre 

    attr_accessor :staff_id, :observation

    validates :program, :observation, presence: true
    validate  :program_is_equal?

    after_update :add_activity

    private

    def program_is_equal?
      if !self.program_id_changed?
        errors.add(:program_id, "O programa deve ser diferente do atual")
      end
    end

    def add_activity

      old_program = ::Candidate::Program.find(changes[:program_id][0]).name rescue nil

      new_program = ::Candidate::Program.find(changes[:program_id][1]).name rescue nil

      observation = "#{self.observation} --- De #{old_program} para #{new_program}"
      
      activity = self.cadastre_activities.new({
        staff_id: self.staff_id,
        observation: observation,
        activity_status_id: 25,
        type_activity: 'crítico'
      })

      activity.save
    end

  end
end