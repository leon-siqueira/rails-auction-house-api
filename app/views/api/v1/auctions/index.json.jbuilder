# frozen_string_literal: true

json.data do
  json.array! @auctions, partial: 'api/v1/auctions/auction', as: :auction
end
