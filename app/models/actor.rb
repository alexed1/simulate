class Actor

	attr_accessor :id, :start_period, :theft, :lease_price, :name, :monthly_payment

	def initialize(params, id, simulation, period)
 		@id = id
 		@start_period = period.to_i
 		@theft = params["theft?"]
 		@lease_price = params["average_item_price"].to_f
 		@name = params["name"]
 		debugger
 		@monthly_payment = simulation.target_apr/100 * @lease_price / $LOAN_PERIODS
 		@payments = {}
 		self.calc_payments(simulation)


	end 

#TODO verify residual is working and that zeroes are filled in properly.
	def calc_payments(simulation)
		i = 1
		simulation.simulation_periods.times do |period|
			debugger
			period +=1
			if @start_period > period
				#actor hasn't executed their lease yet
				@payments[period] = 0
			elsif period > (@start_period + $LOAN_PERIODS)
				#actor lease is complete
				@payments[period] = 0
			else
				#there's an actual payment to be calculated
				payment = @monthly_payment
				if period == @start_period
					#this is the first period of the lease, so subtract the total lease price to represent our outlay
					payment -= @lease_price
				end
				if period == @start_period + $LOAN_PERIODS
					#this is the last period of the lease, add in residual value if appropriate
					if !@theft
						payment += simulation.residual_value * @lease_price
					end
				end
				puts "payment for period #{period} is #{payment}"
				@payments[period] = payment

			end
				
		end


	end

end