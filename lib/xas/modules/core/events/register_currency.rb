module XAS::Modules::Core
	module Events
		class RegisterCurrency < Event
			reference :currency, Items::Currency
			
			creates :currency
			
			field :name, String
			field :code, String
		end
	end
end