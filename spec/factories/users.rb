Factory.define :user, :class => User do |u|
  u.email "email@email.com"
  u.password "123456"
  u.password_confirmation '123456'
end
