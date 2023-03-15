json.data do
  json.array! @bids, partial: 'api/v1/bids/bid', as: :bid
end
