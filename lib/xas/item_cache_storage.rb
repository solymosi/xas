module XAS
	class ItemCacheStorage < Storage
		include Queriable
		include Eventful
		
		def save(obj)
			raise "Only items can be saved." unless obj.is_a?(Item)
			save_item(obj)
			obj
		end
	end
end