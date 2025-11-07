/obj/item/sealant_tank
	name        = "sealant tank"
	desc        = "A sealed tank used to keep hull sealant foam contained under pressure."
	icon        = 'icons/obj/sealant_tank.dmi'
	icon_state  = "tank"
	material    = /decl/material/solid/metal/steel
	chem_volume = 60

/obj/item/sealant_tank/on_update_icon()
	. = ..()
	add_overlay("fill_[floor((reagents.total_volume/reagents.maximum_volume) * 5)]")

/obj/item/sealant_tank/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(loc == user)
		. += SPAN_NOTICE("\The [src] has about [REAGENT_VOLUME(reagents, /decl/material/liquid/foam) || 0] charge\s of sealant left.")

/obj/item/sealant_tank/mapped/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/foam, reagents.maximum_volume)

/obj/item/sealant_tank/physically_destroyed(var/skip_qdel)
	var/turf/my_turf = get_turf(src)
	var/foam_amt = REAGENT_VOLUME(reagents, /decl/material/liquid/foam)
	if(istype(my_turf) && foam_amt)
		my_turf.visible_message(SPAN_WARNING("The ruptured [name] spews out foam!"))
		var/datum/effect/effect/system/foam_spread/foam_spread = new()
		foam_spread.set_up(foam_amt, my_turf, reagents, 1)
		foam_spread.start()
		reagents.clear_reagents()
	. = ..()
