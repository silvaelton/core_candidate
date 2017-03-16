module Candidate
  module View
    class GeneralSituation < ActiveRecord::Base
      self.table_name = 'general_situations'

      belongs_to :cadastre, class_name: "Candidate::Cadastre"
      belongs_to :situation_status, class_name: "Candidate::SituationStatus"
      belongs_to :procedural_status, class_name: "Candidate::ProceduralStatus"



      def self.paginate
        self
      end

      def cadastre
        Candidate::Cadastre.find(self.id) rescue nil
      end

    end
  end
end
