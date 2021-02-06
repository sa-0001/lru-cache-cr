##======================================================================================================================

class LRUCache(T)
	class Error < Exception
	end
	
	def initialize (*, max_items : Int32 | Nil = nil, max_bytes : Int32 | Nil  = nil)
		@hash = {} of String => T
		
		@max_items = max_items
		@max_bytes = max_bytes
	end
	
	##--------------------------------------------------------------------------
	
	def has? (key)
		@hash.has_key? key
	end
	
	def get (key)
		if @hash.has_key? key
			val = @hash.delete key
			val = val.not_nil!
			@hash[key] = val
			return val
		else
			return nil
		end
	end
	def get! (key)
		if @hash.has_key? key
			val = @hash.delete key
			val = val.not_nil!
			@hash[key] = val
			return val
		else
			raise Error.new "key not found: #{key.to_s}"
		end
	end
	
	def set (key, val)
		@hash.delete key
		@hash[key] = val
		cleanup
	end
	
	##--------------------------------------------------------------------------
	
	def bytes
		@hash.reduce(0) do |acc, item|
			acc + item[0].bytesize + item[1].bytesize
		end
	end
	def keys
		@hash.keys
	end
	
	##--------------------------------------------------------------------------
	
	private def cleanup
		if max = @max_bytes
			current_bytes = bytes
			if current_bytes > max
				@hash.delete @hash.first_key
				cleanup
			end
		end
		if max = @max_items
			current_items = @hash.size
			if current_items > max
				@hash.delete @hash.first_key
				cleanup
			end
		end
	end
end
