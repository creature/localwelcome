module Capybara
  class Session
    def has_success_notice?
      has_selector? ".alert-info"
    end

    def has_error_notice?
      has_selector? ".alert-danger"

    end
  end
end
