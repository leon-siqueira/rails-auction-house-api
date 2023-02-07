# == Schema Information
#
# Table name: arts
#
#  id          :bigint           not null, primary key
#  author      :string
#  year        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string
#  user_id     :bigint
#
class Art < ApplicationRecord
  belongs_to :user
  has_many :auctions
end
