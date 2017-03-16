module CoreCandidate
  class CadastreMirrorPresenter < ApplicationPresenter

    FAMILY_INCOME = 937 * 12

    def complete_address
      "#{self.address} #{self.address_complement}"
    end

    def spouse
      self.dependent_mirrors.where(kinship_id: 6).first rescue nil
    end

    def age
      (Date.today - self.born).to_i / 365.25
    end

    def pontuation?
      CoreCandidate::Pontuation.where(cadastre_mirror_id: self.id).present?
    end


    def arrival_df_time(date)
      date.year - self.arrival_df.strftime("%Y").to_i if self.arrival_df.present?
    end

    def timelist_time(date)
      date.year - self.created_at.year
    end

    def self.check_arrival_df(id)
      mirror = CoreCandidate::CadastreMirror.find(id)

      (Date.today - self.born).to_i / 365
      date = Date.parse(mirror.arrival_df) rescue nil

      if date.present?
        ((Date.today - date).to_i / 365) < 5
      else
        false
      end
    end

    def self.family_income_calc(id)
      mirror = CoreCandidate::CadastreMirror.find(id)
      income_dep = mirror.dependent_mirrors.sum(:income)

      (income_dep + mirror.income) > FAMILY_INCOME
    end

  end
end
