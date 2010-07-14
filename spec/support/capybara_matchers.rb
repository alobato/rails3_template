# http://yardoc.org/docs/jnicklas-capybara/Capybara/Session
module Capybara
  class Session
    def s(string)
      XPath.escape(string)
    end
    
    def has_form_to?(path, options={})
      has_xpath?("//form[@action=#{s(path)}]", options)
    end
  end
end
