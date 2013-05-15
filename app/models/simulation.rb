class Simulation

	attr_accessor :target_apr, :simulation_periods, :iterations, :residual_value, :name

def initialize(params)
  @simulation_periods = params['iterations']
  @target_apr = params['target_apr']
  @residual_value = params['residual_value']
  @name = params['name']
end 

end