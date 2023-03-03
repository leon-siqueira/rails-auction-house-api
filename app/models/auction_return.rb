# == Schema Information
#
# Table name: auction_returns
#
#  id         :bigint           not null, primary key
#  auction_id :bigint           not null
#  user_id    :bigint           not null
#  kind       :enum
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AuctionReturn < ApplicationRecord
  belongs_to :auction
  belongs_to :user

  enum :kind, { covered_bid: 'covered_bid', income: 'income', refund: 'refund' }
end
