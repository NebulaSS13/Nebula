/obj/machinery/fuel_compressor/add_material(obj/thing, mob/user)
	. = ..()
	if(.)
		return TRUE
	if(istype(thing, /obj/structure/supermatter/shard))
		var/exotic_matter_amount = thing?.matter?[/decl/material/solid/exotic_matter]
		if(exotic_matter_amount <= 0)
			return FALSE
		stored_material[/decl/material/solid/exotic_matter] = exotic_matter_amount
		to_chat(user, SPAN_NOTICE("You awkwardly cram \the [thing] into \the [src]'s material buffer."))
		qdel(thing)
		return TRUE
	return FALSE