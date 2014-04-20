module XAS::Modules::Core
	class Policy < XAS::Item
		reference :book_currency, Currency
		validate :book_currency, :presence
		
		reference :presentation_currency, Currency
		validate :presentation_currency, :presence
	end
end