////////////////////////////////////////////////////////////////////////////////////////
// Toner Cartridge
////////////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/toner_cartridge
	name                          = "toner cartridge"
	desc                          = "A large cartridge containing pigmented polymer powder for photocopiers to print with."
	icon                          = 'icons/obj/items/tonercartridge.dmi'
	icon_state                    = ICON_STATE_WORLD
	throw_range                   = 5
	throw_speed                   = 4
	w_class                       = ITEM_SIZE_NORMAL
	material                      = /decl/material/solid/organic/plastic
	volume                        = 60
	amount_per_transfer_from_this = 30
	possible_transfer_amounts     = @"[30,60]"
	atom_flags                    = ATOM_FLAG_OPEN_CONTAINER
	_base_attack_force            = 3

/obj/item/chems/toner_cartridge/populate_reagents()
	//Normally this would be toner powder, but probably not worth making a material for that.
	add_to_reagents(/decl/material/liquid/paint,         reagents.maximum_volume/2)
	add_to_reagents(/decl/material/liquid/pigment/black, reagents.maximum_volume/2)

/obj/item/chems/toner_cartridge/dump_contents(atom/forced_loc = loc, mob/user)
	. = ..()
	reagents?.splash(get_turf(forced_loc), reagents.total_volume)

/obj/item/chems/toner_cartridge/physically_destroyed(skip_qdel)
	material.place_shards(get_turf(src), 2)
	. = ..()

/obj/item/chems/toner_cartridge/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	current_health = clamp(current_health - (TT.speed * w_class), 0, get_max_health()) //You don't wanna throw this around too much
	check_health()

/obj/item/chems/toner_cartridge/proc/get_amount_toner()
	//Since ink is paint + pigment in a 1:1 ratio, we get the lowest amount we can
	return round(min(REAGENT_VOLUME(reagents, /decl/material/liquid/pigment/black), REAGENT_VOLUME(reagents, /decl/material/liquid/paint)), 0.01)

/obj/item/chems/toner_cartridge/proc/get_amount_toner_max()
	//Since ink is paint + pigment in a 1:1 ratio, only half the volume is actually usable
	return round(reagents.maximum_volume / 2, 0.01)

/obj/item/chems/toner_cartridge/proc/use_toner(var/amount)
	if(!reagents)
		return
	var/amt_each = round(amount/2)
	if(reagents.has_reagent(/decl/material/liquid/pigment/black, amt_each) && reagents.has_reagent(/decl/material/liquid/paint, amt_each))
		remove_any_reagents(amount)
		return TRUE