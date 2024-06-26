# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rails.logger.debug 'Creating users...'
player1 = User.create(email: 'jon.doe@email.com', password: 'pass1234', balance: 100_000)
User.create(email: 'jim.doe@email.com', password: 'pass1234', balance: 100_000)

arts = ArtveeScraper.scrape
Rails.logger.debug 'Creating arts...'
arts.each do |art|
  Rails.logger.debug { "#{art[:title]} by #{art[:artist]}" }
  Art.create(creator: player1,
             owner: player1,
             author: art[:artist],
             title: art[:title],
             img_url: art[:img_url],
             year: art[:date],
             description: art[:tag])
end
