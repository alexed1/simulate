require 'yaml'
require 'debugger'

#load all of the profiles files

def init_profiles

  #load all the profiles
  profiles = []
  Dir.foreach('../profiles') do |item|
  	next if item == '.' or item == '..'
  	profile = YAML.load_file('../profiles/' + item)
  	validate_profile(profile, item)
  	profiles << profile
  end
  puts profiles.inspect

end


def init_simulations
  #load all the simulations
  simulations = []
  Dir.foreach('../simulations') do |item|
    next if item == '.' or item == '..'
    simulation = YAML.load_file('../simulations/' + item)
    validate_simulation(simulation, item)
    simulations << simulation
  end
  puts simulations.inspect
end

def validate_profile(profile, filename)
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

  raise "we don't allow the filename and the 'name' key to have different values, because misery will result" if filename != profile['name'] + '.yml'
end

def validate_simulation(simulation, filename)
if filename != simulation['name'] + '.yml'
    raise "we don't allow the filename and the 'name' key to have different values, because misery will result" 
end
 #TODO add error checking
end



init_profiles
init_simulations

