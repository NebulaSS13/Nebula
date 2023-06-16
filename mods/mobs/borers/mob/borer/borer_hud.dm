/datum/hud/borer
	var/list/borer_hud_elements = list()
	var/obj/screen/intent/hud_intent_selector
	var/obj/screen/borer/toggle_host_control/hud_toggle_control
	var/obj/screen/borer/inject_chemicals/hud_inject_chemicals
	var/obj/screen/borer/leave_host/hud_leave_host

/datum/hud/borer/Destroy()
	QDEL_NULL_LIST(borer_hud_elements)
	hud_toggle_control =   null
	hud_inject_chemicals = null
	hud_leave_host =       null
	QDEL_NULL(hud_intent_selector)
	. = ..()

/datum/hud/borer/FinalizeInstantiation()
	hud_intent_selector =  new
	adding = list(hud_intent_selector)
	hud_inject_chemicals = new
	hud_leave_host =       new
	borer_hud_elements = list(
		hud_inject_chemicals,
		hud_leave_host
	)
	if(istype(mymob, /mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/borer = mymob
		if(!borer.neutered)
			hud_toggle_control = new
			borer_hud_elements += hud_toggle_control
	adding += borer_hud_elements
	if(mymob)
		var/mob/living/simple_animal/borer/borer = mymob
		if(istype(borer) && borer.host)
			for(var/obj/thing in borer_hud_elements)
				thing.alpha =        255
				thing.invisibility = 0
		if(mymob.client)
			mymob.client.screen |= adding

/mob/living/simple_animal/borer
	hud_type = /datum/hud/borer

/mob/living/simple_animal/borer/proc/reset_ui_callback()
	if(!is_on_special_ability_cooldown())
		var/datum/hud/borer/borer_hud = hud_used
		if(istype(borer_hud))
			for(var/obj/thing in borer_hud.borer_hud_elements)
				thing.color = null

/obj/screen/borer
	icon = 'mods/mobs/borers/icons/borer_ui.dmi'
	alpha = 0
	invisibility = INVISIBILITY_MAXIMUM

/obj/screen/borer/Click(location, control, params)
	if(!istype(usr, /mob/living/simple_animal/borer))
		return FALSE
	if(usr.stat == DEAD)
		return FALSE
	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.host)
		return FALSE
	return TRUE

/obj/screen/borer/toggle_host_control
	name = "Seize Control"
	icon_state = "seize_control"
	screen_loc = "LEFT+3,TOP-1"

/obj/screen/borer/toggle_host_control/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.can_use_borer_ability())
		return

	if(worm.neutered)
		to_chat(worm, SPAN_WARNING("You cannot do that."))
		return

	to_chat(worm, SPAN_NOTICE("You begin delicately adjusting your connection to the host brain..."))
	if(!do_after(worm, 100+(worm.host.getBrainLoss()*5) || !worm.host || !worm.can_use_borer_ability()))
		return

	to_chat(worm, SPAN_DANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
	to_chat(worm.host, SPAN_DANGER("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))
	worm.host.add_language(/decl/language/corticalborer)

	// host -> brain
	var/h2b_id = worm.host.computer_id
	var/h2b_ip=  worm.host.lastKnownIP
	worm.host.computer_id = null
	worm.host.lastKnownIP = null
	qdel(worm.host_brain)
	worm.host_brain = new(worm)
	worm.host_brain.ckey = worm.host.ckey
	worm.host_brain.SetName(worm.host.name)
	if(!worm.host_brain.computer_id)
		worm.host_brain.computer_id = h2b_id
	if(!worm.host_brain.lastKnownIP)
		worm.host_brain.lastKnownIP = h2b_ip

	// self -> host
	var/s2h_id = worm.computer_id
	var/s2h_ip= worm.lastKnownIP
	worm.computer_id = null
	worm.lastKnownIP = null
	worm.host.ckey = worm.ckey
	if(!worm.host.computer_id)
		worm.host.computer_id = s2h_id
	if(!worm.host.lastKnownIP)
		worm.host.lastKnownIP = s2h_ip
	worm.controlling = TRUE
	worm.host.verbs += /mob/living/carbon/proc/release_control
	worm.host.verbs += /mob/living/carbon/proc/punish_host
	worm.host.verbs += /mob/living/carbon/proc/spawn_larvae

	return TRUE

/obj/screen/borer/inject_chemicals
	name = "Inject Chemicals"
	icon_state = "inject_chemicals"
	screen_loc = "LEFT+2,TOP-1"

/obj/screen/borer/inject_chemicals/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.can_use_borer_ability())
		return

	if(worm.chemicals < 50)
		to_chat(worm, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/chem = input("Select a chemical to secrete.", "Chemicals") as null|anything in worm.chemical_types
	if(!chem || !worm.chemical_types[chem] || !worm || QDELETED(worm) || worm.chemicals < 50 || !worm.can_use_borer_ability())
		return

	to_chat(worm, SPAN_NOTICE("You squirt a measure of [chem] from your reservoirs into \the [worm.host]'s bloodstream."))
	worm.host.reagents.add_reagent(worm.chemical_types[chem], 10)
	worm.chemicals -= 50
	return TRUE

/obj/screen/borer/leave_host
	name = "Leave Host"
	icon_state = "leave_host"
	screen_loc = "LEFT+1,TOP-1"

/obj/screen/borer/leave_host/Click(location, control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = usr
	if(!worm.can_use_borer_ability())
		return

	to_chat(worm, SPAN_NOTICE("You begin disconnecting from \the [worm.host]'s synapses and prodding at their internal ear canal."))
	if(worm.host.stat == CONSCIOUS)
		to_chat(worm.host, SPAN_WARNING("An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."))

	if(!do_after(worm, 10 SECONDS) || !worm.can_use_borer_ability())
		return

	if(worm.host)
		to_chat(worm, SPAN_WARNING("You wiggle out of [worm.host]'s ear and plop to the ground."))
		if(worm.host.stat != DEAD)
			to_chat(worm.host, SPAN_DANGER("Something slimy wiggles out of your ear and plops to the ground!"))
			if(!worm.neutered)
				to_chat(worm.host, SPAN_DANGER("As though waking from a dream, you shake off the insidious mind control of the brain worm. Your thoughts are your own again."))
		worm.detach_from_host()
		worm.leave_host()

	return TRUE