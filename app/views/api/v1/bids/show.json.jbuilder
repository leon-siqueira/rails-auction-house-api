# frozen_string_literal: true

json.success true
json.data do
  json.bid do
    json.partial! 'api/v1/transactions/bid', bid: @bid
  end
end
