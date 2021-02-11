/obj/item/brain_interface
	name = "neural interface"
	desc = "A complex life support shell that interfaces between a brain and electronic devices."
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

	var/icon_state_dead = "dead"
	var/icon_state_full = "full"

	var/obj/item/organ/internal/brain/holding_brain = /obj/item/organ/internal/brain
	var/emp_damage = 0
	var/last_emp_message = 0
	var/static/max_emp_damage = 30
	var/static/list/emp_reboot_strings = list(
		SPAN_NOTICE("System reboot nearly complete."),
		SPAN_NOTICE("Primary systems are now online."),
		SPAN_DANGER("Major electrical distruption detected: System rebooting.")
	)


/obj/item/brain_interface/organic/on_update_icon()
	icon_state = get_world_inventory_state()
	if(holding_brain)
		if(!holding_brain.brainmob || holding_brain.brainmob.stat == DEAD)
			icon_state = "[icon_state]-[icon_state_dead]"
		else
			icon_state = "[icon_state]-[icon_state_full]"

/obj/item/brain_interface/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(emp_damage)
			to_chat(user, SPAN_WARNING("The neural interface socket is damaged."))
		else
			to_chat(user, SPAN_NOTICE("It is undamaged."))
	
/obj/item/brain_interface/Initialize()
	if(type == /obj/item/brain_interface)
		crash_with("Abstract brain interface type ([type]) tried to Initialize(), use a subtype!")
		return INITIALIZE_HINT_QDEL
	if(ispath(holding_brain))
		holding_brain = new holding_brain(src)
	if(locate(/obj/item/radio) in src)
		verbs |= /obj/item/brain_interface/proc/toggle_radio_listening
		verbs |= /obj/item/brain_interface/proc/toggle_radio_broadcasting
	. = ..()
	update_icon()

/obj/item/brain_interface/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/stack/nanopaste))
		if(!emp_damage)
			to_chat(user, SPAN_WARNING("\The [src] has no damage to repair."))
			return TRUE
		var/obj/item/stack/nanopaste/pasta = O
		pasta.use(1)
		to_chat(user, SPAN_NOTICE("You repair some of the damage to \the [src]'s electronics with the nanopaste."))
		emp_damage = max(emp_damage - rand(5,10), 0)
		return TRUE

	if(holding_brain)
		return holding_brain.attackby(O, user)

	. = ..()

/obj/item/brain_interface/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	if(holding_brain)
		holding_brain.transfer_identity(H)
		SetName("[initial(name)] (\the [holding_brain])")
	else
		SetName(initial(name))
	update_icon()

/obj/item/brain_interface/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)

/obj/item/brain_interface/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		if(borg.brain == src)
			borg.brain = null
	if(holding_brain)
		if(!QDELETED(holding_brain))
			qdel(holding_brain)
		holding_brain = null
	. = ..()

/obj/item/brain_interface/Process()
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

/obj/item/brain_interface/emp_act(severity)
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
