/obj/item/stack/medical/bandage
	name                = "roll of gauze"
	singular_name       = "length of gauze"
	plural_name         = "lengths of gauze"
	desc                = "Some sterile gauze to wrap around bloody stumps."
	icon_state          = "brutepack"
	origin_tech         = @'{"biotech":1}'
	animal_heal         = 5
	amount              = 10
	material            = /decl/material/solid/organic/cloth
	matter_multiplier   = 0.3
	// Reagents required to craft a single poultice.
	var/static/list/poultice_reagent_requirements = list(
		/decl/material/liquid/antitoxins/ginseng = 1,
		/decl/material/liquid/brute_meds/yarrow  = 1,
		/decl/material/liquid/burn_meds/aloe     = 1
	)

/obj/item/stack/medical/bandage/get_apply_sounds()
	var/static/list/apply_sounds = list(
		'sound/effects/rip1.ogg',
		'sound/effects/rip2.ogg'
	)
	return apply_sounds

/obj/item/stack/medical/bandage/proc/get_poultice_requirement_string()
	. = list()
	for(var/decl/material/reagent as anything in poultice_reagent_requirements)
		. += "[poultice_reagent_requirements[reagent.type]] unit\s of [reagent.liquid_name]"
	. = english_list(.)

/obj/item/stack/medical/bandage/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/poultice_requirement_string = get_poultice_requirement_string()
	if(poultice_requirement_string)
		. += SPAN_NOTICE("With a mixture of [poultice_requirement_string], you could use a bandage to make a herbal poultice.")

/obj/item/stack/medical/bandage/attackby(obj/item/used_item, mob/living/user)

	// Making a poultice.
	if(istype(used_item, /obj/item/chems) && used_item.reagents && ATOM_IS_OPEN_CONTAINER(used_item))

		var/create_poultices = get_amount()
		var/missing_reagent = FALSE
		for(var/reagent in poultice_reagent_requirements)
			var/available_amt = round(REAGENT_VOLUME(used_item.reagents, reagent) / poultice_reagent_requirements[reagent])
			if(available_amt)
				create_poultices = min(create_poultices, available_amt)
			else
				missing_reagent = TRUE
				break

		// If we have enough reagents, create poultices, otherwise, warn the user.
		if(create_poultices <= 0 || missing_reagent)
			var/poultice_requirement_string = get_poultice_requirement_string()
			if(poultice_requirement_string)
				to_chat(user, SPAN_WARNING("You need at least [poultice_requirement_string] to make one herbal poultice."))
		else
			var/obj/item/stack/medical/ointment/crafted/poultices = new(get_turf(src), create_poultices)
			user.put_in_hands(poultices)
			user.visible_message("\The [user] carefully pours the herbal mash into the bandage, making [poultices.get_amount()] poultice\s.")
			for(var/reagent in poultice_reagent_requirements)
				used_item.reagents.remove_reagent(reagent, create_poultices * poultice_reagent_requirements[reagent])
			use(create_poultices)
		return TRUE

	return ..()

/obj/item/stack/medical/bandage/proc/can_bandage_wound(datum/wound/wound)
	return !wound.bandaged

/obj/item/stack/medical/bandage/proc/can_bandage_limb(obj/item/organ/external/affecting)
	return !affecting.is_bandaged()

/obj/item/stack/medical/bandage/proc/bandage_wound(mob/user, mob/target, obj/item/organ/external/affecting, datum/wound/wound)
	user.visible_message(
		SPAN_NOTICE("\The [user] bandages \a [wound.desc] on \the [target]'s [affecting.name]."),
		SPAN_NOTICE("You bandage \a [wound.desc] on \the [target]'s [affecting.name].")
	)
	wound.bandage()

/obj/item/stack/medical/bandage/try_treat_limb(mob/living/target, mob/living/user, obj/item/organ/external/affecting)

	if(!can_bandage_limb(affecting))
		to_chat(user, SPAN_WARNING("The wounds on [target]'s [affecting.name] have already been bandaged."))
		return FALSE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts treating [target]'s [affecting.name]."),
		SPAN_NOTICE("You start treating [target]'s [affecting.name].")
	)

	. = 0
	for (var/datum/wound/wound in affecting.wounds)

		if(!can_bandage_wound(wound))
			continue

		if(!do_mob(user, target, wound.damage/5))
			to_chat(user, SPAN_WARNING("You must stand still to treat \the [target]'s wounds."))
			break

		if(QDELETED(src) || QDELETED(target) || QDELETED(affecting) || !user.Adjacent(target) || loc != user || get_amount() <= 0)
			break

		bandage_wound(user, target, affecting, wound)
		play_apply_sound()
		.++
		if(. >= get_amount())
			break

	if(. && !QDELETED(affecting))
		affecting.update_damages()
		if(!QDELETED(target))
			if(. >= amount && !QDELETED(user))
				if(affecting.is_bandaged())
					to_chat(user, SPAN_WARNING("You use the last of \the [src] to treat \the [target]'s [affecting.name]."))
				else
					to_chat(user, SPAN_WARNING("You use the last of \the [src] to treat \the [target]'s [affecting.name], but there are wounds left to be treated."))
		target.update_bandages(TRUE)

/obj/item/stack/medical/bandage/crafted
	name                = "bandage"
	singular_name       = "bandage"
	plural_name         = "bandages"
	icon_state          = "bandage"
	desc                = "Some clean material cut into lengths suitable for bandaging wounds."
	amount              = 1
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/stack/medical/bandage/crafted/five
	amount = 5

/obj/item/stack/medical/bandage/crafted/ten
	amount = 10

/obj/item/stack/medical/bandage/advanced
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 0
	origin_tech = @'{"biotech":1}'
	animal_heal = 12
	amount = 10

/obj/item/stack/medical/bandage/advanced/can_bandage_wound(datum/wound/wound)
	return !wound.disinfected || ..()

/obj/item/stack/medical/bandage/advanced/can_bandage_limb(obj/item/organ/external/affecting)
	return !affecting.is_disinfected() || ..()

/obj/item/stack/medical/bandage/advanced/get_apply_sounds()
	var/static/list/apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg','sound/effects/tape.ogg')
	return apply_sounds

/obj/item/stack/medical/bandage/advanced/bandage_wound(mob/user, mob/target, obj/item/organ/external/affecting, datum/wound/wound)
	if (wound.current_stage <= wound.max_bleeding_stage)
		user.visible_message(
			SPAN_NOTICE("\The [user] cleans \a [wound.desc] on [target]'s [affecting.name] and seals the edges with bioglue."),
		    SPAN_NOTICE("You clean and seal \a [wound.desc] on [target]'s [affecting.name].")
		)
	else if (wound.damage_type == BRUISE)
		user.visible_message(
			SPAN_NOTICE("\The [user] places a medical patch over \a [wound.desc] on [target]'s [affecting.name]."),
			SPAN_NOTICE("You place a medical patch over \a [wound.desc] on [target]'s [affecting.name].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] smears some bioglue over \a [wound.desc] on [target]'s [affecting.name]."),
		    SPAN_NOTICE("You smear some bioglue over \a [wound.desc] on [target]'s [affecting.name].")
		)
	wound.bandage()
	wound.disinfect()
	wound.heal_damage(heal_brute)
