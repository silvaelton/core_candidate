module CoreCandidate
  class CadastrePresenter < ApplicationPresenter
    
    def current_convocation
      self.cadastre_convocations.where(status: true).last.convocation
    end

    def current_convocation_with_id
      current = self.cadastre_convocations.where(status: true).last
      "#{current.convocation.id} #{current.convocation.description}"
    end

    def current_convocation_without_id
      current = self.cadastre_convocations.where(status: true).last
      "#{current.convocation.description}"
    end

    def deadline_indication

      @inactives = self.enterprise_cadastres.where(inactive: true, indication_type_id: [1,4])

      if @inactives.present?

        @year    = @inactives.first.inactive_date + 4.years
        @dealine = @year.strftime("%d/%m/%Y")

        if @year > Date.today
          @month = ((Date.today.year - 1) * 12 + Date.today.month) - ((@year.year - 1) * 12 + @year.month)

          case @month.divmod(12)[0]
          when -4
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when -3
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when -2
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when -1
            @result = "Faltam #{(@month.divmod(12)[0] + 1) * -1} ano(s) e #{12 - @month.divmod(12)[1]} mes(es)"
          when 0
            @result = "Faltam poucos dias para exceder o prazo."
          else
           @result  = "Prazo excedido"
          end

        end

        {
         count:   @inactives.count,
         first:   @inactives.first.inactive_date.present? ? @inactives.first.inactive_date.strftime('%d/%m/%Y') : "Sem informação",
         end:     @year.strftime("%d/%m/%Y"),
         result:  @result
        }

      else
        nil
      end

    end

    def current_cadastre_address
      self.cadastre_address.order('created_at ASC').last rescue nil
    end

    def current_cadastre_address_allocate
      self.cadastre_address.order('created_at ASC').last rescue nil
    end

    def current_indication_status
      if self.enterprise_cadastres.present?
        last_indication = self.enterprise_cadastres.order('created_at').last
        if last_indication.inactive == true && (last_indication.indication_type_id == 1 || last_indication.indication_type_id == 4)
          "#{self.current_situation_name} - #{self.enterprise_cadastres.where(inactive: true).count}º RECUSA - #{last_indication.enterprise.name}"
        elsif self.enterprise_cadastres.nil?
          self.current_situation_name
        elsif last_indication.indication_type_id == 2
          self.current_situation_name
        else
          "#{self.current_situation_name} - INDICADO - #{last_indication.enterprise.name}"
        end
      else
        self.current_situation_name
      end
    end

    def current_indication
      if self.enterprise_cadastres.present?
        last_indication = self.enterprise_cadastres.order('created_at').last
        if last_indication.inactive == false && (last_indication.indication_type_id == 1 || last_indication.indication_type_id == 4)
          "#{last_indication.enterprise.name}"
        end
      end
    end

    def count_denial
      if self.enterprise_cadastres.present?
        "#{self.enterprise_cadastres.where(inactive: true).count}"
      end
    end

    def ocurrences
      self.occurrences.where(solved: false) rescue nil
    end

    def assessment
      self.assessments.where(prefex: ['392', '390', '102','120'], document_type_id: 1).first rescue nil
    end

    def last_cadastre_mirror
      self.cadastre_mirrors.order('id ASC').last rescue nil
    end

    def penultimate_pontuation
      self.pontuations.order('id DESC').second rescue nil
    end

    def penultimate_pontuation_total
      self.pontuations.order('id DESC').second.total rescue 0
    end

    def last_pontuation
      self.pontuations.order('id DESC').first rescue nil
    end

    def last_pontuation_total
      self.pontuations.order('id DESC').first.total rescue 0
    end

    def spouse
      self.dependents.where(kinship_id: 6).first rescue nil
    end



    #validates :cpf, cpf: true

    def current_program_name
      program.name.downcase rescue t(:no_information)
    end

    def current_procedural
      self.cadastre_procedurals.last rescue I18n.t(:no_information)
    end

    def current_procedural_id
      self.cadastre_procedurals.last.id rescue I18n.t(:no_information)
    end

    def current_procedural_status_id
      self.cadastre_procedurals.last.procedural_status_id rescue I18n.t(:no_information)
    end

    def enabled?
      self.current_situation_id == 4
    end

    def convoked?
      self.current_situation_id == 3
    end

    def self.updated_day(day)
      self.where(updated_at: day).count
    end

    def schedules
      Schedule::AgendaSchedule.where(cpf: self.cpf)
    end

    def current_cadastre_address
      cadastre_address.order('id ASC').last rescue nil
    end

    def current_situation
      cadastre_situations.order('created_at ASC').last rescue I18n.t(:no_information)
    end

    def current_situation_id
      cadastre_situations.order('created_at ASC').last.situation_status_id rescue I18n.t(:no_information)
    end

    def current_situation_status
      cadastre_situations.order('created_at ASC').last.situation_status.status rescue I18n.t(:no_information)
    end

    def current_situation_name
      cadastre_situations.order('created_at ASC').last.situation_status.name rescue I18n.t(:no_information)
    end

    def age
      ((Date.today - self.born).to_i / 365.25).to_i rescue I18n.t(:no_information)
    end


    def special?
        (self.special_condition_id == 2 || self.special_condition_id == 3) || self.program_id == 5
    end

    def older?
        if self.born.present?
          (self.age >= 60)
        else
          false
        end
    end

    def zone?
        case self.income
        when 0..1600
          [1, 0, 1600]
        when 1601..3275
          [2, 1601, 3275]
        when 3276..5000
          [3, 3276, 5000]
        else
          [4, 5001, 99999]
        end
    end


    def special_family?
      self.dependents.where(special_condition_id: [2,3]).present?
    end

    def older_family?
      self.dependents.where('extract(year from age(born)) >= 60').present?
    end

    def list
      array = Array.new


      list_rii          = rii
      list_rie          = rie
      list_olders       = olders
      list_vulnerables  = vulnerables
      list_specials     = specials

      array << list_rii         unless list_rii.nil?
      array << list_rie         unless list_rie.nil?

      if self.current_situation_id != 2
        array << list_olders      unless list_olders.nil?
        array << list_vulnerables unless list_vulnerables.nil?
        array << list_specials    unless list_specials.nil?
      end

      array.each_with_index do |a, i|
        array[i] << position(array[i])
      end

      array
    end

    private

    def rii
      (self.program_id == 1) ? ['rii', self.zone?] : nil
    end

    def rie
      (self.program_id == 2) ? ['rie', self.zone?] : nil
    end

    def specials
      (self.special? || self.special_family?) ? ['special', self.zone?] : nil
    end

    def olders
      (self.older? || self.older_family?) ? ['older', self.zone?] : nil
    end

    def vulnerables
      (self.program_id == 4) ? ['vulnerable', self.zone?] : nil
    end

    def position(array)

        if array[0] == 'rii' || array[0] == 'rie'
            if [2,52].include? self.current_situation_id

              sql = "program_id = ? AND code = 20141201"
              @geral = Candidate::View::GeneralPontuation.select(:id)
                                                         .where(sql,
                                                                self.program_id)
                                                         .map(&:id)
                                                         .find_index(self.id)
            else

              sql = "program_id = ? AND
                     situation_status_id = ?
                     AND convocation_id > 1524
                     AND procedural_status_id IN(14, 72)
                     AND income BETWEEN ? AND ?"

              @geral = Candidate::View::GeneralPontuation.select(:id)
                                                         .where(sql,
                                                                self.program_id,
                                                                self.current_situation_id,
                                                                array[1][1],
                                                                array[1][2])
                                                         .map(&:id)
                                                         .find_index(self.id)
            end
        else
            case array[0]
            when 'older'

                sql = "(extract(year from age(born)) >= 60 or (select COUNT(*)
                       from candidate_dependents
                       where extract(year from age(born)) >= 60
                       and cadastre_id = general_pontuations.id) > 0)
                       AND convocation_id > 1524
                       AND procedural_status_id IN(14, 72)
                       AND situation_status_id = ?
                       AND income BETWEEN  ? AND ?"

                @geral = Candidate::View::GeneralPontuation.select(:id)
                                                           .where(sql,
                                                                  self.current_situation_id,
                                                                  array[1][1],
                                                                  array[1][2])
                                                           .map(&:id)
                                                           .find_index(self.id)
            when 'special'
                sql = "(special_condition_id in (2,3) or (select COUNT(*)
                        from candidate_dependents
                        where special_condition_id in (2,3)
                        and cadastre_id = general_pontuations.id) > 0)
                        and situation_status_id = ?
                        and convocation_id > 1524
                        and procedural_status_id IN(14, 72)
                        and income BETWEEN ? AND ?"

                @geral = Candidate::View::GeneralPontuation.select(:id)
                                                           .where(sql,
                                                                  self.current_situation_id,
                                                                  array[1][1],
                                                                  array[1][2])
                                                           .map(&:id).find_index(self.id)

            when 'vulnerable'
                sql = "program_id = ?
                      AND convocation_id > 1524
                      AND procedural_status_id IN(14, 72)
                      AND income BETWEEN ? AND ?"

                @geral = Candidate::View::GeneralPontuation.select(:id)
                                                           .where(sql,4,
                                                                  array[1][1],
                                                                  array[1][2])
                                                           .map(&:id).find_index(self.id)
            end
        end

        @geral.present? ? @geral + 1 : nil
    end



  end
end