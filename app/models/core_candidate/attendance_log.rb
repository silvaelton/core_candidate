module Candidate
  class AttendanceLog < ActiveRecord::Base
    belongs_to :cadastre_mirror
    belongs_to :cadastre
    belongs_to :staff, class_name: "Person::Staff"
  end
end
