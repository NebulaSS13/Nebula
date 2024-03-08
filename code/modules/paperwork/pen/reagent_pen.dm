/obj/item/pen/reagent
	atom_flags  = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = @'{"materials":2,"esoteric":5}'
	sharp       = 1
	pen_quality = TOOL_QUALITY_MEDIOCRE

/obj/item/pen/reagent/Initialize()
	. = ..()
	initialize_reagents()

/obj/item/pen/reagent/initialize_reagents(populate = TRUE)
	create_reagents(30)
	. = ..()

/obj/item/pen/reagent/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	var/allow = target.can_inject(user, user.get_target_zone())
	if(allow && user.a_intent == I_HELP)
		if (allow == INJECTION_PORT)
			if(target != user)
				to_chat(user, SPAN_WARNING("You begin hunting for an injection port on \the [target]'s suit!"))
			else
				to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, target))
				return TRUE
		if(reagents.total_volume)
			if(target.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(target, 30, CHEM_INJECT)
				admin_inject_log(user, target, src, contained_reagents, trans)
		return TRUE

	. = ..()

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	origin_tech = @'{"materials":2,"esoteric":5}'

/obj/item/pen/reagent/sleepy/make_pen_description()
	desc = "It's \a [stroke_color_name] [medium_name] pen with a sharp point and a carefully engraved \"Waffle Co.\"."

/obj/item/pen/reagent/sleepy/populate_reagents()
	add_to_reagents(/decl/material/liquid/paralytics, round(reagents.maximum_volume/2))
