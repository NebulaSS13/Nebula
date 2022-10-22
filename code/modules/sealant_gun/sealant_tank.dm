/obj/item/sealant_tank
	name = "sealant tank"
	desc = "A sealed tank used to keep hull sealant foam contained under pressure."
	icon = 'icons/obj/sealant_tank.dmi'
	icon_state = "tank"
	var/foam_charges = 0
	var/max_foam_charges = 60

/obj/item/sealant_tank/on_update_icon()
	cut_overlays()
	add_overlay("fill_[FLOOR((foam_charges/max_foam_charges) * 5)]")

/obj/item/sealant_tank/examine(mob/user, distance)
	. = ..()
	if(loc == user)
		to_chat(user, SPAN_NOTICE("\The [src] has about [foam_charges] liter\s of sealant left."))

/obj/item/sealant_tank/Initialize(ml, material_key)
	. = ..()
	create_reagents(max_foam_charges)

/obj/item/sealant_tank/mapped/Initialize()
	. = ..()
	foam_charges = max_foam_charges

/obj/item/sealant_tank/physically_destroyed(var/skip_qdel)
	if(foam_charges)
		var/turf/T = get_turf(src)
		if(T)
			T.visible_message(SPAN_WARNING("The ruptured [src.name] spews out metalic foam!"))
			var/datum/effect/effect/system/foam_spread/s = new()
			s.set_up(foam_charges, T, reagents, 1)
			s.start()
			foam_charges = 0
	. = ..()
