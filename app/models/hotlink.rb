class Hotlink < ActiveRecord::Base
  
  attr_accessible :asset_id, :link, :expiry_date, :password, :days
  attr_accessor :password, :days
  
  before_save :encrypt_password
  
  validates_presence_of :asset_id, :link
  belongs_to :asset
  
  def self.authenticate(id, password)
    link = find(id)
    if link && link.password_hash == BCrypt::Engine.hash_secret(password, link.password_salt)
      link
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
    #set expiry date while we're at it (default 5 days)
    self.expiry_date = Time.now + (days.to_i || 5).days      
  end
  
end
