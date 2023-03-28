/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/simple_animal/shade.dmi'
	maxHealth = 50
	health = 50
	universal_speak = TRUE
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help_1p = "You wave your hand through $TARGET$."
	response_help_3p = "$USER$ waves $USER_HIS$ hand through $TARGET$."
	response_disarm =  "flails at"
	response_harm =    "punches"
	natural_weapon = /obj/item/natural_weapon/shade
	minbodytemp = 0
	maxbodytemp = 4000
	min_gas = null
	max_gas = null
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "cult"
	supernatural = 1
	status_flags = CANPUSH
	gene_damage = -1

	bleed_colour = "#181933"

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

/obj/item/natural_weapon/shade
	name = "foul touch"
	attack_verb = list("drained")
	damtype = BURN
	force = 10

/mob/living/simple_animal/shade/on_defilement()
	return

/mob/living/simple_animal/shade/Life()
	. = ..()
	OnDeathInLife()

/mob/living/simple_animal/shade/proc/OnDeathInLife()
	if(stat == 2)
		new /obj/item/ectoplasm (src.loc)
		for(var/mob/M in viewers(src, null))
			if((M.client && !( M.blinded )))
				M.show_message("<span class='warning'>[src] lets out a contented sigh as their form unwinds.</span>")
				ghostize()
		qdel(src)
		return
