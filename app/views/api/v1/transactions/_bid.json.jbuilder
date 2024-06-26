# frozen_string_literal: true

json.id bid.id
json.auction_id bid.receiver_id
json.user_id bid.giver_id
json.amount bid.amount
json.created_at bid.created_at
json.updated_at bid.updated_at

json.url api_v1_bid_url(bid)
