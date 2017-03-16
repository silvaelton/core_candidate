require 'csv'

module Candidate
  class EnableCandidate
    include ActiveModel::Model

    attr_accessor :candidate_file, :staff_id, :observation

    validates :candidate_file, :staff_id, :observation, presence: true

    def process_file
      
      CSV.foreach(self.candidate_file, col_sep: ';') do |row|
        
      end

    end

    private

    def enable_situation cadastre
      #atualiza situaçao cadastral
      situation = cadastre.cadastre_situations.new({

      })

      #atualiza situacao processual
      processual = cadastre.cadastre_processuals.new({

      })
    end

    def write_log
    end

  end
end