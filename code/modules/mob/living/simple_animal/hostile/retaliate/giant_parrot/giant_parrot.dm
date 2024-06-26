/mob/living/simple_animal/hostile/parrot/space
	name = "space parrot"
	desc = "It could be some all-knowing being that, for reasons we could never hope to understand, is assuming the shape and general mannerisms of a parrot - or just a rather large bird."
	gender = FEMALE
	max_health = 750
	mob_size = MOB_SIZE_LARGE
	speak_emote  = list("professes","speaks unto you","elaborates","proclaims")
	natural_weapon = /obj/item/natural_weapon/giant
	min_gas = null
	max_gas = null
	minbodytemp = 0
	universal_understand = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	relax_chance = 60 //a gentle beast
	impatience = 10
	parrot_isize = ITEM_SIZE_LARGE
	simple_parrot = TRUE
	ability_cooldown = 2 MINUTES
	butchery_data = /decl/butchery_data/animal/bird/parrot/space
	ai = /datum/mob_controller/aggressive/parrot/space
	var/get_subspecies_name = TRUE

/datum/mob_controller/aggressive/parrot/space
	emote_speech = null
	emote_hear   = list("sings a song to herself", "preens herself")
	can_escape_buckles = TRUE

/mob/living/simple_animal/hostile/parrot/space/proc/get_parrot_species()
	var/list/parrot_species = decls_repository.get_decls_of_type(/decl/parrot_subspecies)
	return LAZYLEN(parrot_species) ? parrot_species[pick(parrot_species)] : null

/mob/living/simple_animal/hostile/parrot/space/Initialize()
	. = ..()
	var/decl/parrot_subspecies/ps = get_parrot_species()
	if(ps)
		icon_set = ps.icon_set
		butchery_data = ps.butchery_data
		if(get_subspecies_name)
			SetName(ps.name)
	set_scale(2)
	update_icon()

/mob/living/simple_animal/hostile/parrot/space/apply_attack_effects(mob/living/target)
	. = ..()
	if(ishuman(target) && can_act() && !is_on_special_ability_cooldown() && Adjacent(.))
		var/mob/living/human/H = target
		if(prob(70))
			SET_STATUS_MAX(H, STAT_WEAK, rand(2,3))
			set_special_ability_cooldown(ability_cooldown / 1.5)
			visible_message(SPAN_MFAUNA("\The [src] flaps its wings mightily and bowls over \the [H] with a gust!"))

		else if(H.get_equipped_item(slot_head_str))
			var/obj/item/clothing/head/HAT = H.get_equipped_item(slot_head_str)
			if(H.canUnEquip(HAT))
				visible_message(SPAN_MFAUNA("\The [src] rips \the [H]'s [HAT] off!"))
				set_special_ability_cooldown(ability_cooldown)
				H.try_unequip(HAT, get_turf(src))

//subtypes
/mob/living/simple_animal/hostile/parrot/space/lesser
	name = "Avatar of the Howling Dark"
	get_subspecies_name = FALSE
	natural_weapon = /obj/item/natural_weapon/large
	max_health = 300

/mob/living/simple_animal/hostile/parrot/space/lesser/get_parrot_species()
	return GET_DECL(/decl/parrot_subspecies/black)

/mob/living/simple_animal/hostile/parrot/space/megafauna
	name = "giant parrot"
	desc = "A huge parrot-like bird."
	get_subspecies_name = FALSE
	max_health = 350
	speak_emote = list("squawks")
	ai = /datum/mob_controller/aggressive/parrot/space/megafauna
	natural_weapon = /obj/item/natural_weapon/large
	relax_chance = 30
	impatience = 5

/datum/mob_controller/aggressive/parrot/space/megafauna
	emote_hear = list("preens itself")
