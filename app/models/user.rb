class User < ApplicationRecord
  belongs_to :employer, polymorphic: true
end
