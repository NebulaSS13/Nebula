/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon = 'icons/mob/simple_animal/mouse_gray.dmi'
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	pass_flags = PASS_FLAG_TABLE
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	mob_default_max_health = 5
	response_harm = "stamps on"
	density = FALSE
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/mouse
	mob_size = MOB_SIZE_MINISCULE
	possession_candidate = 1
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	base_animal_type = /mob/living/simple_animal/mouse

	meat_amount =   1
	bone_amount =   1
	skin_amount =   1
	skin_material = /decl/material/solid/organic/skin/fur

	ai = /datum/ai/mouse

	var/body_color //brown, gray and white, leave blank for random
	var/splatted = FALSE

/mob/living/simple_animal/mouse/get_dexterity(var/silent)
	return DEXTERITY_NONE // Mice are troll bait, give them no power.

/datum/ai/mouse
	expected_type = /mob/living/simple_animal/mouse

/datum/ai/mouse/do_process()
	..()
	var/mob/living/simple_animal/mouse/mouse = body
	if(prob(mouse.speak_chance))
		playsound(mouse.loc, 'sound/effects/mousesqueek.ogg', 50)
	if(mouse.stat == CONSCIOUS && prob(0.5))
		mouse.set_stat(UNCONSCIOUS)
		mouse.wander = 0
		mouse.speak_chance = 0
	else if(mouse.stat == UNCONSCIOUS)
		if(prob(1))
			mouse.set_stat(CONSCIOUS)
			mouse.wander = 1
		else if(prob(5))
			INVOKE_ASYNC(mouse, TYPE_PROC_REF(/mob/living/simple_animal, audible_emote), "snuffles.")

/mob/living/simple_animal/mouse/Initialize()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	if(name == initial(name))
		name = "[name] ([sequential_id(/mob/living/simple_animal/mouse)])"
	real_name = name
	set_mouse_icon()
	. = ..()

/mob/living/simple_animal/mouse/proc/set_mouse_icon()
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	switch(body_color)
		if("gray")
			skin_material = /decl/material/solid/organic/skin/fur/gray
			icon = 'icons/mob/simple_animal/mouse_gray.dmi'
		if("white")
			skin_material = /decl/material/solid/organic/skin/fur/white
			icon = 'icons/mob/simple_animal/mouse_white.dmi'
		if("brown")
			icon = 'icons/mob/simple_animal/mouse_brown.dmi'
	desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/mouse/proc/splat()
	adjustBruteLoss(get_max_health())  // Enough damage to kill
	splatted = TRUE
	death()

/mob/living/simple_animal/mouse/on_update_icon()
	. = ..()
	if(stat == DEAD && splatted)
		icon_state = "world-splat"

/mob/living/simple_animal/mouse/Crossed(atom/movable/AM)
	..()
	if(!ishuman(AM) || stat)
		return
	to_chat(AM, SPAN_WARNING("[html_icon(src)] Squeek!"))
	sound_to(AM, 'sound/effects/mousesqueek.ogg')

/*
 * Mouse types
 */
/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon = 'icons/mob/simple_animal/mouse_white.dmi'

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon = 'icons/mob/simple_animal/mouse_gray.dmi'

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon = 'icons/mob/simple_animal/mouse_brown.dmi'

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/mouse/brown/Tom/Initialize()
	. = ..()
	// Change my name back, don't want to be named Tom (666)
	SetName(initial(name))
	real_name = name

// rats, they're the rats (from Polaris)
/mob/living/simple_animal/mouse/rat
	name = "rat"
	desc = "A large rodent, often seen hiding in maintenance areas and making a nuisance of itself."
	body_color = "rat"
	icon = 'icons/mob/simple_animal/rat.dmi'
	skin_material = /decl/material/solid/organic/skin/fur/gray
	mob_default_max_health = 20

/mob/living/simple_animal/mouse/rat/set_mouse_icon()
	return
