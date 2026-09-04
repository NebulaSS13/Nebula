/obj/item/scanner/spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample or analyzes unusual chemicals."
	icon = 'icons/obj/items/device/scanner/spectrometer.dmi'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = @'{"magnets":2,"biotech":2}'
	window_width = 550
	window_height = 300
	scan_sound = 'sound/effects/scanbeep.ogg'
	chem_volume = 5
	var/details = 0

/obj/item/scanner/spectrometer/on_reagent_change()
	if((. = ..()))
		update_icon()

/obj/item/scanner/spectrometer/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(REAGENT_TOTAL_VOLUME(reagents))
		icon_state += "_loaded"

/obj/item/scanner/spectrometer/is_valid_scan_target(atom/O)
	if(!O.reagents || !REAGENT_TOTAL_VOLUME(O.reagents))
		return FALSE
	return (O.atom_flags & ATOM_FLAG_OPEN_CONTAINER) || istype(O, /obj/item/chems/syringe)

/obj/item/scanner/spectrometer/scan(atom/A, mob/user)
	if(A != src)
		to_chat(user, "<span class='notice'>\The [src] takes a sample out of \the [A]</span>")
		reagents.clear_reagents()
		A.reagents.trans_to(src, 5)
	scan_title = "Spectrometer scan - [A]"
	scan_data = mass_spectrometer_scan(reagents, user, details)
	reagents.clear_reagents()
	user.show_message(scan_data)

/obj/item/scanner/spectrometer/attack_self(mob/user)
	if(!can_use(user))
		return
	if(REAGENT_TOTAL_VOLUME(reagents))
		scan(src, user)
	else
		..()

/proc/mass_spectrometer_scan(var/datum/reagents/reagents, mob/user, var/details)
	if(!REAGENT_TOTAL_VOLUME(reagents))
		return SPAN_WARNING("No sample to scan.")
	var/list/blood_traces = list()
	var/list/blood_doses = list()

	var/decl/material/liquid/random/random = reagents.get_primary_reagent_decl()
	if(length(REAGENT_VOLUMES(reagents)) == 1 && istype(random))
		return random.get_scan_data(user)

	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(reagents))
		if(!istype(reagent, /decl/material/liquid/blood))
			return SPAN_WARNING("The sample was contaminated! Please insert another sample.")
		var/data = REAGENT_DATA(reagents, reagent)
		if(islist(data))
			blood_traces = data[DATA_BLOOD_TRACE_CHEM]
			blood_doses = data[DATA_BLOOD_DOSE_CHEM]
		break

	var/list/dat = list("Trace Chemicals Found: ")
	for(var/trace_type in blood_traces)
		var/decl/material/trace_material = GET_DECL(trace_type)
		if(details)
			dat += "[trace_material.use_name] ([blood_traces[trace_type]] units) "
		else
			dat += "[trace_material.use_name] "
	if(details)
		dat += "Metabolism Products of Chemicals Found:"
		for(var/dose_type in blood_doses)
			var/decl/material/dose_material = GET_DECL(dose_type)
			dat += "[dose_material.use_name] ([blood_doses[dose_type]] units) "

	return jointext(dat, "<br>")

/obj/item/scanner/spectrometer/adv
	name = "advanced mass spectrometer"
	icon = 'icons/obj/items/device/scanner/advanced_spectrometer.dmi'
	details = 1
	origin_tech = @'{"magnets":4,"biotech":2}'