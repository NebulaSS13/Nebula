/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/simple_animal/shade.dmi'
	max_health = 50
	universal_speak = TRUE
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help_1p = "You wave your hand through $TARGET$."
	response_help_3p = "$USER$ waves $USER_THEIR$ hand through $TARGET$."
	response_disarm =  "flails at"
	response_harm =    "punches"
	natural_weapon = /obj/item/natural_weapon/shade
	minbodytemp = 0
	maxbodytemp = 4000
	min_gas = null
	max_gas = null
	speed = -1
	stop_automated_movement = 1
	faction = "cult"
	supernatural = 1
	status_flags = CANPUSH
	gene_damage = -1
	bleed_colour = "#181933"
	butchery_data = null

/mob/living/simple_animal/shade/check_has_mouth()
	return FALSE

/obj/item/natural_weapon/shade
	name = "foul touch"
	attack_verb = list("drained")
	atom_damage_type =  BURN
	force = 10

/mob/living/simple_animal/shade/on_defilement()
	return

/mob/living/simple_animal/shade/get_death_message(gibbed)
	return "lets out a contented sigh as their form unwinds"

/mob/living/simple_animal/shade/get_self_death_message(gibbed)
	return "You have been released from your earthly binds."

/mob/living/simple_animal/shade/death(gibbed)
	. = ..()
	if(. && !gibbed)
		new /obj/item/ectoplasm(src.loc)
		qdel(src)

/mob/living/simple_animal/shade/mind_initialize()
	..()
	mind.assigned_role = "Shade"
