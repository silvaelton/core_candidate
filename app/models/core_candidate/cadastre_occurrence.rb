module Candidate
  class CadastreOccurrence < ActiveRecord::Base
    belongs_to :occurrence_situation
    belongs_to :validation
    belongs_to :cadastre


    #validates :feedback_observation, presence: true, on: :update

    scope :solved, ->     { where(solved: true) }
    scope :not_solved, -> { where(solved: false) }

    scope :by_name, -> (name) {joins(:cadastre).where("candidate_cadastres.name ilike '%#{name}%'")}
    scope :by_cpf, -> (cpf) {joins(:cadastre).where("candidate_cadastres.cpf = ?", cpf.unformat_cpf)}
    scope :by_status, -> (status) { where(solved: status)}

    def view_occurrence
      if self.validation.retorno_query?
        sql    = "#{self.validation.target_return_query} id = #{self.target_model_id}"
        result = ActiveRecord::Base.connection.query(sql)
        result
      else

      end
    end

  end
end
