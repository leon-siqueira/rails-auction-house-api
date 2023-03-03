# == Schema Information
#
# Table name: bids
#
#  id         :bigint           not null, primary key
#  auction_id :bigint           not null
#  user_id    :bigint           not null
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :user
end
