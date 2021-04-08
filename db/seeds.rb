# create users
user_list = {
  "Akshay Gupta": 'kitallis@mailinator.com',
  "Nivedita Priyadarshini": 'nid@mailinator.com',
  "Preethi Govindarajan": 'pree@mailinator.com'
}
password = 'hunter2'
users = if User.all.blank?
          user_list.map do |name, email|
            User.create!(full_name: name, email: email, password: password)
          end
        else
          User.all
        end

# destroy existing non-user data
GameDeck.delete_all
GameUser.delete_all
Card.delete_all
Deck.delete_all
Game.delete_all

# create decks
names = %w[Adverbs Nouns Grammar Particles Vocab Nouns]
suffixes = %w[I 12 II III IV 2 X]
decks = names.zip(suffixes).shuffle.map(&:join).map do |name|
  Deck.create!(name: name, difficulty: Deck.difficulties.values.sample)
end

# create cards
cards = {
  cat: 'ねこ',
  dog: '犬',
  father: 'お父さん',
  mother: '母',
  sleep: 'ねます',
  write: 'かきます',
  grandfather: 'おじいさん'
}
decks.each do |deck|
  cards.each do |front, back|
    Card.create!(front: front, back: back, deck: deck)
  end
end

# create games
game_names = ['kit v nid', 'pree v gin']
game_names.each do |name|
  game = Game.create!(name: name, status: Game.statuses.values.sample, length: 5000)

  users.each do |user|
    GameUser.create!(game: game, user: user, status: GameUser.statuses.values.sample)
  end

  decks.each do |deck|
    GameDeck.create!(deck: deck, game: game, inverted: [true, false].sample)
  end
end

