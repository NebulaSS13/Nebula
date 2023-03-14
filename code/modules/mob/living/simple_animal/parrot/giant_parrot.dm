/datum/ai/parrot/space
	relax_chance = 60 //a gentle beast
	impatience = 10
	var/list/enemies

/datum/ai/parrot/space/Destroy()
	enemies = null
	return ..()

/datum/ai/parrot/space/perform_avian_threat_assessment(var/mob/living/target)
	return (target in enemies) || ..()

/datum/ai/parrot/space/attacked_by(mob/attacker)
	LAZYDISTINCTADD(enemies, attacker)
	. = ..()

/datum/ai/parrot/space/cease_hostilities()
	. = ..()
	enemies = null

/mob/living/simple_animal/parrot/space
	name = "space parrot"
	desc = "It could be some all-knowing being that, for reasons we could never hope to understand, is assuming the shape and general mannerisms of a parrot - or just a rather large bird."
	gender = FEMALE
	health = 750 //how sweet it is to be a god!
	maxHealth = 750
	mob_size = MOB_SIZE_LARGE
	speak = list("...")
	speak_emote = list("professes","speaks unto you","elaborates","proclaims")
	emote_hear = list("sings a song to herself", "preens herself")
	natural_weapon = /obj/item/natural_weapon/giant
	min_gas = null
	max_gas = null
	minbodytemp = 0
	universal_understand = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	can_escape = TRUE
	max_held_item_size = ITEM_SIZE_LARGE
	meat_amount = 10
	bone_amount = 20
	skin_amount = 20
	ai = /datum/ai/parrot/space
	ability_cooldown = 2 MINUTES
	var/get_subspecies_name = TRUE

/mob/living/simple_animal/parrot/space/proc/get_subspecies()
	return pick(list(
		/decl/parrot_subspecies,
		/decl/parrot_subspecies/purple,
		/decl/parrot_subspecies/blue,
		/decl/parrot_subspecies/green,
		/decl/parrot_subspecies/red,
		/decl/parrot_subspecies/brown,
		/decl/parrot_subspecies/black
	))

/mob/living/simple_animal/parrot/space/Initialize()
	. = ..()
	var/subspecies_type = get_subspecies()
	if(subspecies_type)
		var/decl/parrot_subspecies/ps = GET_DECL(subspecies_type)
		icon = ps.icon
		check_mob_icon_states()
		skin_material = ps.feathers
		if(get_subspecies_name)
			SetName(ps.name)
	set_scale(2)
	update_icon()

/mob/living/simple_animal/parrot/space/UnarmedAttack(atom/A)
	if(a_intent == I_HURT && ishuman(A) && Adjacent(A) && !is_on_special_ability_cooldown())
		var/mob/living/carbon/human/H = .
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
		return
	return ..()

//subtypes
/mob/living/simple_animal/parrot/space/lesser
	name = "Avatar of the Howling Dark"
	get_subspecies_name = FALSE
	natural_weapon = /obj/item/natural_weapon/large
	health = 300
	maxHealth = 300

/mob/living/simple_animal/parrot/space/lesser/get_subspecies()
	return /decl/parrot_subspecies/black

/datum/ai/parrot/megafauna
	relax_chance = 30
	impatience = 5

/mob/living/simple_animal/parrot/space/megafauna
	name = "giant parrot"
	desc = "A huge parrot-like bird."
	get_subspecies_name = FALSE
	health = 350
	maxHealth = 350
	speak_emote = list("squawks")
	emote_hear = list("preens itself")
	natural_weapon = /obj/item/natural_weapon/large
	ai = /datum/ai/parrot/megafauna
