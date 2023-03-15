json.success true
json.data do
  json.bid do
    json.partial! 'api/v1/bids/bid', bid: @bid
  end
end
