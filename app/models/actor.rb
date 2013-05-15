class Actor
	include ::Simulate::Common

	attr_accessor :id, :start_period, :theft_occurs, :payment_count, :lease_price, :name, :monthly_payment

	def initialize(params, id, simulation, period)
 		@id = id
 		
 		@start_period = period.to_i
 		@theft_occurs = calc_theft(params["pct_theft"])
 		@payment_count = calc_payment_count(params)
 		@lease_price = params["average_item_price"].to_f
 		@name = params["name"]
 		@monthly_payment = calc_monthly_payment(simulation)
 		@payments = {}
 	
 		output_row = calc_cash_flows(simulation)
 		puts "theft is #{theft_occurs}"
 		puts "payment count is #{payment_count}"
 		puts "cash flows are:"
 		puts output_row
	end 

	def calc_monthly_payment (simulation)
		monthly_payment = simulation.target_apr/100 * @lease_price / $LOAN_PERIODS
	end

  #the profile carries a liklihood for there to be a theft
	def calc_theft(percent)
		if rand > (percent.to_f/100)
			return true
		else
			return false
		end
	end

	def calc_payment_count(params)
		 i = rand(100)
		 array = params['pay_period_percentages']
		 raise "pay period percentages have to be ordered. something's wrong" if array != array.sort
		 position = 0
		 array.each { |period|
		 	 if (i < period)
		 	 		return position+1
		 	 else
		 	 		position += 1
		 	 end
		 }
		 raise "random number was greater than all of values. something is wrong with the probabilities"

	end



#TODO verify residual is working and that zeroes are filled in properly.
	def calc_cash_flows(simulation)
		debug("calc'ing cash flows for actor #{self.name}")
		row_output = ""
		i = 1
		
		simulation.simulation_periods.times do |period|
			period +=1
			if @start_period > period
				#actor hasn't executed their lease yet
				@payments[period] = 0
			elsif period > (@start_period + @payment_count)
				#actor lease is complete
				@payments[period] = 0
			else
				#there's an actual payment to be calculated
				payment = @monthly_payment
				if period == @start_period
					#this is the first period of the lease, so subtract the total lease price to represent our outlay
					payment -= @lease_price
				end
				if period == @start_period + @payment_count
					#this is the last period of the lease, add in residual value if appropriate
					if !@theft
						debug("adding residual value back in")
						payment += simulation.residual_value* 0.01 * @lease_price

					end
				end
				row_output = row_output + truncate(payment).to_s + "\t"
				@payments[period] = payment

			end
				
		end
		return row_output


	end

end