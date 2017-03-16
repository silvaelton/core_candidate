module Candidate
  class CadastreMirror < ActiveRecord::Base
    belongs_to :special_condition
    belongs_to :city, class_name: 'Address::City'
    belongs_to :state, class_name: 'Address::State'
    belongs_to :work_city, class_name: 'Address::City'
    belongs_to :civil_state
    belongs_to :program
    belongs_to :city, class_name: "Address::City"
    belongs_to :work_city, class_name: "Address::City"
    belongs_to :work_state, class_name: "Address::State"
    belongs_to :cadastre
    belongs_to :special_condition_type, class_name: "::Candidate::SpecialConditionType"
    belongs_to :cadastre_situation, class_name: "Candidate::CadastreSituation", foreign_key: 'situation_id', primary_key: "id"
    belongs_to :cadastre_procedural, class_name: "Candidate::CadastreProcedural", foreign_key: 'procedural_id', primary_key: "id"

    has_many :dependent_mirrors, dependent: :destroy
    has_many :attendance_logs
    has_many :cadastre_checklists, class_name: "Attendance::CadastreChecklist"
    has_many :cadastre_procedurals
    has_many :attendances, class_name: "Attendance::Cadastre"
    has_many :iptus, foreign_key: 'cpf'
    has_many :cadastre_attendances



    has_one :pontuation

    enum situation: ['em_progresso','pendente', 'aprovado']
    enum gender: ['N/D', 'masculino', 'feminino']

    FAMILY_INCOME = 880 * 12

    validates :cpf, cpf: true

    # format variables

    # => abstração

    def complete_address
      "#{self.address} #{self.address_complement}"
    end

    def spouse
      self.dependent_mirrors.where(kinship_id: 6).first rescue nil
    end

    def age
      (Date.today - self.born).to_i / 365.25
    end

    def pontuation?
      Candidate::Pontuation.where(cadastre_mirror_id: self.id).present?
    end


    def arrival_df_time(date)
      date.year - self.arrival_df.strftime("%Y").to_i if self.arrival_df.present?
    end

    def timelist_time(date)
      date.year - self.created_at.year
    end

    def self.check_arrival_df(id)
      mirror = Candidate::CadastreMirror.find(id)

      (Date.today - self.born).to_i / 365
      date = Date.parse(mirror.arrival_df) rescue nil

      if date.present?
        ((Date.today - date).to_i / 365) < 5
      else
        false
      end
    end

    def self.family_income_calc(id)
      mirror = Candidate::CadastreMirror.find(id)
      income_dep = mirror.dependent_mirrors.sum(:income)

      (income_dep + mirror.income) > FAMILY_INCOME
    end

  end
end
