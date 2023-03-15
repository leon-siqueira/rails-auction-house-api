# == Schema Information
#
# Table name: arts
#
#  id          :bigint           not null, primary key
#  author      :string
#  year        :string
#  title       :string
#  description :string
#  creator_id  :bigint           not null
#  owner_id    :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Art < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_many :auctions, dependent: :nullify
end
