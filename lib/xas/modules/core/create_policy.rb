module XAS::Modules::Core
	class CreatePolicy < XAS::Event
		reference :book_currency, Currency
		validate :book_currency, :presence
		
		reference :presentation_currency, Currency
		
		def apply(cache)
			p = cache.create policy, date
			p.book_currency = book_currency
			p.presentation_currency = presentation_currency.nil? ? book_currency : presentation_currency
			yield p if block_given?
			cache.save p
		end
	end
end