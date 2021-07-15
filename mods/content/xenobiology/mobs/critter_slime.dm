/mob/living/simple_animal/slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'mods/content/xenobiology/icons/slimes/slime_baby.dmi'
	icon_state = "slime"
	icon_living = "slime"
	icon_dead = "slime_dead"
	speak_emote = list("chirps")
	health = 100
	maxHealth = 100
	response_harm = "stamps on"
	emote_see = list("jiggles", "bounces in place")
	gene_damage = -1
	var/slime_type = /decl/slime_colour/grey

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
	..()
	icon = get_slime_icon()
	
/mob/living/simple_animal/slime/proc/get_slime_icon()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	return slime_data.baby_icon

/mob/living/simple_animal/slime/proc/prompt_rename(var/mob/user)
	set waitfor = FALSE
	var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)
	if(QDELETED(src) || QDELETED(user))
		return
	SetName(newname || "pet slime")

/mob/living/simple_animal/slime/can_force_feed(var/feeder, var/food, var/feedback)
	if(feedback)
		to_chat(feeder, SPAN_WARNING("Where do you intend to put \the [food]? \The [src] doesn't have a mouth!"))
	return FALSE

/mob/living/simple_animal/slime/adult
	icon = 'mods/content/xenobiology/icons/slimes/slime_adult.dmi'

/mob/living/simple_animal/slime/adult/death()
	for(var/i = 1 to rand(2,3))
		var/mob/living/simple_animal/slime/baby = new(get_turf(src), slime_type)
		if(client)
			if(mind)
				mind.transfer_to(baby)
			else
				baby.key = key
	qdel(src)

/mob/living/simple_animal/slime/adult/get_slime_icon()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	return slime_data.adult_icon

/mob/living/simple_animal/slime/adult/on_update_icon()
	..()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	add_overlay(image(slime_data.mood_icon, "aslime-:33"))
