/obj/item/organ/internal/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	organ_tag = BP_POSIBRAIN
	parent_organ = BP_CHEST
	force = 1.0
	w_class = ITEM_SIZE_NORMAL
	throwforce = 1
	throw_speed = 3
	throw_range = 5
	origin_tech = "{'engineering':4,'materials':4,'wormholes':2,'programming':4}"
	attack_verb = list("attacked", "slapped", "whacked")
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	relative_size = 60
	req_access = list(access_robotics)
	organ_properties = ORGAN_PROP_PROSTHETIC //triggers robotization on init
	scale_max_damage_to_species_health = FALSE

	var/mob/living/carbon/brain/brainmob = null
	var/searching = 0
	var/askDelay = 60 SECONDS

/obj/item/organ/internal/posibrain/Initialize()
	. = ..()
	if(!brainmob && iscarbon(loc))
		init(loc) //Not sure why we're creating a braimob on load, and also why not installing it in the owner...

/obj/item/organ/internal/posibrain/proc/init(var/mob/living/carbon/H)
	if(brainmob)
		return
	brainmob = new(src)
	if(istype(H))
		brainmob.SetName(H.real_name)
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.add_language(/decl/language/human/common)
		brainmob.add_language(/decl/language/binary)

/obj/item/organ/internal/posibrain/Destroy()
	QDEL_NULL(brainmob)
	return ..()

/obj/item/organ/internal/posibrain/setup_as_prosthetic()
	. = ..()
	update_icon()

/obj/item/organ/internal/posibrain/attack_self(mob/user)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		to_chat(user, "<span class='notice'>You carefully locate the manual activation switch and start the positronic brain's boot process.</span>")
		icon_state = "posibrain-searching"
		src.searching = 1
		var/decl/ghosttrap/G = GET_DECL(/decl/ghosttrap/positronic_brain)
		G.request_player(brainmob, "Someone is requesting a personality for a positronic brain.", 60 SECONDS)
		addtimer(CALLBACK(src, .proc/reset_search), askDelay)

/obj/item/organ/internal/posibrain/proc/reset_search() //We give the players time to decide, then reset the timer.
	if(!brainmob?.key)
		searching = FALSE
		icon_state = "posibrain"
		visible_message(SPAN_WARNING("The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?"))

/obj/item/organ/internal/posibrain/attack_ghost(var/mob/observer/ghost/user)
	if(!searching || (src.brainmob && src.brainmob.key))
		return

	var/decl/ghosttrap/G = GET_DECL(/decl/ghosttrap/positronic_brain)
	if(!G.assess_candidate(user))
		return
	var/response = alert(user, "Are you sure you wish to possess this [src]?", "Possess [src]", "Yes", "No")
	if(response == "Yes")
		G.transfer_personality(user, brainmob)

/obj/item/organ/internal/posibrain/examine(mob/user)
	. = ..()

	var/msg = "<span class='info'>*---------*</span>\nThis is [html_icon(src)] \a <EM>[src]</EM>!\n[desc]\n"

	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"

	msg += "</span><span class='info'>*---------*</span>"
	to_chat(user, msg)
	return

/obj/item/organ/internal/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()

/obj/item/organ/internal/posibrain/proc/PickName()
	src.brainmob.SetName("[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[random_id(type,100,999)]")
	src.brainmob.real_name = src.brainmob.name

/obj/item/organ/internal/posibrain/on_update_icon()
	. = ..()
	if(src.brainmob && src.brainmob.key)
		icon_state = "posibrain-occupied"
	else
		icon_state = "posibrain"

/obj/item/organ/internal/posibrain/proc/transfer_identity(var/mob/living/carbon/H)
	if(H && H.mind)
		brainmob.set_stat(CONSCIOUS)
		H.mind.transfer_to(brainmob)
		brainmob.SetName(H.real_name)
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()

	update_icon()

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/posibrain/on_add_effects()
	if(brainmob)
		if(brainmob.mind)
			if(owner.key)
				owner.ghostize()
			brainmob.mind.transfer_to(owner)
		else if(brainmob.key) //posibrain init with a dummy brainmob for some reasons, so gotta do this or its gonna disconnect the client on mob transformation
			owner.key = brainmob.key
	return ..()

/obj/item/organ/internal/posibrain/on_remove_effects()
	if(istype(owner))
		transfer_identity(owner)
	return ..()

/obj/item/organ/internal/posibrain/do_install(mob/living/carbon/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	if(!(. = ..()))
		return
	if(istype(owner))
		SetName(initial(name)) //Reset the organ's name to stay coherent if we're put back into someone's skull

/obj/item/organ/internal/posibrain/do_uninstall(in_place, detach, ignore_children)
	if(!in_place && istype(owner) && name == initial(name))
		SetName("\the [owner.real_name]'s [initial(name)]")
	return ..()

/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon_state = "cell"
	dead_icon = "cell_bork"
	organ_tag = BP_CELL
	parent_organ = BP_CHEST
	organ_properties = ORGAN_PROP_PROSTHETIC //triggers robotization on init
	var/open
	var/obj/item/cell/cell = /obj/item/cell/hyper
	//at 0.8 completely depleted after 60ish minutes of constant walking or 130 minutes of standing still
	var/servo_cost = 0.8

/obj/item/organ/internal/cell/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	. = ..()

/obj/item/organ/internal/cell/proc/percent()
	if(!cell)
		return 0
	return get_charge()/cell.maxcharge * 100

/obj/item/organ/internal/cell/proc/get_charge()
	if(!cell)
		return 0
	if(status & ORGAN_DEAD)
		return 0
	return round(cell.charge*(1 - damage/max_damage))

/obj/item/organ/internal/cell/proc/checked_use(var/amount)
	if(!is_usable())
		return FALSE
	return cell && cell.checked_use(amount)

/obj/item/organ/internal/cell/proc/use(var/amount)
	if(!is_usable())
		return 0
	return cell && cell.use(amount)

/obj/item/organ/internal/cell/proc/get_power_drain()
	var/damage_factor = 1 + 10 * damage/max_damage
	return servo_cost * damage_factor

/obj/item/organ/internal/cell/Process()
	..()
	if(!owner)
		return
	if(owner.stat == DEAD)	//not a drain anymore
		return
	var/cost = get_power_drain()
	if(world.time - owner.l_move_time < 15)
		cost *= 2
	if(!checked_use(cost) && owner.isSynthetic())
		if(!owner.lying && !owner.buckled)
			to_chat(owner, "<span class='warning'>You don't have enough energy to function!</span>")
		SET_STATUS_MAX(owner, STAT_PARA, 3)

/obj/item/organ/internal/cell/emp_act(severity)
	..()
	if(cell)
		cell.emp_act(severity)

/obj/item/organ/internal/cell/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		if(open)
			open = 0
			to_chat(user, "<span class='notice'>You screw the battery panel in place.</span>")
		else
			open = 1
			to_chat(user, "<span class='notice'>You unscrew the battery panel.</span>")

	if(IS_CROWBAR(W))
		if(open)
			if(cell)
				user.put_in_hands(cell)
				to_chat(user, "<span class='notice'>You remove \the [cell] from \the [src].</span>")
				cell = null

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "<span class ='warning'>There is a power cell already installed.</span>")
			else if(user.try_unequip(W, src))
				cell = W
				to_chat(user, "<span class = 'notice'>You insert \the [cell].</span>")

/obj/item/organ/internal/cell/on_add_effects()
	. = ..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/cell/listen()
	if(get_charge())
		return "faint hum of the power bank"

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/internal/mmi_holder
	name = "brain interface"
	icon_state = "mmi-empty"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	organ_properties = ORGAN_PROP_PROSTHETIC //triggers robotization on init
	scale_max_damage_to_species_health = FALSE
	var/obj/item/mmi/stored_mmi
	var/datum/mind/persistantMind //Mind that the organ will hold on to after being removed, used for transfer_and_delete
	var/ownerckey // used in the event the owner is out of body

/obj/item/organ/internal/mmi_holder/Destroy()
	stored_mmi = null
	persistantMind = null
	return ..()

/obj/item/organ/internal/mmi_holder/do_install(mob/living/carbon/human/target, obj/item/organ/external/affected, in_place)
	if(status & ORGAN_CUT_AWAY || !(. = ..()))
		return

	if(!stored_mmi)
		stored_mmi = new(src)
	update_from_mmi()
	persistantMind = owner.mind
	ownerckey = owner.ckey

/obj/item/organ/internal/mmi_holder/proc/update_from_mmi()

	if(!stored_mmi.brainmob)
		stored_mmi.brainmob = new(stored_mmi)
		stored_mmi.brainobj = new(stored_mmi)
		stored_mmi.brainmob.container = stored_mmi
		stored_mmi.brainmob.real_name = owner.real_name
		stored_mmi.brainmob.SetName(stored_mmi.brainmob.real_name)
		stored_mmi.SetName("[initial(stored_mmi.name)] ([owner.real_name])")

	if(!owner) return

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon

	stored_mmi.icon_state = "mmi-full"
	icon_state = stored_mmi.icon_state

	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.switch_from_dead_to_living_mob_list()
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/mmi_holder/on_remove_effects(mob/living/last_owner)
	if(last_owner && last_owner.mind)
		persistantMind = last_owner.mind
		if(last_owner.ckey)
			ownerckey = last_owner.ckey
	. = ..()

/obj/item/organ/internal/mmi_holder/proc/transfer_and_delete()
	if(stored_mmi)
		. = stored_mmi
		stored_mmi.forceMove(src.loc)
		if(persistantMind)
			persistantMind.transfer_to(stored_mmi.brainmob)
		else
			var/response = input(find_dead_player(ownerckey, 1), "Your [initial(stored_mmi.name)] has been removed from your body. Do you wish to return to life?", "Robotic Rebirth") as anything in list("Yes", "No")
			if(response == "Yes")
				persistantMind.transfer_to(stored_mmi.brainmob)
	qdel(src)

//Since the mmi_holder is an horrible hacky pos we turn it into a mmi on drop, since it shouldn't exist outside a mob
/obj/item/organ/internal/mmi_holder/dropInto(atom/destination)
	. = ..()
	if (!QDELETED(src))
		transfer_and_delete()
