module XAS::Modules::Core
	module Events
		class ChangeCurrencyName < XAS::Event
			reference :currency, Items::Currency
			
			requires :currency
			changes :currency, :name
			
			field :new_name, String
			
			validate :new_name, :presence
			
			def apply(cache)
				c = cache.get references[:currency], get(:date)
				c.set :name, get(:new_name)
				cache.save c
			end
		end
	end
end