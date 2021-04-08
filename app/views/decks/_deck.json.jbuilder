json.extract! deck, :id, :name, :difficulty, :created_at, :updated_at
json.url deck_url(deck, format: :json)
