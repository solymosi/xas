module XAS::Modules::Core
	module Events
		class RegisterCurrency < Event
			references :currency, Items::Currency
			depends_on 
		end
	end
end