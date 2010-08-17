# http://www.perfectline.co.uk/blog/building-ruby-on-rails-3-custom-validators#comments

class IncorrectEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    domains = %w(hotmail.com.br gmail.com.br)
    domains.each do |d|
      if value && value.include?("@#{d}")
        record.errors[attribute] << 'está incorreto'
        break
      end
    end
  end
end

class DeniedEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    domains = %w(mailinator.com dodgit.com uggsrock.com spambox.us spamhole.com spam.la trashymail.com guerrillamailblock.com spamspot.com spamfree tempomail.fr jetable.net maileater.com meltmail.com)
    domains.delete 'mailinator.com' if Rails.env == 'development'
    domains.each do |d|
      if value && value.include?("@#{d}")
        record.errors[attribute] << 'inválido'
        break
      end
    end
  end
end
