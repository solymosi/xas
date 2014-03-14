module XAS::Modules::Core
	module Events
		class RegisterCurrency < XAS::Event
			reference :currency, Items::Currency
			
			creates :currency
			
			field :name, String
			field :code, String
			
			field_array :numbers, Integer
			field_group :sub do
				field :one, String
				field :two, Integer
				validate :two, :presence
				
				field_group_array :sub2 do
					field_group :arr do
						field :huhu, Integer
						
						field_group_array :asdf do
							field_group_array :xyz do
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