module XAS::Modules::Core
	module Events
		class RegisterCurrency < XAS::Event
			reference :currency, Items::Currency
			
			creates :currency
			
			field :name, String
			field :code, String
			
			field_array :numbers, Integer
			field_collection :sub do
				field :one, String
				field :two, Integer
				
				field_collection_array :sub2 do
					field_collection :arr do
						field :huhu, Integer
						
						field_collection_array :asdf do
							field_collection_array :xyz do
								field :eee, Time
							end
						end
					end
					
					field :test, String
				end
			end
			
			def apply(cache)
				c = cache.create references[:currency], date
				c.name = name
				c.code = code
				cache.save c
			end
		end
	end
end