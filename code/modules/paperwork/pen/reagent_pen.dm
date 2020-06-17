/obj/item/pen/reagent
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = "{'materials':2,'esoteric':5}"

/obj/item/pen/reagent/Initialize()
	. = ..()
	create_reagents(30)

/obj/item/pen/reagent/attack(mob/living/M, mob/user, var/target_zone)

	if(!istype(M))
		return

	. = ..()

	var/allow = M.can_inject(user, target_zone)
	if(allow)
		if (allow == INJECTION_PORT)
			if(M != user)
				to_chat(user, SPAN_WARNING("You begin hunting for an injection port on \the [M]'s suit!"))
			else
				to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M))
				return
		if(reagents.total_volume)
			if(M.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(M, 30, CHEM_INJECT)
				admin_inject_log(user, M, src, contained_reagents, trans)

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\"."
	origin_tech = "{'materials':2,'esoteric':5}"

/obj/item/pen/reagent/sleepy/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/paralytics, 15)
