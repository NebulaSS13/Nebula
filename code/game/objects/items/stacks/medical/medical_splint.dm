/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	plural_name = "medical splints"
	desc = "Modular splints capable of supporting and immobilizing bones in both limbs and appendages."
	icon_state = "splint"
	amount = 5
	max_amount = 5
	animal_heal = 0

/obj/item/stack/medical/splint/proc/get_splitable_organs()
	var/static/list/splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT)	//List of organs you can splint, natch.
	return splintable_organs

/obj/item/stack/medical/splint/limb_is_injured(obj/item/organ/external/affecting)
	return (affecting.status & ORGAN_BROKEN)

/obj/item/stack/medical/splint/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	if(BP_IS_PROSTHETIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a prosthetic limb."))
		return FALSE
	return TRUE

/obj/item/stack/medical/splint/try_treat_limb(mob/living/target, mob/living/user, obj/item/organ/external/affecting)

	if(!(affecting.organ_tag in get_splitable_organs()))
		to_chat(user, SPAN_WARNING("You can't use \the [src] to apply a splint there!"))
		return 0

	var/limb = affecting.name
	if(affecting.splinted)
		to_chat(user, SPAN_WARNING("\The [target]'s [limb] is already splinted!"))
		return 0

	if (target != user)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts to apply \the [src] to [target]'s [limb]."),
			SPAN_DANGER("You start to apply \the [src] to [target]'s [limb]."),
			SPAN_DANGER("You hear something being wrapped.")
		)
	else
		var/obj/item/organ/external/using = GET_EXTERNAL_ORGAN(user, user.get_active_held_item_slot())
		if(istype(using) && (affecting == using || (affecting in using.children) || affecting.organ_tag == using.parent_organ))
			to_chat(user, SPAN_WARNING("You can't apply a splint to the arm you're using!"))
			return 0
		user.visible_message(
			SPAN_NOTICE("\The [user] starts to apply \the [src] to their [limb]."),
			SPAN_DANGER("You start to apply \the [src] to your [limb]."),
			SPAN_DANGER("You hear something being wrapped.")
		)

	if(user.do_skilled(5 SECONDS, SKILL_MEDICAL, target))
		if((target == user && prob(75)) || prob(user.skill_fail_chance(SKILL_MEDICAL,50, SKILL_ADEPT)))
			user.visible_message(
				SPAN_DANGER("\The [user] fumbles \the [src]."),
				SPAN_DANGER("You fumble \the [src]."),
				SPAN_DANGER("You hear something being wrapped.")
			)
			return 0
		var/obj/item/stack/medical/splint/splint = split(1, TRUE)
		if(splint)
			if(affecting.apply_splint(splint))
				target.verbs += /mob/living/human/proc/remove_splints
				splint.forceMove(affecting)
				if (target != user)
					user.visible_message(
						SPAN_NOTICE("\The [user] finishes applying \the [src] to \the [target]'s [limb]."),
						SPAN_DANGER("You finish applying \the [src] to \the [target]'s [limb]."),
						SPAN_DANGER("You hear something being wrapped.")
					)
				else
					user.visible_message(
						SPAN_NOTICE("\The [user] successfully applies \the [src] to their [limb]."),
						SPAN_DANGER("You successfully apply \the [src] to your [limb]."),
						SPAN_DANGER("You hear something being wrapped.")
					)
				return 0
			splint.dropInto(src.loc) //didn't get applied, so just drop it
		user.visible_message(
			SPAN_DANGER("\The [user] fails to apply \the [src]."),
			SPAN_DANGER("You fail to apply \the [src]."),
			SPAN_DANGER("You hear something being wrapped.")
		)
	// We handle using the stack via split() above, so don't ever return a numeric value.
	return 0

/obj/item/stack/medical/splint/crafted
	name = "splints"
	singular_name = "splint"
	plural_name = "splints"
	icon_state = "simple-splint"
	amount = 1
	material = /decl/material/solid/organic/wood
	matter = list(
		/decl/material/solid/organic/cloth = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/stack/medical/splint/crafted/five
	amount = 5

/obj/item/stack/medical/splint/improvised
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1

/obj/item/stack/medical/splint/improvised/get_splitable_organs()
	var/static/list/splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	return splintable_organs
