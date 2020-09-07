/obj/machinery/sleeper
	name = "sleeper"
	desc = "A suspension chamber with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/cryogenics_coffin.dmi'
	icon_state = "med_pod_preview"
	density = TRUE
	anchored = TRUE
	stat_immune = 0
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	base_type = /obj/machinery/sleeper
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	idle_power_usage = 15
	active_power_usage = 1 KILOWATTS //builtin health analyzer, dialysis machine, injectors.
	pixel_z = -8

	var/mob/living/carbon/human/occupant
	var/obj/item/chems/glass/beaker = null
	var/filtering = 0
	var/pump
	var/list/stasis_settings = list(1, 2, 5, 10)
	var/stasis = 1
	var/pump_speed
	var/stasis_power = 5 KILOWATTS
	var/list/loaded_canisters
	var/max_canister_capacity = 5
	var/global/list/banned_chem_types = list(
		/decl/material/liquid/bromide,
		/decl/material/liquid/mutagenics,
		/decl/material/liquid/acid
	)

/obj/machinery/sleeper/standard/Initialize(mapload, d, populate_parts)
	. = ..()
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/stabilizer()) 
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/sedatives())
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/painkillers())
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/antitoxins())
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/oxy_meds())

/obj/machinery/sleeper/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL_LIST(loaded_canisters)
	go_out()
	. = ..()

/obj/machinery/sleeper/proc/add_reagent_canister(var/mob/user, var/obj/item/chems/chem_disp_cartridge/canister)
	if(!istype(canister))
		to_chat(user, SPAN_WARNING("\The [src] can only be loaded with chemical canisters."))
		return FALSE
	if(length(loaded_canisters)+1 > max_canister_capacity)
		to_chat(user, SPAN_WARNING("\The [src] cannot accept any more chemical canisters."))
		return FALSE
	if(!emagged)
		for(var/rid in canister.reagents?.reagent_volumes)
			var/decl/material/reagent = decls_repository.get_decl(rid)
			for(var/banned_type in banned_chem_types)
				if(istype(reagent, banned_type))
					to_chat(user, SPAN_WARNING("Automatic safety checking indicates the present of a prohibited substance in this canister."))
					return FALSE
	var/mob/M = canister.loc
	if(istype(M) && !M.unEquip(canister, src))
		return FALSE
	if(canister.loc != src)
		canister.forceMove(src)
	LAZYDISTINCTADD(loaded_canisters, canister)
	to_chat(user, SPAN_NOTICE("You load \the [src] with \the [canister]."))
	return TRUE

/obj/machinery/sleeper/proc/eject_reagent_canister(var/mob/user, var/obj/canister)
	if(!canister || !(canister in loaded_canisters))
		return FALSE
	LAZYREMOVE(loaded_canisters, canister)
	canister.dropInto(loc)
	to_chat(user, SPAN_NOTICE("You remove \the [canister] from \the [src]."))
	return TRUE

/obj/machinery/sleeper/Initialize(mapload, d = 0, populate_parts = TRUE)
	. = ..()
	if(populate_parts)
		beaker = new /obj/item/chems/glass/beaker/large(src)
	update_icon()

/obj/machinery/sleeper/examine(mob/user, distance)
	. = ..()
	if (distance <= 1)
		if(beaker)
			to_chat(user, SPAN_NOTICE("It is loaded with a beaker."))
		if(occupant)
			occupant.examine(arglist(args))
		if(emagged && user.skill_check(SKILL_MEDICAL, SKILL_EXPERT))
			to_chat(user, SPAN_NOTICE("The chemical input system looks like it has been tampered with."))
		if(length(loaded_canisters))
			to_chat(user, SPAN_NOTICE("There are [length(loaded_canisters)] chemical canister\s loaded:"))
			for(var/thing in loaded_canisters)
				to_chat(user, SPAN_NOTICE("- \The [thing]"))
		else
			to_chat(user, SPAN_NOTICE("There are no chemical canisters loaded."))

/obj/machinery/sleeper/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = LAZYLEN(occupant.reagents?.reagent_volumes)
				if(pumped)
					occupant.reagents.trans_to_obj(beaker, pump_speed * pumped)
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()
	if(pump > 0)
		if(beaker && istype(occupant))
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/datum/reagents/ingested = occupant.get_ingested_reagents()
				if(ingested)
					var/trans_amt = LAZYLEN(ingested.reagent_volumes)
					if(trans_amt)
						ingested.trans_to_obj(beaker, pump_speed * trans_amt)
		else
			toggle_pump()

	if(iscarbon(occupant) && stasis > 1)
		occupant.SetStasis(stasis)

/obj/machinery/sleeper/on_update_icon()
	overlays.Cut()
	icon_state = "med_pod"
	if(occupant)
		var/image/pickle = new
		pickle.appearance = occupant
		pickle.layer = FLOAT_LAYER
		pickle.pixel_z = 12
		overlays += pickle
	var/image/I = image(icon, "med_lid[!!(occupant && !(stat & (BROKEN|NOPOWER)))]")
	overlays += I

/obj/machinery/sleeper/DefaultTopicState()
	return GLOB.outside_state

/obj/machinery/sleeper/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/sleeper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/empties = 0
	var/list/loaded_reagents = list()
	for(var/obj/item/chems/chem_disp_cartridge/canister in loaded_canisters)
		if(!canister.reagents || !canister.reagents.total_volume)
			empties++
			continue
		var/list/reagent = list()
		reagent["name"] =   canister.label || "unlabeled"
		reagent["id"] =     "\ref[canister]"
		reagent["amount"] = canister.reagents.total_volume
		loaded_reagents += list(reagent)
	data["reagents"] = loaded_reagents
	data["empty_canisters"] = empties

	if(istype(occupant))
		var/scan = user.skill_check(SKILL_MEDICAL, SKILL_ADEPT) ? medical_scan_results(occupant) : "<span class='white'><b>Contains: \the [occupant]</b></span>"
		scan = replacetext(scan,"'scan_notice'","'white'")
		scan = replacetext(scan,"'scan_warning'","'average'")
		scan = replacetext(scan,"'scan_danger'","'bad'")
		data["occupant"] = scan
	else
		data["occupant"] = 0

	if(beaker)
		data["beaker"] = REAGENTS_FREE_SPACE(beaker.reagents)
	else
		data["beaker"] = -1
	data["filtering"] = filtering
	data["pump"] = pump
	data["stasis"] = stasis
	data["skill_check"] = user.skill_check(SKILL_MEDICAL, SKILL_BASIC)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/sleeper/CanUseTopic(user)
	if(user == occupant)
		to_chat(usr, SPAN_WARNING("You can't reach the controls from the inside."))
		return STATUS_CLOSE
	. = ..()

/obj/machinery/sleeper/OnTopic(user, href_list)
	if(href_list["eject_empties"])
		. = TOPIC_NOACTION
		for(var/obj/item/canister in loaded_canisters)
			if(!canister.reagents || !canister.reagents.total_volume)
				eject_reagent_canister(null, canister)
				. = TOPIC_REFRESH
	if(href_list["eject"])
		go_out()
		return TOPIC_REFRESH
	if(href_list["beaker"])
		remove_beaker()
		return TOPIC_REFRESH
	if(href_list["filter"])
		if(filtering != text2num(href_list["filter"]))
			toggle_filter()
			return TOPIC_REFRESH
	if(href_list["pump"])
		if(filtering != text2num(href_list["pump"]))
			toggle_pump()
			return TOPIC_REFRESH
	if(href_list["chemical"])
		var/obj/canister = locate(href_list["chemical"])
		if(istype(canister))
			if(href_list["amount"] && occupant && occupant.stat != DEAD)
				var/transfer_type = href_list["contact_chem"] ? CHEM_TOUCH : CHEM_INJECT
				inject_chemical(user, canister, text2num(href_list["amount"]), transfer_type)
				return TOPIC_REFRESH
			if(href_list["eject_canister"])
				eject_reagent_canister(user, canister)
				return TOPIC_REFRESH
	if(href_list["stasis"])
		var/nstasis = text2num(href_list["stasis"])
		if(stasis != nstasis && (nstasis in stasis_settings))
			stasis = text2num(href_list["stasis"])
			change_power_consumption(initial(active_power_usage) + stasis_power * (stasis-1), POWER_USE_ACTIVE)
			return TOPIC_REFRESH

/obj/machinery/sleeper/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()
		go_out()

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/chems/chem_disp_cartridge))
		add_reagent_canister(user, I)
		return TRUE
	if(istype(I, /obj/item/chems/glass))
		add_fingerprint(user)
		if(!beaker)
			if(!user.unEquip(I, src))
				return
			beaker = I
			user.visible_message(SPAN_NOTICE("\The [user] adds \a [I] to \the [src]."), SPAN_NOTICE("You add \a [I] to \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] has a beaker already."))
		return TRUE
	return ..()

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, SPAN_WARNING("Unbuckle the subject before attempting to move them."))
		return
	if(panel_open)
		to_chat(user, SPAN_WARNING("Close the maintenance panel before attempting to place the subject in the sleeper."))
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	to_chat(occupant, SPAN_WARNING("You feel like your blood is being sucked away."))
	filtering = !filtering

/obj/machinery/sleeper/proc/toggle_pump()
	if(!occupant || !beaker)
		pump = 0
		return
	to_chat(occupant, SPAN_WARNING("You feel a tube jammed down your throat."))
	pump = !pump

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20, src))
		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
			return
		set_occupant(M)

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	set_occupant(null)

	for(var/obj/O in (contents - (component_parts + loaded_canisters))) // In case an object was dropped inside or something. Excludes the beaker and component parts.
		if(O != beaker)
			O.dropInto(loc)
	toggle_filter()

/obj/machinery/sleeper/proc/set_occupant(var/mob/living/carbon/occupant)
	src.occupant = occupant
	update_icon()
	if(!occupant)
		SetName(initial(name))
		update_use_power(POWER_USE_IDLE)
		return
	occupant.forceMove(src)
	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	SetName("[name] ([occupant])")
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.dropInto(loc)
		beaker = null
		toggle_filter()
		toggle_pump()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/obj/canister, var/amount, var/target_transfer_type = CHEM_INJECT)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!istype(canister) || canister.loc != src)
		to_chat(user, SPAN_WARNING("\The [src] cannot locate that canister."))
		return
	if(canister.reagents?.total_volume < amount)
		to_chat(user, SPAN_WARNING("\The [canister] has less than [amount] unit\s left."))
		return
	if(!occupant || !occupant.reagents)
		to_chat(user, SPAN_WARNING("There's no suitable occupant in \the [src]."))
		return
	if(occupant.reagents.total_volume + amount > 20 && !emagged)
		to_chat(user, SPAN_WARNING("Injecting more chemicals presents an overdose risk to the subject."))
		return
	canister.reagents.trans_to_mob(occupant, amount, target_transfer_type)
	to_chat(user, SPAN_NOTICE("You use \the [src] to [target_transfer_type == CHEM_INJECT ? "inject" : "infuse"] [amount] unit\s from \the [canister] into \the [occupant]."))

/obj/machinery/sleeper/RefreshParts()
	..()
	pump_speed = 2 + max(Clamp(total_component_rating_of_type(/obj/item/stock_parts/scanning_module), 1, 10), 1)
	max_canister_capacity = 5 + round(total_component_rating_of_type(/obj/item/stock_parts/manipulator)/2)

/obj/machinery/sleeper/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, SPAN_DANGER("You [emagged ? "disable" : "enable"] \the [src]'s chemical injection safety checks."))
