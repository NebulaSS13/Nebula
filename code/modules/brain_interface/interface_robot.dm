/obj/item/brain_interface/robot
	name = "computer intelligence core"
	desc = "The pinnacle of artifical intelligence technology, conveniently stored in a fist-sized cube."
	icon = 'icons/obj/items/brain_interface_robotic.dmi'
	origin_tech = "{'engineering':4,'materials':4,'wormholes':2,'programming':4}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	var/searching = FALSE

/obj/item/brain_interface/robot/empty
	holding_brain = null

/obj/item/brain_interface/robot/update_from_brain()
	..()
	if(holding_brain?.brainmob)
		holding_brain.brainmob.SetName("[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[random_id(type,1000,9999)]")

/obj/item/brain_interface/robot/on_update_icon()
	if(searching)
		icon_state = get_world_inventory_state()
	else
		. = ..()

/obj/item/brain_interface/robot/attack_self(mob/user)
	if(holding_brain?.brainmob && !holding_brain.brainmob.key && !searching)
		to_chat(user, SPAN_NOTICE("You press the power button and boot up \the [src]."))
		searching = TRUE
		update_icon()
		var/decl/ghosttrap/G = decls_repository.get_decl(/decl/ghosttrap/machine_intelligence)
		G.request_player(holding_brain.brainmob, "Someone is requesting a personality for a [name].", 1 MINUTE)
		addtimer(CALLBACK(src, .proc/reset_search), 1 MINUTE)
		return TRUE
	. = ..()

/obj/item/brain_interface/robot/proc/reset_search()
	searching = FALSE
	update_icon()
	if(!holding_brain?.brainmob?.key)
		visible_message(SPAN_WARNING("\The [src] emits a series of loud beeps, indicating a failure to boot. Try again in a few minutes."))

/obj/item/brain_interface/robot/attack_ghost(var/mob/observer/ghost/user)
	if(holding_brain?.brainmob?.key)
		to_chat(user, SPAN_WARNING("\The [src] is already inhabited; there's no room for you!"))
		return TRUE

	var/decl/ghosttrap/G = decls_repository.get_decl(/decl/ghosttrap/machine_intelligence)
	if(G.assess_candidate(user))
		var/response = alert(user, "Are you sure you wish to possess \the [src]?", "Possess [capitalize(name)]", "Yes", "No")
		if(response == "Yes" && holding_brain?.brainmob && !holding_brain.brainmob?.key && G.assess_candidate(user))
			G.transfer_player(user, holding_brain.brainmob)

/obj/item/brain_interface/robot/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(holding_brain?.brainmob?.key)
			switch(holding_brain.brainmob.stat)
				if(CONSCIOUS)
					if(!holding_brain.brainmob.client)
						to_chat(user, SPAN_WARNING("It appears to be in stand-by mode."))
				if(UNCONSCIOUS)
					to_chat(user, SPAN_WARNING("It doesn't seem to be responsive."))
				if(DEAD)
					to_chat(user, SPAN_WARNING("It appears to be completely inactive."))
		else
			to_chat(user, SPAN_WARNING("It appears to be completely inactive."))
