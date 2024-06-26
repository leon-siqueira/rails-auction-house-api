# frozen_string_literal: true

json.data do
  json.user do
    json.call(
      @user,
      :email,
      :id
    )
  end

  json.token @token
end
