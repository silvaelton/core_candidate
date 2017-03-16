module CoreCandidate
  class EnterpriseCadastrePresenter < ApplicationPresenter

    def cpf_valid?
      @cadastre = ::CoreCandidate::Cadastre.find_by_cpf(self.cpf) rescue nil
      if @cadastre.nil?
        errors.add(:cpf, 'CPF não existe na base de dados')
        return false
      end

      @enterprise = CoreCandidate::EnterpriseCadastre.where('cadastre_id = ? and inactive is not true', @cadastre.id)

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
