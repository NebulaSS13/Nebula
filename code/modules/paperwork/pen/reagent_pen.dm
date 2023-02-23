/obj/item/pen/reagent
	atom_flags  = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = "{'materials':2,'esoteric':5}"
	sharp       = 1
	pen_quality = TOOL_QUALITY_MEDIOCRE

/obj/item/pen/reagent/Initialize()
	. = ..()
	initialize_reagents()

/obj/item/pen/reagent/initialize_reagents(populate = TRUE)
	create_reagents(30)
	. = ..()

/obj/item/pen/reagent/attack(mob/living/victim, mob/living/user, var/target_zone)

	if(!istype(victim))
		return

	. = ..()

	var/allow = victim.can_inject(user, target_zone)
	if(!allow)
		return
	var/obj/item/organ/external/targeted_organ = GET_EXTERNAL_ORGAN(victim, target_zone) // done here since do_skilled sleeps
	if (allow == INJECTION_PORT)
		if(victim != user)
			to_chat(user, SPAN_WARNING("You begin hunting for an injection port on \the [victim]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
		if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, victim))
			return
	if(reagents.total_volume && victim.reagents)
		var/contained_reagents = reagents.get_reagents()
		var/trans = victim.inject_external_organ(targeted_organ, reagents, 30)
		admin_inject_log(user, victim, src, contained_reagents, trans)

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	origin_tech = "{'materials':2,'esoteric':5}"

/obj/item/pen/reagent/sleepy/make_pen_description()
	desc = "It's \a [stroke_colour_name] [medium_name] pen with a sharp point and a carefully engraved \"Waffle Co.\"."

/obj/item/pen/reagent/sleepy/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/paralytics, round(reagents.maximum_volume/2))
