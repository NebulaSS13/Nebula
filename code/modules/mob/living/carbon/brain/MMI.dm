/obj/item/mmi
	name = "\improper Man-Machine Interface"
	desc = "A complex life support shell that interfaces between a brain and electronic devices."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'biotech':3}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	req_access = list(access_robotics)

	var/obj/item/organ/internal/brain/holding_brain = /obj/item/organ/internal/brain

	var/locked = FALSE
	var/emp_damage = 0
	var/last_emp_message = 0
	var/static/max_emp_damage = 30
	var/static/list/emp_reboot_strings = list(
		SPAN_NOTICE("System reboot nearly complete."),
		SPAN_NOTICE("Primary systems are now online."),
		SPAN_DANGER("Major electrical distruption detected: System rebooting.")
	)

/obj/item/mmi/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(emp_damage)
			to_chat(user, SPAN_WARNING("The neural interface socket is damaged."))
		else
			to_chat(user, SPAN_NOTICE("It is undamaged."))
	
/obj/item/mmi/Initialize()
	if(ispath(holding_brain))
		holding_brain = new holding_brain(src)
	. = ..()

/obj/item/mmi/empty
	holding_brain = null

/obj/item/mmi/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/stack/nanopaste))
		if(!emp_damage)
			to_chat(user, SPAN_WARNING("\The [src] has no damage to repair."))
			return TRUE
		var/obj/item/stack/nanopaste/paste = O
		paste.use(1)
		to_chat(user, SPAN_NOTICE("You repair some of the damage to \the [src]'s electronics with the nanopaste."))
		emp_damage = max(emp_damage - rand(5,10), 0)
		return TRUE

	if(istype(O,/obj/item/organ/internal/brain))

		if(holding_brain)
			to_chat(user, SPAN_WARNING("\The [src] already has a brain in it."))
			return TRUE

		var/obj/item/organ/internal/brain/inserting_brain = O
		if(inserting_brain.damage >= inserting_brain.max_damage)
			to_chat(user, SPAN_WARNING("That brain is well and truly dead."))
			return TRUE
	
		if(!inserting_brain.brainmob || !inserting_brain.can_use_mmi)
			to_chat(user, SPAN_WARNING("\The [inserting_brain] is completely useless."))
			return TRUE

		if(user.unEquip(O, src))
			user.visible_message(SPAN_NOTICE("\The [user] sticks \the [inserting_brain] into \the [src]."))
			SetName("[initial(name)] (\the [inserting_brain])")
			holding_brain = inserting_brain
			update_icon()
			locked = TRUE
			SSstatistics.add_field("cyborg_mmis_filled",1)
		return TRUE

	if(istype(O,/obj/item/card/id) || istype(O,/obj/item/modular_computer))
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	if(holding_brain)
		return holding_brain.attackby(O, user)

	. = ..()

/obj/item/mmi/attack_self(mob/user)

	if(locked)
		to_chat(user, SPAN_WARNING("You upend \the [src], but the case is locked shut."))
		return TRUE

	if(!holding_brain)
		to_chat(user, SPAN_WARNING("You upend \the [src], but there's nothing in it."))
		return TRUE

	to_chat(user, SPAN_NOTICE("You upend \the [src], spilling \the [holding_brain] onto \the [get_turf(src)]."))

	holding_brain.dropInto(user.loc)
	holding_brain = null
	update_icon()
	SetName(initial(name))

/obj/item/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	if(holding_brain)
		holding_brain.transfer_identity(H)
		SetName("[initial(name)] (\the [holding_brain])")
	else
		SetName(initial(name))
	update_icon()
	locked = TRUE

/obj/item/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)

/obj/item/mmi/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		if(borg.mmi == src)
			borg.mmi = null
	if(holding_brain)
		if(!QDELETED(holding_brain))
			qdel(holding_brain)
		holding_brain = null
	. = ..()

/obj/item/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	origin_tech = "{'biotech':4}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	var/obj/item/radio/radio

/obj/item/mmi/radio_enabled/empty
	holding_brain = null

/obj/item/mmi/radio_enabled/Initialize()
	. = ..()
	radio = new(src)
	radio.broadcasting = TRUE

/obj/item/mmi/radio_enabled/verb/Toggle_Broadcasting()
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = 0
	if(usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You must be alive and conscious to interact with \the [src]."))
		return
	radio.broadcasting = !radio.broadcasting
	to_chat(usr, SPAN_NOTICE("You adjust the radio on \the [src]. It is [radio.broadcasting ? "now broadcasting" : "no longer broadcasting"]."))

/obj/item/mmi/radio_enabled/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "MMI"
	set src = usr.loc
	set popup_menu = 0
	if(usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You must be alive and conscious to interact with \the [src]."))
		return
	radio.listening = !radio.listening
	to_chat(usr, SPAN_NOTICE("You adjust the radio on \the [src]. It is [radio.listening ? "now receiving broadcasts" : "no longer receiving broadcasts"]."))

/obj/item/mmi/Process()
	if(emp_damage <= 0)
		last_emp_message = 0
		emp_damage = 0
		if(holding_brain)
			to_chat(holding_brain.brainmob, SPAN_NOTICE("All systems restored."))
		STOP_PROCESSING(SSprocessing, src)
	else
		emp_damage -= 1
		if(holding_brain)
			var/msg_threshold = Clamp(ceil(emp_damage / (max_emp_damage / length(emp_reboot_strings))), 1, length(emp_reboot_strings))
			if(last_emp_message != msg_threshold)
				last_emp_message = msg_threshold
				to_chat(holding_brain.brainmob, emp_reboot_strings[msg_threshold])

/obj/item/mmi/emp_act(severity)
	switch(severity)
		if(1)
			emp_damage += rand(20,30)
		if(2)
			emp_damage += rand(10,20)
		if(3)
			emp_damage += rand(0,10)
	emp_damage = Clamp(emp_damage, 0, max_emp_damage)
	if(holding_brain)
		holding_brain.emp_act(severity)
	if(emp_damage && !(src in SSprocessing.processing))
		START_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/mmi/on_update_icon()
	if(holding_brain)
		if(!holding_brain.brainmob || holding_brain.brainmob.stat == DEAD)
			icon_state = "mmi_dead"
		else
			icon_state = "mmi_full"
	else
		icon_state = "mmi_empty"

/obj/item/mmi/digital/proc/PickName()
	return

/obj/item/mmi/digital/attackby()
	return

/obj/item/mmi/digital/attack_self()
	return