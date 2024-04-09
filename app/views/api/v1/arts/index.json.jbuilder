# frozen_string_literal: true

json.data do
  json.array! @arts, partial: 'api/v1/arts/art', as: :art
end
