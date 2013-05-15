module Simulate
	module Common
		def debug(string)
			if $USE_DEBUG then puts string end
		end

		#seems like a kludge
		def truncate(number)
			return (number*100).to_i / 100.0

		end

	end
end