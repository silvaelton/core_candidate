module CoreCandidate
  class ValidationPresenter < ApplicationPresenter
    
    def occurrence_return(id)

      if !id.nil?
        if self.retorno_query?
          CoreCandidate::Iptu.find_by_sql("#{self.target_return_query} id = #{id}")
        else
          model         = "#{self.target_return_function}".split('.')[0]
          model_method  = "#{self.target_return_function}".split('.')[1]

          cadastre      = ::CoreCandidate::Cadastre.find(id)
          function_return = "#{model}".constantize.send("#{model_method}", cadastre.cpf)

        end
      else
        {}
      end
    end

    def program_names
      CoreCandidate::Program.where(id: self.program_id).map(&:name)
    end
  end
end
