class User < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :name, :nickname, :avatar

  normalize_attributes :terms_of_service, :email, :name

  validates :terms_of_service, :acceptance => true
  validates :email, :incorrect_email => true, :denied_email => true
  validates :nickname, :presence => true, :uniqueness => true, :format => /^[A-Za-z0-9_]{2,15}$/
  validates :name, :length => 3..150, :allow_blank => true

  def first_name
    name.split(' ')[0] unless name.blank?
  end

  def destroy
    self.email = "___old___#{email}"
    self.deleted_at = Time.now
    save
  end

end
