# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  kind       :enum
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Role < ApplicationRecord
  belongs_to :user

  enum :kind, { admin: 'admin', auctioneer: 'auctioneer', artist: 'artist', buyer: 'buyer' }
end
