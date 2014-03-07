module XAS::Modules::Core
	module Events
		class ChangeCurrencyName < Event
			reference :currency, Items::Currency
			
			requires :currency
			changes :currency, :name
			
			field :new_name, String
			
			validate :new_name, :presence
		end
	end
end