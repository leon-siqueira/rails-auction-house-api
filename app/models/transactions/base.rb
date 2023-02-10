module Transactions
  class Base < ApplicationRecord
    belongs_to :origin, polymorphic: true
    belongs_to :target, polymorphic: true

    def self.table_name
      'transactions'
    end
  end
end
