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