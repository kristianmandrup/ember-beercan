%w{sorcery devise}.each do |name|
  require "ember/beercan/tokeners/#{name}_tokener"
end