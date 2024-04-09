# frozen_string_literal: true

class AddUserToAuctions < ActiveRecord::Migration[7.0]
  def change
    add_reference :auctions, :user, foreign_key: true
  end
end
