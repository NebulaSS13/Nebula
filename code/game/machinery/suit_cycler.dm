/obj/machinery/suit_cycler

	name = "suit cycler unit"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = 1
	density = 1

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "base"

	initial_access = list(list(access_captain, access_bridge))

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing contaminants.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair = 1      // If set, the cycler can repair voidsuits.
	var/electrified = 0     // If set, will shock users.

	// Possible modifications to pick between
	var/list/available_modifications = list(
		/decl/item_modifier/space_suit/engineering,
		/decl/item_modifier/space_suit/mining,
		/decl/item_modifier/space_suit/medical,
		/decl/item_modifier/space_suit/security,
		/decl/item_modifier/space_suit/atmos,
		/decl/item_modifier/space_suit/science,
		/decl/item_modifier/space_suit/pilot
	)

	// Extra modifications to add when emagged, duplicates won't be added
	var/emagged_modifications = list(
		/decl/item_modifier/space_suit/engineering,
		/decl/item_modifier/space_suit/mining,
		/decl/item_modifier/space_suit/medical,
		/decl/item_modifier/space_suit/security,
		/decl/item_modifier/space_suit/atmos,
		/decl/item_modifier/space_suit/science,
		/decl/item_modifier/space_suit/pilot,
		/decl/item_modifier/space_suit/mercenary/emag
	)

	//Bodytypes that the suits can be configured to fit.
	var/list/available_bodytypes = list(BODYTYPE_HUMANOID)

	var/decl/item_modifier/target_modification
	var/target_bodytype

	var/mob/living/carbon/human/occupant
	var/obj/item/clothing/suit/space/void/suit
	var/obj/item/clothing/head/helmet/space/helmet
	var/obj/item/clothing/shoes/magboots/boots

	wires = /datum/wires/suit_cycler

	stat_immune = 0
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/suit_cycler
	var/buildable = TRUE // Whether this subtype shows up as an option when multitooling circuitboards

/obj/machinery/suit_cycler/on_update_icon()

	var/new_overlays

	if(boots)
		LAZYADD(new_overlays, boots.get_mob_overlay(null, slot_shoes_str))
	if(suit)
		LAZYADD(new_overlays, suit.get_mob_overlay(null, slot_wear_suit_str))
	if(helmet)
		LAZYADD(new_overlays, helmet.get_mob_overlay(null, slot_head_str))
	if(occupant)
		LAZYADD(new_overlays, image(occupant))
	LAZYADD(new_overlays, image(icon, "overbase", layer = ABOVE_HUMAN_LAYER))

	if(locked || active)
		LAZYADD(new_overlays, image(icon, "closed", layer = ABOVE_HUMAN_LAYER))
	else
		LAZYADD(new_overlays, image(icon, "open", layer = ABOVE_HUMAN_LAYER))

	if(irradiating)
		LAZYADD(new_overlays, image(icon, "light_radiation", layer = ABOVE_HUMAN_LAYER))
		set_light(3, 0.8, COLOR_RED_LIGHT)
	else if(active)
		LAZYADD(new_overlays, image(icon, "light_active", layer = ABOVE_HUMAN_LAYER))
		set_light(3, 0.8, COLOR_YELLOW)
	else
		set_light(0)

	if(panel_open)
		LAZYADD(new_overlays, image(icon, "panel", layer = ABOVE_HUMAN_LAYER))

	overlays = new_overlays

/obj/machinery/suit_cycler/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(!length(available_modifications) || !length(available_bodytypes))
		PRINT_STACK_TRACE("Invalid setup: [log_info_line(src)]")
		return INITIALIZE_HINT_QDEL

	if(populate_parts)
		if(ispath(suit))
			suit = new suit(src)
		if(ispath(helmet))
			helmet = new helmet(src)
		if(ispath(boots))
			boots = new boots(src)

	available_modifications = list_values(decls_repository.get_decls(available_modifications))

	target_modification = available_modifications[1]
	target_bodytype = available_bodytypes[1]
	update_icon()

/obj/machinery/suit_cycler/Destroy()
	if(occupant)
		occupant.dropInto(loc)
		occupant.reset_view()
		occupant = null
	DROP_NULL(suit)
	DROP_NULL(helmet)
	DROP_NULL(boots)
	return ..()

/obj/machinery/suit_cycler/receive_mouse_drop(var/atom/dropping, var/mob/user)
	. = ..()
	if(!. && ismob(dropping) && try_move_inside(dropping, user))
		return TRUE

/obj/machinery/suit_cycler/proc/try_move_inside(var/mob/living/target, var/mob/living/user)
	if(!istype(target) || !istype(user) || !target.Adjacent(user) || !user.Adjacent(src) || user.incapacitated())
		return FALSE

	if(locked)
		to_chat(user, SPAN_WARNING("The suit cycler is locked."))
		return FALSE

	if(suit || helmet || boots)
		to_chat(user, SPAN_WARNING("There is no room inside the cycler for \the [target]."))
		return FALSE

	visible_message(SPAN_WARNING("\The [user] starts putting \the [target] into the suit cycler."))
	if(do_after(user, 20, src))
		if(!istype(target) || locked || suit || helmet || !target.Adjacent(user) || !user.Adjacent(src) || user.incapacitated())
			return FALSE
		target.reset_view(src)
		target.forceMove(src)
		occupant = target
		add_fingerprint(user)
		update_icon()
		return TRUE
	return FALSE

/obj/machinery/suit_cycler/attackby(obj/item/I, mob/user)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(isMultitool(I) || isWirecutter(I))
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(try_move_inside(G.affecting, user))
			qdel(G)
			updateUsrDialog()
			return

	else if(istype(I, /obj/item/clothing/shoes/magboots))
		if(locked)
			to_chat(user, SPAN_WARNING("The suit cycler is locked."))
			return
		if(boots)
			to_chat(user, SPAN_WARNING("The cycler already contains some boots."))
			return
		if(!user.unEquip(I, src))
			return
		to_chat(user, "You fit \the [I] into the suit cycler.")
		boots = I
		update_icon()
		updateUsrDialog()

	else if(istype(I,/obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))

		if(locked)
			to_chat(user, SPAN_WARNING("The suit cycler is locked."))
			return

		if(helmet)
			to_chat(user, SPAN_WARNING("The cycler already contains a helmet."))
			return
		if(!user.unEquip(I, src))
			return
		to_chat(user, "You fit \the [I] into the suit cycler.")
		helmet = I
		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/suit/space/void))

		if(locked)
			to_chat(user, SPAN_WARNING("The suit cycler is locked."))
			return

		if(suit)
			to_chat(user, SPAN_WARNING("The cycler already contains a voidsuit."))
			return

		if(!user.unEquip(I, src))
			return
		to_chat(user, "You fit \the [I] into the suit cycler.")
		suit = I
		update_icon()
		updateUsrDialog()
		return

	return ..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, SPAN_WARNING("The cycler has already been subverted."))
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, SPAN_DANGER("You run the sequencer across the interface, corrupting the operating protocols."))

	var/additional_modifications = list_values(decls_repository.get_decls(emagged_modifications))
	available_modifications |= additional_modifications

	emagged = 1
	safeties = 0
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/physical_attack_hand(mob/user)
	if(electrified != 0)
		if(shock(user, 100))
			return TRUE

/obj/machinery/suit_cycler/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/suit_cycler/interact(mob/user)
	user.set_machine(src)

	var/dat = list()
	dat += "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(active)
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(allowed(user))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>Unlock unit</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>Lock unit</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>Eject</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>Eject</a><br/>"
		dat += "<b>Boots: </b> [boots ? "\the [boots]" : "no boots stored" ]. <A href='?src=\ref[src];eject_boots=1'>Eject</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>Repair</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>Select power level</a> <A href='?src=\ref[src];begin_decontamination=1'>Begin decontamination cycle</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_modification.name]</a>, <A href='?src=\ref[src];select_bodytype=1'>[target_bodytype]</a>."
		dat += "<br><A href='?src=\ref[src];apply_paintjob=1'>Apply customisation routine</a><br><hr>"

	var/datum/browser/written/popup = new(user, "suit_cycler", "Suit Cycler")
	popup.set_content(JOINTEXT(dat))
	popup.open()

/obj/machinery/suit_cycler/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["eject_suit"])
		if(!suit) return
		suit.dropInto(loc)
		suit = null
	else if(href_list["eject_helmet"])
		if(!helmet) return
		helmet.dropInto(loc)
		helmet = null
	else if(href_list["eject_boots"])
		if(!boots) return
		boots.dropInto(loc)
		boots = null
	else if(href_list["select_department"])
		var/choice = input("Please select the target department paintjob.", "Suit cycler", target_modification) as null|anything in available_modifications
		if(choice && CanPhysicallyInteract(usr))
			target_modification = choice
	else if(href_list["select_bodytype"])
		var/choice = input("Please select the target body configuration.","Suit cycler",null) as null|anything in available_bodytypes
		if(choice && CanPhysicallyInteract(usr))
			target_bodytype = choice
	else if(href_list["select_rad_level"])
		var/choices = list(1,2,3)
		if(emagged)
			choices = list(1,2,3,4,5)
		var/choice = input("Please select the desired radiation level.","Suit cycler",null) as null|anything in choices
		if(choice)
			radiation_level = choice
	else if(href_list["repair_suit"])

		if(!suit || !can_repair) return
		active = 1
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])

		if(!suit && !helmet) return
		active = 1
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])

		if(allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "lock" : "unlock"] [src].")
		else
			to_chat(usr, FEEDBACK_ACCESS_DENIED)

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			to_chat(usr, SPAN_DANGER("\The [src] has detected an occupant. Please remove the occupant before commencing the decontamination cycle."))
			return

		active = 1
		irradiating = 10
		update_icon()
		updateUsrDialog()

		sleep(10)

		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

		if(boots)
			if(radiation_level > 2)
				boots.decontaminate()
			if(radiation_level > 1)
				boots.clean_blood()

	update_icon()
	updateUsrDialog()

/obj/machinery/suit_cycler/Process()
	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && stat & (BROKEN|NOPOWER))
		active = 0
		irradiating = 0
		electrified = 0
		update_icon()
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		update_icon()
		return

	irradiating--
	update_icon()

	if(occupant)
		if(prob(radiation_level*2) && occupant.can_feel_pain())
			occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0, radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0, radiation_level + rand(1,3))
		occupant.apply_damage(radiation_level*10, IRRADIATE, damage_flags = DAM_DISPERSED)

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_NOTICE("\The [src] pings loudly."))
	active = 0
	updateUsrDialog()
	update_icon()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)
	if (usr.incapacitated())
		return
	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user)

	if(locked || active)
		to_chat(user, SPAN_WARNING("The cycler is locked."))
		return

	if (!occupant)
		return

	occupant.dropInto(loc)
	occupant.reset_view()
	occupant = null

	update_icon()
	add_fingerprint(user)
	updateUsrDialog()

	return

/obj/machinery/suit_cycler/proc/apply_paintjob()
	if(!target_bodytype || !target_modification)
		return

	if(helmet) helmet.refit_for_bodytype(target_bodytype)
	if(suit)   suit.refit_for_bodytype(target_bodytype)
	if(boots)  boots.refit_for_bodytype(target_bodytype)

	target_modification.RefitItem(helmet)
	target_modification.RefitItem(suit)

	if(helmet) helmet.SetName("refitted [helmet.name]")
	if(suit)   suit.SetName("refitted [suit.name]")
	if(boots)  boots.SetName("refitted [initial(boots.name)]")