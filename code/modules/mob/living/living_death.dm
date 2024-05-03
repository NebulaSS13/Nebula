/mob/living/handle_existence_failure(dusted)
	. = ..()
	// Gibbed mobs drop some of their butchery products.
	if(. && !dusted && butchery_data && loc)
		var/decl/butchery_data/butchery_decl = GET_DECL(butchery_data)
		for(var/atom/movable/product in butchery_decl.get_all_products(src))
			if(prob(20))
				qdel(product)
			else
				product.dropInto(loc)
