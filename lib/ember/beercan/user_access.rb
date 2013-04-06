module UserAccess
  AUTH_TYPES = [
    FaceBook,
    Twitter,
    GitHub,
    Password
  ]

  def self.authenticate(params)
    AUTH_TYPES.detect{|auth| auth.can_handle?(params) }.try(:authenticate, params)
  end

  module FaceBook
    def self.can_handle?(params)
      params.has_key?(:facebook_id)
    end

    def self.authenticate(params)
    end
  end

  module Google
    def self.can_handle?(params)
      params.has_key?(:google_id)
    end

    def self.authenticate(params)
    end
  end

  module Twitter
    def self.can_handle?(params)
      params.has_key?(:twitter_id)
    end

    def self.authenticate(params)
    end
  end

  module Password
    def self.can_handle?(params)
      params.has_key?(:username) && params.has_key?(:password)
    end

    def self.authenticate(params)
    end
  end
end  