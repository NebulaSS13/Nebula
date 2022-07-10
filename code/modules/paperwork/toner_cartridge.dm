////////////////////////////////////////////////////////////////////////////////////////
// Toner Cartridge
////////////////////////////////////////////////////////////////////////////////////////
//#TODO: Make this into a /obj/item/chems
/obj/item/toner_cartridge
	name        = "toner cartridge"
	desc        = "A large cartridge containing pigmented polymer powder for photocopiers to print with."
	icon        = 'icons/obj/items/tonercartridge.dmi'
	icon_state  = "tonercartridge"
	throw_range = 5
	throw_speed = 4
	throwforce  = 3
	force       = 3
	w_class     = ITEM_SIZE_NORMAL
	material    = /decl/material/solid/plastic
	var/tmp/toner_max_amount = 30

/obj/item/toner_cartridge/Initialize(ml, material_key)
	. = ..()
	setup_reagents()

/obj/item/toner_cartridge/proc/setup_reagents()
	if(reagents)
		return
	create_reagents(toner_max_amount)
	//Normally this would be toner powder, but probably not worth making a material for that.
	reagents.add_reagent(/decl/material/liquid/paint,         reagents.maximum_volume/2)
	reagents.add_reagent(/decl/material/liquid/pigment/black, reagents.maximum_volume/2)

/obj/item/toner_cartridge/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume)
			to_chat(user, "Its full.")
		else if(reagents.total_volume >= ((reagents.maximum_volume / 4) * 3))
			to_chat(user, "Its nearly full.")
		else if(reagents.total_volume >= ((reagents.maximum_volume / 2)))
			to_chat(user, "Its over half full.")
		else if(reagents.total_volume < (reagents.maximum_volume / 2))
			to_chat(user, "Its less than half full.")
		else if(reagents.total_volume < (reagents.maximum_volume / 4))
			to_chat(user, "Its nearly empty.")
		else
			to_chat(user, "Its empty.")

/obj/item/toner_cartridge/dump_contents()
	. = ..()
	reagents.splash(get_turf(src), reagents.total_volume)

/obj/item/toner_cartridge/physically_destroyed(skip_qdel)
	material.place_shard(get_turf(src))
	material.place_shard(get_turf(src))
	. = ..()

/obj/item/toner_cartridge/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	health = between(0, health - (TT.speed * w_class), max_health) //You don't wanna throw this around too much
	check_health()

/obj/item/toner_cartridge/proc/get_amount_toner()
	return round(min(REAGENT_VOLUME(reagents, /decl/material/liquid/pigment/black), REAGENT_VOLUME(reagents, /decl/material/liquid/paint)) * 2) //Since ink is paint + pigment in a 1:1 ratio, we get the lowest amount we can

/obj/item/toner_cartridge/proc/use_toner(var/amount)
	if(!reagents)
		return
	var/amt_each = round(amount/2)
	if(reagents.has_reagent(/decl/material/liquid/pigment/black, amt_each) && reagents.has_reagent(/decl/material/liquid/paint, amt_each))
		reagents.remove_any(amount)
		return TRUE