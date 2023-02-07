# == Schema Information
#
# Table name: auctions
#
#  id          :bigint           not null, primary key
#  art_id      :bigint           not null
#  description :string           default(""), not null
#  minimal_bid :integer
#  start_date  :datetime
#  end_date    :datetime
#  status      :enum
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Auction < ApplicationRecord
  belongs_to :art

  enum :status, { scheduled: 'scheduled', in_progress: 'in_progress', finished: 'finished'}
end
