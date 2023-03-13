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
  belongs_to :owner, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_many :auctions, dependent: :nullify
end
