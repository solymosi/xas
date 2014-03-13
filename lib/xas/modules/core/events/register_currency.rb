module XAS::Modules::Core
	module Events
		class RegisterCurrency < XAS::Event
			reference :currency, Items::Currency
			
			creates :currency
			
			field :name, String
			field :code, String
			
			def apply(cache)
				c = cache.create references[:currency], get(:date)
				c.set :name, get(:name)
				c.set :code, get(:code)
				cache.save c
			end
		end
	end
end