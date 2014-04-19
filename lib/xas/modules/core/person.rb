module XAS::Modules::Core
	class Person < XAS::Item
		field :name, String
		validate :name, :presence
		
		reference :address, Address
	end
end