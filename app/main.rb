
#this is hardwired because all the ymls have to be manually adjusted with new distributions if this changes
$LOAN_PERIODS = 12
$USE_DEBUG = true
require 'debugger'
require 'csv'
require './common'
require './models/simulation'
require './models/actor'
require './init'


$PROFILES = init_profiles
actors, simulations = init_simulations

simulations[0].print(actors)
