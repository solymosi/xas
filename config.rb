set :modules, [:core, :console, :mongo_backend]

group :backend do
	group :default do
		set :module, :mongo_backend
	end
end

group :core do
	group :registry do
		set :backend, :default
		set :storage, :registry_storage
		set :collection, "registry"
	end
	
	group :item_cache do
		set :backend, :default
		set :storage, :item_cache_storage
		set :collection, "item_cache"
	end
end