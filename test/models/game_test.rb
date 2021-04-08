require 'test_helper'

class GameTest < ActiveSupport::TestCase
  describe '#questions' do
    it 'returns cards IDs and the question' do
      game = create_game
      deck = create_deck
      cards = create_cards(deck)
      create_game_deck(game, deck)

      expected = [
        [cards[0].id, cards[0].front],
        [cards[1].id, cards[1].front]
      ]

      expect(game.questions.sort).must_equal expected.sort
    end

    it 'returns cards for both normal and inverted decks' do
      game = create_game
      regular_deck = create_deck
      regular_cards = create_cards(regular_deck)
      create_game_deck(game, regular_deck)
      inverted_deck = create_deck
      inverted_cards = create_cards(inverted_deck)
      create_game_deck(game, inverted_deck, true)

      expected = [
        [regular_cards[0].id, regular_cards[0].front],
        [regular_cards[1].id, regular_cards[1].front],
        [inverted_cards[0].id, inverted_cards[0].back],
        [inverted_cards[1].id, inverted_cards[1].back]
      ]

      expect(game.questions.sort).must_equal expected.sort
    end
  end

  describe '#start' do
    it "updates the game status to 'playing'" do
      game = create_game

      game.start!

      expect(game.playing?).must_equal true
    end

    it "raises an exception if status is 'stopped'" do
      game = create_game(:stopped)

      expect { game.start! }.must_raise Game::InvalidStatusChange
    end
  end

  private

  def create_deck
    Deck.create!(name: 'MAD')
  end

  def create_cards(deck)
    [
      Card.create!(front: 'A', back: 'B', deck: deck),
      Card.create!(front: 'X', back: 'Y', deck: deck)
    ]
  end

  def create_game(status = :created)
    Game.create!(name: 'Spy vs Spy', length: 100, status: status)
  end

  def create_game_deck(game, deck, inverted = false)
    GameDeck.create!(game: game, deck: deck, inverted: inverted)
  end
end
