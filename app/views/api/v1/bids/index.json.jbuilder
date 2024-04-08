json.success true
json.data do
  json.array! @bids, partial: 'api/v1/transactions/bid', as: :bid
end
