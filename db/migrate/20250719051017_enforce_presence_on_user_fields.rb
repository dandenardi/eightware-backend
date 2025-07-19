class EnforcePresenceOnUserFields < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :jti, false
  end
end
