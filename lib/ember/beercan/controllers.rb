%w{authorizations guarded tokens}.each do |name|
  require "ember/beercan/controllers/#{name}"
end