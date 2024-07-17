/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/medical_kits.dmi'
	amount = 5
	max_amount = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20

	var/heal_brute = 0
	var/heal_burn = 0
	var/animal_heal = 3
	var/apply_sounds

/obj/item/stack/medical/proc/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	. = FALSE
	if(BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a crystalline limb."))
	else if(BP_IS_PROSTHETIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a prosthetic limb."))
	else
		. = TRUE

/obj/item/stack/medical/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	// TODO: dex check
	if(!ishuman(user) && !issilicon(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if(!ishuman(target))
		target.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
		user.visible_message( \
			SPAN_NOTICE("[target] has been applied with [src] by [user]."),
			SPAN_NOTICE("You apply \the [src] to [target].")
		)
		use(1)
		return TRUE

	var/mob/living/human/H = target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())
	if(!affecting)
		to_chat(user, SPAN_WARNING("\The [target] is missing that body part!"))
		return TRUE
	if(!check_limb_state(user, affecting))
		return TRUE
	if(affecting.organ_tag == BP_HEAD)
		var/obj/item/clothing/head/helmet/space/head = H.get_equipped_item(slot_head_str)
		if(istype(head))
			to_chat(user, SPAN_WARNING("You can't apply [src] through [head]!"))
			return TRUE
		var/obj/item/clothing/suit/space/suit = H.get_equipped_item(slot_wear_suit_str)
		if(istype(suit))
			to_chat(user, SPAN_WARNING("You can't apply [src] through [suit]!"))
			return TRUE
		H.update_health() // TODO: readd the actual healing logic that goes here, or check that it's applied in afterattack or something
		return TRUE

	return ..()

/obj/item/stack/medical/bruise_pack
	name                = "roll of gauze"
	singular_name       = "length of gauze"
	plural_name         = "lengths of gauze"
	desc                = "Some sterile gauze to wrap around bloody stumps."
	icon_state          = "brutepack"
	origin_tech         = @'{"biotech":1}'
	animal_heal         = 5
	apply_sounds        = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg')
	amount              = 10
	material            = /decl/material/solid/organic/cloth
	matter_multiplier   = 0.3

/obj/item/stack/medical/bruise_pack/bandage
	name                = "bandage"
	singular_name       = "bandage"
	plural_name         = "bandages"
	icon_state          = "bandage"
	desc                = "Some clean material cut into lengths suitable for bandaging wounds."
	amount              = 1
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	// Reagents required for a single poultice.
	var/static/list/poultice_reagent_requirements = list(
		/decl/material/liquid/antitoxins/ginseng = 1,
		/decl/material/liquid/brute_meds/yarrow  = 1,
		/decl/material/liquid/burn_meds/aloe     = 1
	)

/obj/item/stack/medical/bruise_pack/bandage/five
	amount = 5

/obj/item/stack/medical/bruise_pack/bandage/ten
	amount = 10

/obj/item/stack/medical/bruise_pack/bandage/proc/get_poultice_requirement_string()
	. = list()
	for(var/reagent in poultice_reagent_requirements)
		var/decl/material/reagent_decl = GET_DECL(reagent)
		. += "[poultice_reagent_requirements[reagent]] unit\s of [reagent_decl.liquid_name]"
	. = english_list(.)

/obj/item/stack/medical/bruise_pack/bandage/examine(mob/user, distance)
	. = ..()
	var/poultice_requirement_string = get_poultice_requirement_string()
	if(poultice_requirement_string)
		to_chat(user, SPAN_NOTICE("With a mixture of [poultice_requirement_string], you could use a bandage to make a herbal poultice."))

/obj/item/stack/medical/bruise_pack/bandage/attackby(obj/item/W, mob/living/user)

	// Making a poultice.
	if(istype(W, /obj/item/chems) && W.reagents && !istype(W, /obj/item/chems/food) && ATOM_IS_OPEN_CONTAINER(W))

		var/create_poultices = get_amount()
		var/missing_reagent = FALSE
		for(var/reagent in poultice_reagent_requirements)
			var/available_amt = round(REAGENT_VOLUME(W.reagents, reagent) / poultice_reagent_requirements[reagent])
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
			var/obj/item/stack/medical/ointment/poultice/poultices = new(get_turf(src), create_poultices)
			user.put_in_hands(poultices)
			user.visible_message("\The [user] carefully pours the herbal mash into the bandage, making [poultices.get_amount()] poultice\s.")
			for(var/reagent in poultice_reagent_requirements)
				W.reagents.remove_reagent(reagent, create_poultices * poultice_reagent_requirements[reagent])
			use(create_poultices)
		return TRUE

	return ..()

/obj/item/stack/medical/bruise_pack/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	. = ..()
	if(. || !ishuman(target))
		return

	var/mob/living/human/H = target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())
	if(affecting.is_bandaged())
		to_chat(user, SPAN_WARNING("The wounds on [target]'s [affecting.name] have already been bandaged."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts treating [target]'s [affecting.name]."),
		SPAN_NOTICE("You start treating [target]'s [affecting.name].")
	)

	var/used = 0
	for (var/datum/wound/W in affecting.wounds)
		if(W.bandaged)
			continue
		if(used == amount)
			break
		if(!do_mob(user, target, W.damage/5))
			to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
			break

		if (W.current_stage <= W.max_bleeding_stage)
			user.visible_message(
				SPAN_NOTICE("\The [user] bandages \a [W.desc] on [target]'s [affecting.name]."),
			    SPAN_NOTICE("You bandage \a [W.desc] on [target]'s [affecting.name].")
			)
		else if (W.damage_type == BRUISE)
			user.visible_message(
				SPAN_NOTICE("\The [user] places a bruise patch over \a [W.desc] on [target]'s [affecting.name]."),
			    SPAN_NOTICE("You place a bruise patch over \a [W.desc] on [target]'s [affecting.name].")
			)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] places a bandaid over \a [W.desc] on [target]'s [affecting.name]."),
				SPAN_NOTICE("You place a bandaid over \a [W.desc] on [target]'s [affecting.name].")
			)
		W.bandage()
		playsound(src, pick(apply_sounds), 25)
		used++
	affecting.update_damages()
	if(used == amount)
		if(affecting.is_bandaged())
			to_chat(user, SPAN_WARNING("\The [src] is used up."))
		else
			to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
	use(used)
	H.update_bandages(1)
	return TRUE

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "An antibacterial ointment used to treat burns and prevent infections."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = @'{"biotech":1}'
	animal_heal = 4
	apply_sounds = list('sound/effects/ointment.ogg')

/obj/item/stack/medical/ointment/poultice
	name = "poultice"
	gender = NEUTER
	singular_name = "poultice"
	plural_name = "poultices"
	icon_state = "poultice"
	desc = "A bandage soaked in a medicinal herbal mixture, good for treating burns and preventing infections."
	animal_heal = 3

/obj/item/stack/medical/ointment/poultice/five
	amount = 5

/obj/item/stack/medical/ointment/poultice/ten
	amount = 10

/obj/item/stack/medical/ointment/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	. = ..()
	if(. || !ishuman(target))
		return

	var/mob/living/human/H = target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())
	if(affecting.is_salved())
		to_chat(user, SPAN_WARNING("The wounds on [target]'s [affecting.name] have already been salved."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts salving wounds on [target]'s [affecting.name]."),
		SPAN_NOTICE("You start salving the wounds on [target]'s [affecting.name].")
	)
	playsound(src, pick(apply_sounds), 25)
	if(!do_mob(user, target, 10))
		to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
		return TRUE
	user.visible_message(
		SPAN_NOTICE("[user] salved wounds on [target]'s [affecting.name]."),
	    SPAN_NOTICE("You salved wounds on [target]'s [affecting.name].")
	)
	use(1)
	affecting.salve()
	affecting.disinfect()
	return TRUE

/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 0
	origin_tech = @'{"biotech":1}'
	animal_heal = 12
	apply_sounds = list('sound/effects/rip1.ogg','sound/effects/rip2.ogg','sound/effects/tape.ogg')
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	. = ..()
	if(. || !ishuman(target))
		return

	var/mob/living/human/H = target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())
	if(affecting.is_bandaged() && affecting.is_disinfected())
		to_chat(user, SPAN_WARNING("The wounds on [target]'s [affecting.name] have already been treated."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts treating [target]'s [affecting.name]."),
		SPAN_NOTICE("You start treating [target]'s [affecting.name].")
	)
	var/used = 0
	for (var/datum/wound/W in affecting.wounds)
		if (W.bandaged && W.disinfected)
			continue
		if(used == amount)
			break
		if(!do_mob(user, target, W.damage/5))
			to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
			break
		if (W.current_stage <= W.max_bleeding_stage)
			user.visible_message(
				SPAN_NOTICE("\The [user] cleans \a [W.desc] on [target]'s [affecting.name] and seals the edges with bioglue."),
			    SPAN_NOTICE("You clean and seal \a [W.desc] on [target]'s [affecting.name].")
			)
		else if (W.damage_type == BRUISE)
			user.visible_message(
				SPAN_NOTICE("\The [user] places a medical patch over \a [W.desc] on [target]'s [affecting.name]."),
				SPAN_NOTICE("You place a medical patch over \a [W.desc] on [target]'s [affecting.name].")
			)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] smears some bioglue over \a [W.desc] on [target]'s [affecting.name]."),
			    SPAN_NOTICE("You smear some bioglue over \a [W.desc] on [target]'s [affecting.name].")
			)
		playsound(src, pick(apply_sounds), 25)
		W.bandage()
		W.disinfect()
		W.heal_damage(heal_brute)
		used++
	affecting.update_damages()
	if(used == amount)
		if(affecting.is_bandaged())
			to_chat(user, SPAN_WARNING("\The [src] is used up."))
		else
			to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
	use(used)
	H.update_bandages(1)
	return TRUE

/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 5
	origin_tech = @'{"biotech":1}'
	animal_heal = 7
	apply_sounds = list('sound/effects/ointment.ogg')


/obj/item/stack/medical/advanced/ointment/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	. = ..()
	if(. || !ishuman(target))
		return

	var/mob/living/human/H = target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())

	if(affecting.is_salved())
		to_chat(user, SPAN_WARNING("The wounds on [target]'s [affecting.name] have already been salved."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts salving wounds on [target]'s [affecting.name]."),
		SPAN_NOTICE("You start salving the wounds on [target]'s [affecting.name].")
	)
	playsound(src, pick(apply_sounds), 25)
	if(!do_mob(user, target, 10))
		to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
		return TRUE
	user.visible_message(
		SPAN_NOTICE("[user] covers wounds on [target]'s [affecting.name] with regenerative membrane."),
		SPAN_NOTICE("You cover wounds on [target]'s [affecting.name] with regenerative membrane.")
	)
	affecting.heal_damage(0,heal_burn)
	use(1)
	affecting.salve()
	affecting.disinfect()
	return TRUE

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

/obj/item/stack/medical/splint/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	if(BP_IS_PROSTHETIC(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat a prosthetic limb."))
		return FALSE
	return TRUE

/obj/item/stack/medical/splint/simple
	name = "splints"
	singular_name = "splint"
	plural_name = "splints"
	icon_state = "simple-splint"
	amount = 1
	material = /decl/material/solid/organic/wood
	matter = list(
		/decl/material/solid/organic/cloth = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/stack/medical/splint/simple/five
	amount = 5

/obj/item/stack/medical/splint/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	. = ..()
	if(. || !ishuman(target))
		return

	var/mob/living/human/H = target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())

	if(!(affecting.organ_tag in get_splitable_organs()))
		to_chat(user, SPAN_WARNING("You can't use \the [src] to apply a splint there!"))
		return TRUE

	var/limb = affecting.name
	if(affecting.splinted)
		to_chat(user, SPAN_WARNING("\The [target]'s [limb] is already splinted!"))
		return TRUE

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
			return TRUE
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
			return TRUE
		var/obj/item/stack/medical/splint/S = split(1, TRUE)
		if(S)
			if(affecting.apply_splint(S))
				target.verbs += /mob/living/human/proc/remove_splints
				S.forceMove(affecting)
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
				return TRUE
			S.dropInto(src.loc) //didn't get applied, so just drop it
		user.visible_message(
			SPAN_DANGER("\The [user] fails to apply \the [src]."),
			SPAN_DANGER("You fail to apply \the [src]."),
			SPAN_DANGER("You hear something being wrapped.")
		)
	return TRUE

/obj/item/stack/medical/splint/ghetto
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1

/obj/item/stack/medical/splint/ghetto/get_splitable_organs()
	var/static/list/splintable_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	return splintable_organs

/obj/item/stack/medical/resin
	name = "resin patches"
	singular_name = "resin patch"
	desc = "A resin-based patching kit used to repair crystalline bodyparts. The label is written in a colourful, angular, unreadable script."
	icon_state = "resin-pack"
	heal_brute = 10
	heal_burn =  10

/obj/item/stack/medical/resin/drone
	amount = 25
	max_amount = 25

/obj/item/stack/medical/resin/handmade
	name = "resin globules"
	desc = "A lump of slick, shiny resin. Used to repair damage to crystalline bodyparts."
	singular_name = "resin globule"
	icon_state = "resin-lump"
	heal_brute = 5
	heal_burn =  5

/obj/item/stack/medical/resin/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	if(!BP_IS_PROSTHETIC(limb) && !BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat an organic limb."))
		return FALSE
	return TRUE

/obj/item/stack/medical/resin/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	. = ..()
	if(!. && ishuman(target))
		var/mob/living/human/H = target
		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, user.get_target_zone())
		if((affecting.brute_dam + affecting.burn_dam) <= 0)
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is undamaged."))
			return 1
		user.visible_message(
			SPAN_NOTICE("\The [user] starts patching fractures on \the [target]'s [affecting.name]."), \
			SPAN_NOTICE("You start patching fractures on \the [target]'s [affecting.name].") )
		playsound(src, pick(apply_sounds), 25)
		if(!do_mob(user, target, 10))
			to_chat(user, SPAN_NOTICE("You must stand still to patch fractures."))
			return 1
		user.visible_message( \
			SPAN_NOTICE("\The [user] patches the fractures on \the [target]'s [affecting.name] with resin."), \
			SPAN_NOTICE("You patch fractures on \the [target]'s [affecting.name] with resin."))
		affecting.heal_damage(heal_brute, heal_burn, robo_repair = TRUE)
		use(1)
