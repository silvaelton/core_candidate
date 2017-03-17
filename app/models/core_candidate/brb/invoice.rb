module CoreCandidate
  module Brb
    class Invoice < ApplicationRecord
      self.table_name = 'extranet.brb_invoices'
    end
  end
end
