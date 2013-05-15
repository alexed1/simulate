require 'yaml'
require 'debugger'

#load all of the profiles files

def init
  profiles = []
  Dir.foreach('../profiles') do |item|
  	next if item == '.' or item == '..'
  	profile = YAML.load_file('../profiles/' + item)
  	validate_profile(profile)
  	profiles << profile
  end
  puts profiles.inspect
end



def validate_profile(profile)
	puts ""
  puts "validating profile" + profile['name']
  raise "all entries must be config_type = profile" if profile['config_type'] != 'profile'
  
  #make sure the percentages add up to 1
  total = 0
  12.times do |i|
    key = 'pct_complete_' + (i+1).to_s + '_payment'
    total += profile[key].to_i
  end
  if total != 100 
    raise "the collected set of percentage completes must add up to 100"
  end
  raise "theft percentage must be between 0 and 100" if profile['pct_theft'].to_i > 100 or profile['pct_theft'].to_i < 0

  raise "item price must be between 25 and 2000" if profile["average_item_price"].to_i > 2000 or profile["average_item_price"].to_i < 25

end


init
