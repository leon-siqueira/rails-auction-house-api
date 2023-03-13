json.success true
json.data do
  json.art do
    json.partial! 'api/v1/arts/art', art: @art
  end
end
