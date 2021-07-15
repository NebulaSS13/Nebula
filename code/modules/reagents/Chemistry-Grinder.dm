/obj/machinery/reagentgrinder
	name = "reagent grinder"
	desc = "An industrial reagent grinder with heavy carbide cutting blades."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "rgrinder"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/inuse = 0
	var/obj/item/chems/beaker = null
	var/limit = 10
	var/list/holdingitems = list()

	var/list/bag_whitelist = list(
		/obj/item/storage/pill_bottle,
		/obj/item/storage/plants
		)
	var/blacklisted_types = list()
	var/item_size_limit = ITEM_SIZE_HUGE
	var/skill_to_check = SKILL_CHEMISTRY
	var/grind_sound = 'sound/machines/grinder.ogg'

	stat_immune = 0
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

/obj/machinery/reagentgrinder/Initialize()
	. = ..()
	beaker = new /obj/item/chems/glass/beaker/large(src)
	update_icon()

/obj/machinery/reagentgrinder/on_update_icon()
	if(inuse)
		icon_state = "[initial(icon_state)]_grinding"
	else if(beaker)
		icon_state = "[initial(icon_state)]_beaker"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/reagentgrinder/attackby(var/obj/item/O, var/mob/user)
	if((. = ..()))
		return

	if(!istype(O))
		return FALSE

	if (istype(O,/obj/item/chems/glass) || \
		istype(O,/obj/item/chems/food/drinks/glass2) || \
		istype(O,/obj/item/chems/food/drinks/shaker))

		if (beaker)
			return TRUE
		else
			if(!user.unEquip(O, src))
				return FALSE
			beaker =  O
			update_icon()
			SSnano.update_uis(src)
			return FALSE

	if(LAZYLEN(holdingitems) >= limit)
		to_chat(user, SPAN_NOTICE("\The [src] cannot hold any additional items."))
		return TRUE

	if(is_type_in_list(O, blacklisted_types))
		to_chat(user, SPAN_NOTICE("\The [src] cannot grind \the [O]."))
		return FALSE

	if(is_type_in_list(O, bag_whitelist))
		var/obj/item/storage/bag = O
		var/failed = TRUE
		for(var/obj/item/G in O)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = FALSE
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(LAZYLEN(holdingitems) >= limit)
				break

		if(failed)
			to_chat(user, SPAN_NOTICE("Nothing in \the [O] is usable."))
			return TRUE
		bag.finish_bulk_removal()

		if(!length(O.contents))
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		SSnano.update_uis(src)
		return FALSE

	if(O.w_class > item_size_limit)
		to_chat(user, SPAN_NOTICE("\The [src] cannot fit \the [O]."))
		return

	if(istype(O,/obj/item/stack/material))
		var/decl/material/material = O.get_material()
		if(!material)
			to_chat(user, SPAN_NOTICE("\The [material.solid_name] cannot be ground down to any usable reagents."))
			return TRUE

	else if(!O.reagents?.total_volume)
		to_chat(user, SPAN_NOTICE("\The [O] is not suitable for grinding."))
		return TRUE

	if(!user.unEquip(O, src))
		return FALSE
	holdingitems += O
	SSnano.update_uis(src)
	return FALSE

/obj/machinery/reagentgrinder/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/reagentgrinder/DefaultTopicState()
	return global.physical_topic_state

/obj/machinery/reagentgrinder/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	data["inuse"] = inuse
	data["beaker"] = !!beaker

	data["contents"] = list()
	for(var/obj/item/O in holdingitems)
		data["contents"] += "<b>[capitalize(O.name)]</b>"

	data["beakercontents"] = list()
	if(beaker?.reagents)
		for(var/rtype in beaker.reagents.reagent_volumes)
			var/decl/material/R = GET_DECL(rtype)
			data["beakercontents"] += "<b>[capitalize(R.name)]</b> ([REAGENT_VOLUME(beaker.reagents, rtype)]u)"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "rgrinder.tmpl", name, 350, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/reagentgrinder/OnTopic(user, href_list)
	if(href_list["action"])
		switch(href_list["action"])
			if("grind")
				grind(user)
			if("eject")
				eject()
			if("detach")
				detach()
		return TOPIC_REFRESH
	return TOPIC_NOACTION

/obj/machinery/reagentgrinder/CouldNotUseTopic(mob/user)
	. = ..()
	if(inoperable())
		to_chat(user, SPAN_WARNING("\The [src] is too broken to use."))

/obj/machinery/reagentgrinder/proc/detach()
	if (!beaker)
		return FALSE
	beaker.dropInto(loc)
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()
	if (!LAZYLEN(holdingitems))
		return FALSE

	for(var/obj/item/O in holdingitems)
		O.dropInto(loc)
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind(mob/user)

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return FALSE

	// Sanity check.
	if (!beaker || (beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return FALSE

	attempt_skill_effect(user)
	playsound(loc, grind_sound, 75, 1)
	inuse = TRUE
	update_icon()

	// Reset the machine.
	addtimer(CALLBACK(src, .proc/end_grind, user), 6 SECONDS, TIMER_UNIQUE)

	var/skill_factor = CLAMP01(1 + 0.3*(user.get_skill_value(skill_to_check) - SKILL_EXPERT)/(SKILL_EXPERT - SKILL_MIN))
	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		var/obj/item/stack/material/stack = O
		if(istype(stack))
			var/decl/material/material = stack.get_material()
			if(!material)
				break

			var/amount_to_take = max(0,min(stack.amount, FLOOR(remaining_volume / REAGENT_UNITS_PER_MATERIAL_SHEET)))
			if(amount_to_take)
				stack.use(amount_to_take)
				if(QDELETED(stack))
					holdingitems -= stack
				beaker.reagents.add_reagent(material.type, (amount_to_take * REAGENT_UNITS_PER_MATERIAL_SHEET * skill_factor))
				continue

		else if(O.reagents)
			O.reagents.trans_to(beaker, O.reagents.total_volume, skill_factor)
			holdingitems -= O
			qdel(O)

/obj/machinery/reagentgrinder/proc/end_grind(mob/user)
	inuse = FALSE
	if(CanPhysicallyInteractWith(user, src))
		interface_interact(user)

/obj/machinery/reagentgrinder/proc/attempt_skill_effect(mob/living/carbon/human/user)
	if(!istype(user) || !prob(user.skill_fail_chance(skill_to_check, 50, SKILL_BASIC)))
		return FALSE
	var/hand = pick(BP_L_HAND, BP_R_HAND)
	var/obj/item/organ/external/hand_organ = user.get_organ(hand)
	if(!hand_organ)
		return FALSE

	var/dam = rand(10, 15)
	user.visible_message(SPAN_DANGER("\The [user]'s hand gets caught in \the [src]!"), SPAN_DANGER("Your hand gets caught in \the [src]!"))
	user.apply_damage(dam, BRUTE, hand, damage_flags = DAM_SHARP, used_weapon = "grinder")
	if(BP_IS_PROSTHETIC(hand_organ))
		beaker.reagents.add_reagent(/decl/material/solid/metal/iron, dam)
	else
		user.take_blood(beaker, dam)
	SET_STATUS_MAX(user, STAT_STUN, 2)
	shake(user, 40)

/obj/machinery/reagentgrinder/proc/shake(mob/living/user, duration)
	if(!user)
		return
	for(var/i = 1 to duration)
		sleep(1)
		if(!Adjacent(user))
			break
		if(!HAS_STATUS(user, STAT_JITTER))
			user.do_jitter(4)

	if(!HAS_STATUS(user, STAT_JITTER))
		user.do_jitter(0)

/obj/machinery/reagentgrinder/juicer
	name = "blender"
	desc = "A high-speed combination blender/juicer."
	icon_state = "juicer"
	density = FALSE
	anchored = FALSE
	obj_flags = null
	grind_sound = 'sound/machines/juicer.ogg'
	blacklisted_types = list(/obj/item/stack/material)
	bag_whitelist = list(/obj/item/storage/plants)
	item_size_limit = ITEM_SIZE_SMALL
	skill_to_check = SKILL_COOKING

/obj/machinery/reagentgrinder/juicer/attempt_skill_effect(mob/living/carbon/human/user)
	if(!istype(user) || !prob(user.skill_fail_chance(skill_to_check, 50, SKILL_BASIC)))
		return
	visible_message(SPAN_NOTICE("\The [src] whirrs violently and spills its contents all over \the [user]!"))
	if(beaker?.reagents)
		beaker.reagents.splash(user, beaker.reagents.total_volume)