module CoreCandidate
  class Cadastre < ApplicationRecord

    self.table_name = 'extranet.candidate_cadastres'
    
    belongs_to :special_condition
    belongs_to :special_condition_type
    belongs_to :city, class_name: 'Address::City'
    belongs_to :state, class_name: 'Address::State'
    belongs_to :work_city, class_name: 'Address::City'
    belongs_to :civil_state
    belongs_to :program
    belongs_to :work_city, class_name: "Address::City"

    has_many :attendances, class_name: "Attendance::Cadastre"

    has_many :requeriments, primary_key: :cpf, foreign_key: :cpf, class_name: "Regularization::Requeriment"
    has_many :schedules,    primary_key: :cpf, foreign_key: :cpf, class_name: "Schedule::AgendaSchedule"
    has_many :assessments,  primary_key: :cpf, foreign_key: :cpf, class_name: "Protocol::Assessment"
    has_many :exemptions,   primary_key: :cpf, foreign_key: :cpf, class_name: "Sefaz::Exemption"

    has_many :occurrences, class_name: "Candidate::CadastreOccurrence"
    has_many :ammvs
    has_many :cadastre_observations
    has_many :cadastre_mirrors
    has_many :dependents
    has_many :dependent_creates
    has_many :cadastre_situations
    has_many :pontuations , ->  { order(:id)}
    has_many :positions
    has_many :tickets
    has_many :cadastre_attendances
    has_many :cadastre_checklists
    has_many :attendance_logs
    has_many :cadastre_geolocations
    has_many :firm_enterprise_statuses, class_name: 'Firm::EnterpriseStatus'
    #has_many :enterprise_cadastres, foreign_key: "cadastre_id", class_name: "Firm::EnterpriseCadastre"
    has_many :enterprise_cadastres, foreign_key: "cadastre_id", class_name: "Candidate::EnterpriseCadastre"

    has_many :invoices, class_name: "Brb::Invoice", foreign_key: :cpf, primary_key: :cpf
    has_many :cadastre_address
    has_many :cadastre_procedurals
    has_many :cadastre_logs
    has_many :inheritors
    has_many :cadastre_activities
    has_many :cadastre_convocations

    has_many :old_candidates, class_name: 'Entity::OldCandidate'
    has_many :olds, through: :old_candidates, class_name: "Entity::Old"


    has_many :cadastre_attendances
    has_many :cadastre_attendance_statuses, through: :cadastre_attendances

    scope :allow_for_attendance, -> {
      self.joins(:cadastre_situations)
      .where('candidate_cadastre_situations.created_at = (SELECT MAX(candidate_cadastre_situations.created_at)
              FROM candidate_cadastre_situations
              WHERE candidate_cadastre_situations.cadastre_id = candidate_cadastres.id)')
      .where('candidate_cadastre_situations.situation_status_id in (3, 4)')
      .where('candidate_cadastres.program_id in (1,2,4,5,7,9,10)')
    }

    scope :by_name, -> (name) {
      name = name.gsub(' ','')
      where("trim(regexp_replace(name, '\s+', '', 'g')) ilike '%#{name}%'")
    }

    scope :situation, -> (situation) {
      self.joins(:cadastre_situations)
      .where('candidate_cadastre_situations.situation_status_id = (SELECT MAX(candidate_cadastre_situations.situation_status_id)
              FROM candidate_cadastre_situations WHERE candidate_cadastre_situations.cadastre_id = candidate_cadastres.id)')
      .where('candidate_cadastre_situations.situation_status_id = ?', situation)
    }



    scope :regularization,  -> {where(program_id: [3,6])}
    scope :habitation,      -> {where(program_id: [1,2,4,5,6,7,8])}

    scope :by_cpf,          -> (cpf = nil) { where(cpf: cpf.to_s.unformat_cpf) }
    scope :by_assessment,    -> (cpf = nil) { where(cpf: cpf) }


    enum gender: ['N/D', 'masculino', 'feminino']
    enum created_by: ['interno', 'externo']

    accepts_nested_attributes_for :dependents, allow_destroy: true



  end
end
