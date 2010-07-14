# http://yardoc.org/docs/jnicklas-capybara/Capybara/Session
module Capybara
  class Session
    def has_form_to?(path, options={})
      has_xpath?("//form[@action=\"#{path}\"]", options)
    end
  end
end
