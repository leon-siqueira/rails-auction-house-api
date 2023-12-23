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
#  token_expiration       :datetime
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_arts, class_name: 'Art', foreign_key: 'creator_id'
  has_many :owned_arts, class_name: 'Art', foreign_key: 'owner_id'
  has_many :auctions
  has_many :transactions, as: :giver, inverse_of: :giver, class_name: 'Transaction'
  has_many :transactions, as: :receiver, inverse_of: :receiver, class_name: 'Transaction'

  after_update :update_balance, if: :saved_change_to_transactions?

  def update_balance
    self.balance = transaction.where(receiver: self).sum(:amount) - transaction.where(giver: self).sum(:amount)
    save
  end
end
