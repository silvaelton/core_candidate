module Candidate
  class Question < ActiveRecord::Base
    belongs_to :ticket
    belongs_to :subject
    belongs_to :staff, class_name: "Person::Staff" 
    validates :attachment, file_size: { less_than_or_equal_to: 100.megabytes.to_i,
                               message: "Arquivo não pode exceder 100 MB" }

    mount_uploader :attachment, Wiki::FileUploader
  end
end
