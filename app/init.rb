require 'yaml'
require 'debugger'


#load all of the profiles files

def init_profiles

  #load all the profiles
  profiles = {}

  Dir.foreach('../profiles') do |item|
  	next if item == '.' or item == '..'
  	profile = YAML.load_file('../profiles/' + item)
  	validate_profile(profile, item)
    #extract the name from the yaml and use it as the key for this profile
    profiles[profile['name']] = profile
  end
  return profiles
end




#actors are generated using the profiles as templates, and using the Load List from the Simulation
#load list comes in from the yaml as an array of arrays
#the first value of each array is the period that particular packet of actors start their leases
def init_actors(load_list)
  load_list.each { |period_list|
    period = period_list.shift
    #start a counter to generate ids
    id = 1
    period_list.each { |actor|
      actor_id=period.to_s + "-" + id.to_s
      id += 1
      actor_profile = $PROFILES.select {|k,v|
        k == actor
      }
      actor_obj = Actor.new(actor_profile, actor_id)
      

    }

  }

end





def init_simulations
  #load all the simulations
  simulations = []
  Dir.foreach('../simulations') do |item|
    next if item == '.' or item == '..'
    simulation = YAML.load_file('../simulations/' + item)
    validate_simulation(simulation, item)
    actors = init_actors(simulation['load_list'])
    sim_obj = Simulation.new(simulation)
    simulations << sim_obj
  end
  #puts simulations.inspect
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



$PROFILES = init_profiles
init_simulations

