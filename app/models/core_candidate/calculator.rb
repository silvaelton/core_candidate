module Candidate
  class Calculator
    include ActiveModel::Model
    
    attr_accessor :cpf, :cadastre, :cadastre_pontuation

    attr_accessor :arrival_df, 
                  :created_at, 
                  :income, 
                  :dependent_count, 
                  :special_dependents_count, 
                  :current_special_condition,
                  :total_member

    attr_accessor :timelist,
                  :bsb_timelist,
                  :special_dependent,
                  :family_income,
                  :dependent,
                  :total


    validates :cpf, cpf: true, presence: true 

    def self.subscribe_dates
      %w(12/07/2011 01/01/2016)
    end

    def preview_calculate!
      self.cadastre = ::Candidate::Cadastre.find_by(cpf: self.cpf) 
      self.cadastre_pontuation = self.cadastre.last_pontuation
    end

    def calculate!
      preview_calculate!

      pontuation = ::Candidate::SimulatingScoreService.new({
        dsp: self.created_at,
        dependent_count: self.dependent_count,
        current_special_condition: self.current_special_condition,
        special_dependents_count: self.special_dependents_count,
        created_at: self.created_at,
        income: self.income,
        arrival_df: self.arrival_df
      }).scoring_cadastre!
      
      
      self.timelist           = pontuation[:timelist_score]
      self.family_income      = pontuation[:income_score]
      self.bsb_timelist       = pontuation[:timebsb_score]
      self.dependent          = pontuation[:dependent_score]
      self.special_dependent  = pontuation[:special_dependent_score]
      self.total              = pontuation[:total]
    end


  end
end

 