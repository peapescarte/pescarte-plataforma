defmodule Fuschia.Common.Common do

def build_user_name(user) do
  if user.middle_name do
    "#{user.first_name} #{user.middle_name} #{user.last_name}"
  else
    "#{user.first_name} #{user.last_name}"
  end
end

end
