# frozen_string_literal: true

class AddUsernameAndFullNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :full_name, :string
  end
end
