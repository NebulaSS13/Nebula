/mob/living/simple_animal/slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'mods/content/xenobiology/icons/slimes/slime_baby.dmi'
	speak_emote = list("chirps")
	max_health = 100
	response_harm = "stamps on"
	gene_damage = -1
	ai = /datum/mob_controller/pet_slime
	var/slime_type = /decl/slime_colour/grey

/datum/mob_controller/pet_slime
	emote_see = list("jiggles", "bounces in place")

/mob/living/simple_animal/slime/Initialize(var/ml, var/_stype = /decl/slime_colour/grey)
	. = ..()
	slime_type = _stype
	if(!ispath(slime_type, /decl/slime_colour))
		PRINT_STACK_TRACE("Pet slime had non-decl slime type: [slime_type || "NULL"]")
		return INITIALIZE_HINT_QDEL
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	SetName("pet [slime_data.name] slime")
	update_icon()

/mob/living/simple_animal/slime/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	icon = get_slime_icon()
	icon_state = (stat == DEAD ? "slime_dead" : "slime")

/mob/living/simple_animal/slime/proc/get_slime_icon()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	return slime_data.baby_icon

/mob/living/simple_animal/slime/proc/prompt_rename(var/mob/user)
	set waitfor = FALSE
	var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)
	if(QDELETED(src) || QDELETED(user))
		return
	SetName(newname || "pet slime")

/mob/living/simple_animal/slime/check_has_mouth()
	return FALSE

/mob/living/simple_animal/slime/adult
	icon = 'mods/content/xenobiology/icons/slimes/slime_adult.dmi'

/mob/living/simple_animal/slime/adult/death(gibbed)
	SHOULD_CALL_PARENT(FALSE)
	for(var/i = 1 to rand(2,3))
		var/mob/living/simple_animal/slime/baby = new(get_turf(src), slime_type)
		if(client)
			if(mind)
				mind.transfer_to(baby)
			else
				baby.key = key
	qdel(src)
	return TRUE

/mob/living/simple_animal/slime/adult/get_slime_icon()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	return slime_data.adult_icon

/mob/living/simple_animal/slime/adult/on_update_icon()
	..()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	add_overlay(image(slime_data.mood_icon, "aslime-:33"))
