module Candidate
  module View
    class GeneralPontuation < ActiveRecord::Base
      self.table_name = 'general_pontuations'

      belongs_to :cadastre, class_name: "Candidate::Cadastre"
      belongs_to :dependent, class_name: "Candidate::Dependent"
      belongs_to :situation_status, class_name: "Candidate::SituationStatus"

      scope :by_income, -> (started_at = 0, ended_at = 1600) { where(income: started_at..ended_at) }
      scope :by_cpf, -> (cpf) {

        current = find_by(cpf: cpf.to_s.unformat_cpf)

        where(total: (current.total - 0.400)..(current.total + 0.400))
      }
      scope :by_name, -> (name) {

        where("name ILIKE '%#{name}%' ")

      }

      def position_calc! per_page, page, collection, id

        index = collection.map(&:id).find_index(id)
        index = index + 1
        page  = page.present? ? (page.to_i - 1) : 0

        ((per_page * page) + index).to_s
      end

      def self.paginate
        self
      end

      def cadastre
        Candidate::Cadastre.find(self.id) rescue nil
      end


      def self.is_olders?(date)
        age = date - 60.years
        self.where(born: age, situation_status_id: 4).count
      end

    end
  end
end
