/// Generic material product (sheets, bricks, etc). Used ALL THE TIME.
/// May return an instance list, a single instance, or nothing if there is no instance produced.
/decl/material/proc/create_object(var/atom/target, var/amount = 1, var/object_type, var/reinf_type)

	if(!object_type)
		object_type = default_solid_form

	if(!ispath(object_type, /atom/movable))
		CRASH("Non-movable path '[object_type || "NULL"]' supplied to [type] create_object()")

	if(ispath(object_type, /obj/item/stack))
		var/obj/item/stack/stack_type = object_type
		var/divisor = initial(stack_type.max_amount)
		while(amount >= divisor)
			LAZYADD(., new object_type(target, divisor, type, reinf_type))
			amount -= divisor
		if(amount >= 1)
			LAZYADD(., new object_type(target, amount, type, reinf_type))
	else
		for(var/i = 1 to amount)
			var/atom/movable/placed = new object_type(target, type, reinf_type)
			if(istype(placed))
				LAZYADD(., placed)

	if(istype(target) && LAZYLEN(.))
		for(var/atom/movable/placed in .)
			placed.dropInto(target)

// Places a girder object when a wall is dismantled, also applies reinforced material.
/decl/material/proc/place_dismantled_girder(var/turf/target, var/decl/material/r_mat)
	return create_object(target, 1, /obj/structure/girder, ispath(r_mat) ? r_mat : r_mat?.type)

// General wall debris product placement.
// Not particularly necessary aside from snowflakey cult girders.
/decl/material/proc/place_dismantled_product(var/turf/target, var/is_devastated, var/amount = 2, var/drop_type)
	amount = is_devastated ? floor(amount * 0.5) : amount
	if(amount > 0)
		return create_object(target, amount, object_type = drop_type)

// As above.
/decl/material/proc/place_shards(var/turf/target, var/amount = 1)
	if(shard_name)
		return create_object(target, amount, /obj/item/shard)

/**Places down as many shards as needed for the given amount of matter units. Returns a list of all the cuttings. */
/decl/material/proc/place_cuttings(var/turf/target, var/matter_units)
	if(!shard_type && matter_units <= 0)
		return
	var/list/shard_mat = atom_info_repository.get_matter_for(shard_type, type, 1)
	var/amount_per_shard = LAZYACCESS(shard_mat, type)
	if(amount_per_shard < 1)
		return

	//Make all the shards we can
	var/shard_amount = round(matter_units / amount_per_shard)
	var/matter_left  = round(matter_units % amount_per_shard)
	LAZYADD(., create_object(target, shard_amount, shard_type))

	//If we got more than expected, just make a shard with that amount
	if(matter_left > 0)
		var/list/O = create_object(target, 1, shard_type)
		var/obj/S = O[O.len]
		LAZYSET(S.matter, type, matter_left)
		LAZYADD(., S)