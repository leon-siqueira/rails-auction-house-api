class Transaction < ApplicationRecord
  belongs_to :origin, polymorphic: true
  belongs_to :target, polymorphic: true
end
