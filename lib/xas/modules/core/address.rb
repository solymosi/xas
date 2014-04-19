module XAS::Modules::Core
	class Address < XAS::Item
		field :country, String
		validate :country, :presence
		
		field :postal_code, String
		
		field :city, String
		validate :city, :presence
		
		field :street, String
		validate :street, :presence
	end
end