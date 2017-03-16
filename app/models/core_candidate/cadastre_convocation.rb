module Candidate
  class CadastreConvocation < ActiveRecord::Base

    belongs_to :convocation
    belongs_to :cadastre


  end
end
