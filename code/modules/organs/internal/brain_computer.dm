// Robobrain.
/obj/item/organ/internal/brain/robotic
	name = "computer intelligence core"
	desc = "The pinnacle of artifical intelligence technology, conveniently stored in a fist-sized cube."
	icon = 'icons/obj/items/brain_interface_robotic.dmi'
	origin_tech = @'{"engineering":4,"materials":4,"wormholes":2,"programming":4}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	bodytype = /decl/bodytype/prosthetic/basic_human
	can_use_brain_interface = FALSE
	var/searching = FALSE
	var/brain_name

/obj/item/organ/internal/brain/robotic/handle_severe_damage()
	return // TODO: computer maladies

/obj/item/organ/internal/brain/robotic/handle_disabilities()
	return // TODO: computer maladies

/obj/item/organ/internal/brain/robotic/Initialize()
	. = ..()
	update_icon()
	brain_name = "[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[random_id(type,1000,9999)]"
	SetName("[name] ([brain_name])")

/obj/item/organ/internal/brain/robotic/initialize_brainmob()
	..()
	if(istype(_brainmob))
		_brainmob.SetName(brain_name)
		_brainmob.add_language(/decl/language/machine)

/obj/item/organ/internal/brain/robotic/on_update_icon()
	var/mob/living/brainmob = get_brainmob()
	icon_state = get_world_inventory_state()
	if(!searching)
		if(!brainmob?.key || brainmob.stat == DEAD)
			icon_state = "[icon_state]-dead"
		else
			icon_state = "[icon_state]-full"

/obj/item/organ/internal/brain/robotic/attack_self(mob/user)
	var/mob/living/brainmob = get_brainmob(create_if_missing = TRUE)
	if(!brainmob?.key && !searching)
		to_chat(user, SPAN_NOTICE("You press the power button and boot up \the [src]."))
		searching = TRUE
		update_icon()
		var/decl/ghosttrap/G = GET_DECL(/decl/ghosttrap/machine_intelligence)
		G.request_player(brainmob, "Someone is requesting a personality for \a [name].", 1 MINUTE)
		addtimer(CALLBACK(src, PROC_REF(reset_search)), 1 MINUTE)
		return TRUE
	. = ..()

/obj/item/organ/internal/brain/robotic/proc/reset_search()
	searching = FALSE
	update_icon()
	var/mob/living/brainmob = get_brainmob()
	if(!brainmob?.key)
		visible_message(SPAN_WARNING("\The [src] emits a series of loud beeps, indicating a failure to boot. Try again in a few minutes."))

/obj/item/organ/internal/brain/robotic/attack_ghost(var/mob/observer/ghost/user)
	var/mob/living/brainmob = get_brainmob(create_if_missing = TRUE)
	if(brainmob?.key)
		to_chat(user, SPAN_WARNING("\The [src] is already inhabited; there's no room for you!"))
		return TRUE

	var/decl/ghosttrap/G = GET_DECL(/decl/ghosttrap/machine_intelligence)
	if(G.assess_candidate(user))
		var/response = alert(user, "Are you sure you wish to possess \the [src]?", "Possess [capitalize(name)]", "Yes", "No")
		if(response == "Yes" && brainmob && !brainmob?.key && G.assess_candidate(user))
			G.transfer_personality(user, brainmob)

/obj/item/organ/internal/brain/robotic/show_brain_status(mob/user)
	var/mob/living/brainmob = get_brainmob()
	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!brainmob.client)
					to_chat(user, SPAN_WARNING("It appears to be in stand-by mode."))
			if(UNCONSCIOUS)
				to_chat(user, SPAN_WARNING("It doesn't seem to be responsive."))
			if(DEAD)
				to_chat(user, SPAN_WARNING("It appears to be completely inactive."))
	else
		to_chat(user, SPAN_WARNING("It appears to be completely inactive."))

/obj/item/organ/internal/brain/robotic/get_synthetic_owner_name()
	return "Robot"
