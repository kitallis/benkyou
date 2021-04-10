# create players
user_list = {
  "Akshay Gupta": "kitallis@mailinator.com",
  "Nivedita Priyadarshini": "nid@mailinator.com",
  "Preethi Govindarajan": "pree@mailinator.com",
  "Ragini Vijay": "gin@mailinator.com",
  "Sagarika Padha": "pop@mailinator.com",
  "Aarika Solanki": "aariks@mailinator.com",
  "Andrea": "andrea@mailinator.com"
}
password = "hunter2"
users = if User.all.blank?
          user_list.map do |name, email|
            User.create!(full_name: name, email: email, password: password)
          end
        else
          User.all
        end

# destroy existing non-user data
GameDeck.delete_all
Play.delete_all
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
  cat: "ねこ",
  dog: "犬",
  father: "お父さん",
  mother: "母",
  sleep: "ねます",
  write: "かきます",
  grandfather: "おじいさん"
}
decks.each do |deck|
  cards.each do |front, back|
    Card.create!(front: front, back: back, deck: deck)
  end
end

# create games
game_names = ["kit v nid", "pree v gin"]
game_names.each do |name|
  game = Game.new(name: name, status: Game.statuses.values.sample, length: 5000)

  plays = [users.first, users.drop(1).sample(3)].flatten.map do |user|
    Play.new(game: game, user: user, status: Play.statuses.values.sample)
  end

  game_decks = decks.map do |deck|
    GameDeck.new(deck: deck, game: game, inverted: [true, false].sample)
  end

  game.game_decks = game_decks
  game.plays = plays

  game.save!
end
