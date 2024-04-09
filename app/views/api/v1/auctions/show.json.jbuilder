# frozen_string_literal: true

json.success true
json.data do
  json.auction do
    json.partial! 'api/v1/auctions/auction', auction: @auction
  end
end
