
module Candidate
  class EnterpriseCadastre < ActiveRecord::Base

    attr_accessor :cpf, :observation

    belongs_to :cadastre
    belongs_to :general_pontuation, class_name: "::Candidate::View::GeneralPontuation", primary_key: :id, foreign_key: :cadastre_id
    belongs_to :enterprise, class_name: "Project::Enterprise"
    belongs_to :indication_cadastre, class_name: "Indication::Cadastre"

    belongs_to :indication_situation, class_name: "Indication::Situation"

    has_many :enterprise_cadastre_situations, class_name: "Candidate::EnterpriseCadastreSituation"

    scope :prepare_allotment, -> (allotment_id) {
      cadastres = Indication::Cadastre.where(allotment_id: allotment_id).map(&:id)
    }

    scope :prepare_step, -> (step_id) {
      allotments = Indication::Allotment.where(step_id: step_id).map(&:id)
      self.prepare_allotment(allotments)
    }
    scope :by_enterprise,    -> (enterprise_id = nil)   { where(enterprise_id: enterprise_id)}
    scope :by_allotment,     -> (allotment_id = nil)    { where(indication_cadastre_id: prepare_allotment(allotment_id))}
    scope :by_step,          -> (step_id = nil)         { where(indication_cadastre_id: prepare_step(step_id))}
    scope :by_cpf,           -> (cpf = nil)             { joins(:cadastre).where('candidate_cadastres.cpf = ?', cpf.gsub('.','').gsub('-',''))}
    scope :by_list,          -> (list = nil)           { joins(:cadastre).where('candidate_cadastres.program_id = ?', list)}
    scope :indication_date,  -> (indication_date = nil) { where('created_at::date = ?', Date.parse(indication_date) )}

    scope :by_indication_situation, -> (value) { where(indication_situation_id: value)}

    scope :name_candidate,  -> (name) {joins(:cadastre).where('candidate_cadastres.name like ?', "#{name}%")}
    scope :status, -> (status) { where(inactive: status) }

    scope :by_new, -> (status) {
          if status == "true"
            joins('left join candidate_enterprise_cadastre_situations on candidate_enterprise_cadastre_situations.enterprise_cadastre_id = candidate_enterprise_cadastres.id')
            .where('candidate_enterprise_cadastre_situations.enterprise_cadastre_id is null')
          else
            joins(:enterprise_cadastre_situations)
          end
    }

    scope :desactive, -> { where(inactive: true) }

    scope :contemplated, -> (enterprise_id = nil, step_id = nil, allotment_id = nil){
      query = Candidate::View::IndicatedContemplated.per_enterprise(enterprise_id)

      query = query.joins('INNER JOIN indication_cadastres
                           ON indication_cadastres.id = indicated_contemplateds.indication_id')
      query = query.joins('INNER JOIN indication_allotments
                           ON indication_allotments.id = indication_cadastres.allotment_id')

      query = query.where('indication_allotments.id = ?', allotment_id)  if !allotment_id.nil? && !allotment_id.empty?
      query = query.where('indication_allotments.step_id = ?', step_id)  if !step_id.nil? && !step_id.empty?

      return query
    }

    scope :in_process, -> {
      self.where(inactive: nil).joins('INNER JOIN general_pontuations AS point
                  ON point.id = candidate_enterprise_cadastres.cadastre_id')
                .where('point.situation_status_id = 4')
    }

    #validates :cadastre_id, uniqueness: { scope: [:enterprise_id] }, presence: true

    validates :cpf, cpf: true, if: 'self.cpf.present?'

    validate  :cpf_valid?, on: :create, if: 'self.cpf.present?'


    def cpf_valid?
      @cadastre = ::Candidate::Cadastre.find_by_cpf(self.cpf) rescue nil
      if @cadastre.nil?
        errors.add(:cpf, 'CPF não existe na base de dados')
        return false
      end

      @enterprise = Candidate::EnterpriseCadastre.where('cadastre_id = ? and inactive is not true', @cadastre.id)

      if @enterprise.present?
        errors.add(:cpf, 'Candidato já possui indicação ativa.')
        return false
      end

      if @cadastre.current_situation_id != 4 && !%w(14 72).include?(@cadastre.current_procedural.procedural_status_id.to_s)
        errors.add(:cpf, 'Situação do CPF não é válida para esta operação')
        return false
      end
    end

  end
end
