class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def occurred_at_local_date
    (self.occurred_at + self.timezone_offset.to_i.hours).to_date
  end
end
