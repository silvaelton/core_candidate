module Candidate
  class UpdateRegularization < ::Candidate::Cadastre

    attr_accessor :observation

    validates :observation, presence: true

  end
end
