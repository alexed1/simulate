class Simulation
	include ::Simulate::Common


	attr_accessor :target_apr, :simulation_periods, :iterations, :residual_value, :name, :aggregates

	def initialize(params)
	  @simulation_periods = params['iterations']
	  @target_apr = params['target_apr']
	  @residual_value = params['residual_value']
	  @name = params['name']
	  @aggregates = init_aggregates
	end 


	def print(actors)
		header_row = []
		header_row << ""
		@simulation_periods.times do |period|
			header_row << (period+1).to_s
		end

		CSV.open("../data/data.csv", "w+") do |csv|
			csv << header_row
			actors.each { |actor|
				row = []
				row << actor.name
				row = row + actor.cash_flows
				csv << row
			}

			@aggregates.each { |k,v|
				row = []
				row << k
				row = row + v
				csv << row
			}
			debug("CSV file UPDATED!")


		end
	end

	#aggregates tracks different aggregated data like total capital invested
	def init_aggregates
		store = {}
		types = ["capital_deployed","payments_received","residual_value_tangible","writeoffs", "period_cash_flow"]
		types.each { |aggregate|
			store[aggregate] = []
			#initialize empty rows
			@simulation_periods.times do |i|
				store[aggregate][i] = 0

			end

		}


		return store
	end




end