module Candidate
  class CadastrePassword < ::Candidate::Cadastre

    attr_accessor :array

    def self.random_attributes
      @array
    end

    def self.random_values
      @array = []

      %w(born_uf born name address telephone).each_with_index do |attr, index|  
        @array[index]    = []
        @array[index][0] = self.send(attr)
        @array[index][1] = random_candidate.send(attr)
        @array[index][2] = random_candidate.send(attr)
        @array[index][3] = random_candidate.send(attr)
        @array[index][4] = random_candidate.send(attr)
      end

      @array = attr_uniq @array

    end

    def self.random_candidate
      ::Candidate::Cadastre.find(rand(0..400_000)) rescue random_candidate
    end

    def self.attr_uniq array
      array.each_with_index do |arr, index|
        @array[index] = @array[index].uniq
      end
    end

  end
end