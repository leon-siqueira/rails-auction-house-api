# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  balance                :integer
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_arts, class_name: 'Art', foreign_key: 'creator_id'
  has_many :owned_arts, class_name: 'Art', foreign_key: 'owner_id'
  has_many :bids
  has_many :auction_returns

  def transaction_history
    transactions = []
    transactions << Bids.where(user: self)
    transactions << AuctionReturns.where(user: self)
    transactions.flatten.sort_by(&:created_at)
  end
end
