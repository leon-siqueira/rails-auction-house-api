json.success true
json.data do
  json.user do
    json.partial! 'users/user', user: @user
  end
end
