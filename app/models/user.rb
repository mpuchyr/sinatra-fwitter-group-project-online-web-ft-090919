class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true

  def slug
    slug = username.split(" ")
    slug.join("-")
  end

  def self.find_by_slug(slug)
    user = slug.split("-").join(" ")
    self.find_by(username: user)
  end
end
