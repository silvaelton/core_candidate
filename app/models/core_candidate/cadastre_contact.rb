module Candidate
  class CadastreContact < Cadastre
  
    attr_accessor :password_digest
        
    validates :name, :mother_name, :rg, :rg_org, :rg_uf, :telephone, presence: true
    validates :email, email: true, allow_blank: true
    validates :cep, :city, :address, presence: true

    
  end
end