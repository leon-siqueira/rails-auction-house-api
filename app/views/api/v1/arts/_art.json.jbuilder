# frozen_string_literal: true

json.extract! art, :id, :title, :author, :year, :description, :creator_id, :owner_id, :created_at, :updated_at, :img_url
json.url api_v1_art_url(art)
