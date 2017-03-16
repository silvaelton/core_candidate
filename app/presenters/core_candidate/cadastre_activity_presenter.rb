module CoreCandidate
  class CadastrePresenter < ApplicationPresenter

    def self.create_simple_log!(options = {})
      cadastre_id        = options[:cadastre_id] ||= nil
      staff_id           = options[:staff_id] ||= nil
      activity_status_id = options[:activity_status_id] ||= nil
      type_activity      = options[:type_activity] ||= nil
      type_ocurrency     = options[:type_ocurrency] ||= nil
      observation        = options[:observation] ||= nil
      cadastre_mirror_id = options[:cadastre_mirror_id] ||= nil


      object = self.new
      object.cadastre_id = cadastre_id
      object.staff_id = staff_id
      object.activity_status_id = activity_status_id
      object.type_activity = type_activity
      #object.type_ocurrency = type_ocurrency
      object.observation = observation
      object.cadastre_mirror_id = cadastre_mirror_id

      object.save
    end
    
  end
end
