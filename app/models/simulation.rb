class Simulation

def initialize(params)
  @iterations = params['iterations']
  @lease_periods = params['lease_periods']
  @target_apr = params['target_apr']
  @residual_value = params['residual_value']
  @name = params['name']
end 

end