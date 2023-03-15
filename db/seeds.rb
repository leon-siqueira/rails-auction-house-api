# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

player1 = User.create(email: 'jon.doe@email.com', password: 'pass1234', balance: 100_000)
player2 = User.create(email: 'jim.doe@email.com', password: 'pass1234', balance: 100_000)

Art.create(creator: player1, owner: player1, author: 'Da Vinci', title: 'Mona Lisa', year: '1500',
           description: 'Woman smiling')
Art.create(creator: player1, owner: player1, author: 'Van Gogh', title: 'Starry Night', year: '1889',
           description: 'Night with stars')
Art.create(creator: player2, owner: player2, author: 'Botticelli', title: 'Venus Birth', year: '1489',
           description: 'Venus being born')
