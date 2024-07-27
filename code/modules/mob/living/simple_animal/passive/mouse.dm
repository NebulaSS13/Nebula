/mob/living/simple_animal/passive/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon = 'icons/mob/simple_animal/mouse_gray.dmi'
	speak_emote  = list("squeeks","squeeks","squiks")
	pass_flags = PASS_FLAG_TABLE
	see_in_dark = 6
	max_health = 5
	response_harm = "stamps on"
	density = FALSE
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder
	mob_size = MOB_SIZE_MINISCULE
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	base_animal_type = /mob/living/simple_animal/passive/mouse
	butchery_data = /decl/butchery_data/animal/small/furred

	ai = /datum/mob_controller/passive/mouse

	var/body_color //brown, gray and white, leave blank for random
	var/splatted = FALSE

/datum/mob_controller/passive/mouse
	expected_type = /mob/living/simple_animal/passive/mouse
	emote_speech = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear   = list("squeeks","squeaks","squiks")
	emote_see    = list("runs in a circle", "shakes", "scritches at something")
	speak_chance = 0.25
	turns_per_wander = 10
	can_escape_buckles = TRUE

/mob/living/simple_animal/passive/mouse/get_remains_type()
	return /obj/item/remains/mouse

/mob/living/simple_animal/passive/mouse/get_dexterity(var/silent)
	return DEXTERITY_NONE // Mice are troll bait, give them no power.

/datum/mob_controller/passive/mouse/do_process()
	if(!(. = ..()))
		return
	if(body.stat == CONSCIOUS)
		if(body.current_posture?.prone && prob(5))
			body.set_posture(/decl/posture/standing)
		if(prob(speak_chance))
			playsound(body.loc, 'sound/effects/mousesqueek.ogg', 50)
	if(body.stat == UNCONSCIOUS && prob(5))
		INVOKE_ASYNC(body, TYPE_PROC_REF(/mob/living/simple_animal, audible_emote), "snuffles.")

/mob/living/simple_animal/passive/mouse/Initialize()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	if(name == initial(name))
		name = "[name] ([sequential_id(/mob/living/simple_animal/passive/mouse)])"
	real_name = name
	set_mouse_icon()
	. = ..()

/mob/living/simple_animal/passive/mouse/proc/set_mouse_icon()
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	switch(body_color)
		if("gray")
			butchery_data = /decl/butchery_data/animal/small/furred/gray
			icon = 'icons/mob/simple_animal/mouse_gray.dmi'
		if("white")
			butchery_data = /decl/butchery_data/animal/small/furred/white
			icon = 'icons/mob/simple_animal/mouse_white.dmi'
		if("brown")
			butchery_data = /decl/butchery_data/animal/small/furred
			icon = 'icons/mob/simple_animal/mouse_brown.dmi'
	desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/passive/mouse/proc/splat()
	take_damage(get_max_health()) // Enough damage to kill
	splatted = TRUE
	death()

/mob/living/simple_animal/passive/mouse/on_update_icon()
	. = ..()
	if(stat == DEAD && splatted)
		icon_state = "world-splat"

/mob/living/simple_animal/passive/mouse/Crossed(atom/movable/AM)
	..()
	if(!ishuman(AM) || stat)
		return
	to_chat(AM, SPAN_WARNING("[html_icon(src)] Squeek!"))
	sound_to(AM, 'sound/effects/mousesqueek.ogg')

/*
 * Mouse types
 */
/mob/living/simple_animal/passive/mouse/white
	body_color = "white"
	icon = 'icons/mob/simple_animal/mouse_white.dmi'

/mob/living/simple_animal/passive/mouse/gray
	body_color = "gray"
	icon = 'icons/mob/simple_animal/mouse_gray.dmi'

/mob/living/simple_animal/passive/mouse/brown
	body_color = "brown"
	icon = 'icons/mob/simple_animal/mouse_brown.dmi'

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/passive/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/passive/mouse/brown/Tom/Initialize()
	. = ..()
	// Change my name back, don't want to be named Tom (666)
	SetName(initial(name))
	real_name = name

// rats, they're the rats (from Polaris)
/mob/living/simple_animal/passive/mouse/rat
	name = "rat"
	desc = "A large rodent, often seen hiding in maintenance areas and making a nuisance of itself."
	body_color = "rat"
	icon = 'icons/mob/simple_animal/rat.dmi'
	butchery_data = /decl/butchery_data/animal/small/furred/gray
	max_health = 20

/mob/living/simple_animal/passive/mouse/rat/set_mouse_icon()
	return
