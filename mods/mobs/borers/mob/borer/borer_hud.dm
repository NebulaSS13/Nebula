/decl/hud_element/borer
	abstract_type = /decl/hud_element/borer

/decl/hud_element/borer/inject_chemicals
	elem_type = /obj/screen/borer/inject_chemicals

/decl/hud_element/borer/leave_host
	elem_type = /obj/screen/borer/leave_host

/decl/hud_element/borer/toggle_control
	elem_type = /obj/screen/borer/toggle_host_control

/datum/hud/animal/borer
	omit_hud_elements = list(
		/decl/hud_element/movement,
		/decl/hud_element/stamina
	)
	additional_hud_elements = list(
		/decl/hud_element/borer/inject_chemicals,
		/decl/hud_element/borer/leave_host,
		/decl/hud_element/borer/toggle_control
	)
	var/list/borer_hud_elements

/datum/hud/animal/borer/neutered
	additional_hud_elements = list(
		/decl/hud_element/borer/inject_chemicals,
		/decl/hud_element/borer/leave_host
	)

/datum/hud/animal/borer/Destroy()
	borer_hud_elements = null
	return ..()

/datum/hud/animal/borer/create_and_register_element(decl/hud_element/ui_elem, decl/ui_style/ui_style, ui_color, ui_alpha)
	var/obj/screen/elem = ..()
	if(istype(elem) && istype(elem, /obj/screen/borer))
		LAZYADD(borer_hud_elements, elem)
	return elem

/mob/living/simple_animal/borer
	hud_used = /datum/hud/animal/borer

/mob/living/simple_animal/borer/proc/reset_ui_callback()
	if(!is_on_special_ability_cooldown())
		var/datum/hud/animal/borer/borer_hud = hud_used
		if(istype(borer_hud))
			for(var/obj/thing in borer_hud.borer_hud_elements)
				thing.color = null

/obj/screen/borer
	icon = 'mods/mobs/borers/icons/borer_ui.dmi'
	use_supplied_ui_icon = FALSE
	requires_ui_style = FALSE

/obj/screen/borer/handle_click(mob/user, params)
	if(!isborer(user))
		return FALSE
	var/mob/living/simple_animal/borer/worm = user
	if(!worm.host)
		return FALSE
	return TRUE

/obj/screen/borer/toggle_host_control
	name = "Seize Control"
	icon_state = "seize_control"
	screen_loc = "LEFT+3,TOP-1"

/obj/screen/borer/toggle_host_control/handle_click(mob/user, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = user
	if(!worm.can_use_borer_ability())
		return

	if(worm.neutered)
		to_chat(worm, SPAN_WARNING("You cannot do that."))
		return

	to_chat(worm, SPAN_NOTICE("You begin delicately adjusting your connection to the host brain..."))
	if(!do_after(worm, 100+(worm.host.get_damage(BRAIN)*5) || !worm.host || !worm.can_use_borer_ability()))
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
	worm.host.verbs += /mob/living/proc/release_control
	worm.host.verbs += /mob/living/proc/punish_host
	worm.host.verbs += /mob/living/proc/spawn_larvae

	return TRUE

/obj/screen/borer/inject_chemicals
	name = "Inject Chemicals"
	icon_state = "inject_chemicals"
	screen_loc = "LEFT+2,TOP-1"

/obj/screen/borer/inject_chemicals/handle_click(mob/user, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = user
	if(!worm.can_use_borer_ability())
		return

	if(worm.chemicals < 50)
		to_chat(worm, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/chem = input("Select a chemical to secrete.", "Chemicals") as null|anything in worm.chemical_types
	if(!chem || !worm.chemical_types[chem] || !worm || QDELETED(worm) || worm.chemicals < 50 || !worm.can_use_borer_ability())
		return

	to_chat(worm, SPAN_NOTICE("You squirt a measure of [chem] from your reservoirs into \the [worm.host]'s bloodstream."))
	worm.host.add_to_reagents(worm.chemical_types[chem], 10)
	worm.chemicals -= 50
	return TRUE

/obj/screen/borer/leave_host
	name = "Leave Host"
	icon_state = "leave_host"
	screen_loc = "LEFT+1,TOP-1"

/obj/screen/borer/leave_host/handle_click(mob/user, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/borer/worm = user
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