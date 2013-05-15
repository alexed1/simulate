class Simulation

	attr_accessor :target_apr, :simulation_periods, :iterations, :residual_value, :name

def initialize(params)
  @iterations = params['iterations']
  @simulation_periods = params['lease_periods']
  @target_apr = params['target_apr']
  @residual_value = params['residual_value']
  @name = params['name']
end 

end