%w{api_controller authorizations guarded tokens}.each do |name|
  require "ember/beercan/controllers/#{name}"
end

require "ember/beercan/controllers/mixins/find_me"