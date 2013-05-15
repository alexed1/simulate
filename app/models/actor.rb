class Actor

	def initialize(params, id)
 		debugger
 		@id = id
 		@start_period = params["start_period"].to_i
 		@theft = params["theft?"]
 		@lease_price = params["lease_price"].to_f
 		@name = params["name"]


	end 

end