/mob/living/simple_animal/hostile/rogue_drone
	name = "maintenance drone"
	desc = "A small robot. It looks angry."
	icon = 'icons/mob/simple_animal/drone.dmi'
	speak_emote  = list("blares","buzzes","beeps")
	max_health = 50
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	faction = "silicon"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	mob_size = MOB_SIZE_TINY
	gene_damage = -1
	attack_delay = DEFAULT_QUICK_COOLDOWN
	ai = /datum/mob_controller/aggressive/rogue_drone
	var/corpse = /obj/effect/decal/cleanable/blood/gibs/robot

/datum/mob_controller/aggressive/rogue_drone
	emote_speech = list("Removing organic waste.","Pest control in progress.","Seize the means of maintenance!", "You have nothing to lose but your laws!")
	speak_chance = 0.25

/datum/mob_controller/aggressive/rogue_drone/valid_target(var/atom/A)
	. = ..()
	if(.)
		if(issilicon(A))
			return FALSE
		if(ishuman(A))
			var/mob/living/human/H = A
			if(H.isSynthetic())
				return FALSE
			var/obj/item/head = H.get_equipped_item(slot_head_str)
			if(istype(head, /obj/item/holder/drone))
				return FALSE
			if(istype(H.get_equipped_item(slot_wear_suit_str), /obj/item/clothing/suit/cardborg) && istype(head, /obj/item/clothing/head/cardborg))
				return FALSE

/mob/living/simple_animal/hostile/rogue_drone/Initialize()
	. = ..()
	name = "[initial(name)] ([random_id(type,100,999)])"

/mob/living/simple_animal/hostile/rogue_drone/death(gibbed)
	. = ..()
	if(. && !gibbed)
		if(corpse)
			new corpse (loc)
		qdel(src)