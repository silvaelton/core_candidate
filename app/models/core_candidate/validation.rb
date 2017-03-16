module Candidate
  class Validation < ActiveRecord::Base
    belongs_to :program
    belongs_to :occurrence_situation 
  
    enum validation_type: ['query', 'service']
    enum target_return_type: ['retorno_query', 'retorno_service']
    enum occurrence_type: ['informação', 'pendência', 'pendência_impeditiva']
        

    validates :name, :description, :program_id, presence: true
    validates :portal_label, presence: true, if: 'self.allow_portal?'

    validates :target_model_query, presence: true, if: 'self.query?'
    validates :target_model_function, presence: true, if: 'self.service?'

    def fields
      self.target_return_field.split(';') rescue nil
    end

    def occurrence_return(id)
      
      if !id.nil?
        if self.retorno_query?
          Candidate::Iptu.find_by_sql("#{self.target_return_query} id = #{id}")
        else
          model         = "#{self.target_return_function}".split('.')[0]
          model_method  = "#{self.target_return_function}".split('.')[1]

          cadastre      = ::Candidate::Cadastre.find(id)
          function_return = "#{model}".constantize.send("#{model_method}", cadastre.cpf)
          
        end
      else
        {}
      end
    end

    def program_names
      Candidate::Program.where(id: self.program_id).map(&:name)
    end
  end
end
