module CoreCandidate
  class Ammv < ApplicationRecord
    self.table_name = 'extranet.candidate_ammvs'

    def cadastre_exists?
      CoreCandidate::Cadastre.find_by_cpf(self.cpf) rescue nil
    end
  end
end
