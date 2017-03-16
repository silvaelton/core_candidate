module Candidate
  class EnterpriseCadastreSituation < ActiveRecord::Base
    belongs_to :enterprise_situation_status, foreign_key: "enterprise_cadastre_status_id"
    belongs_to :enterprise_situation_action, foreign_key: "enterprise_situation_action_id"
    belongs_to :enterprise_cadastre, class_name: "Candidate::EnterpriseCadastre"
    belongs_to :firm_user, class_name: "Project::UserCompany", foreign_key: "firm_user_id"

    enum type_action: ['contato', 'informação', 'devolução']

    #validates :type_action, :enterprise_situation_action, presence: true

    mount_uploader :file_path, Candidate::FilePathUploader

    def self.create_enterprise_cadastre_situation(mirror_id, cadastre_id, firm_id,status,observation,user)
      @enterprise_cadastre_situation = Candidate::EnterpriseCadastreSituation.new
      @enterprise_cadastre_situation.cadastre_id = cadastre_id
      @enterprise_cadastre_situation.enterprise_cadastre_id = firm_id
      @enterprise_cadastre_situation.enterprise_cadastre_status_id = status
      @enterprise_cadastre_situation.observation = observation
      @enterprise_cadastre_situation.firm_user_id = user
      @enterprise_cadastre_situation.save
    end

  end
end
