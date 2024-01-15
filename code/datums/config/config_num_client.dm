/decl/config/num/clients
	abstract_type = /decl/config/num/clients

/decl/config/num/clients/update_post_value_set()
	for(var/client/client)
		client.OnResize()
	. = ..()
