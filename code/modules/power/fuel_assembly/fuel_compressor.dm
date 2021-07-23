#define MAX_ROD_MATERIAL 10000

/obj/machinery/fuel_compressor
	name = "fuel compressor"
	desc = "A machine used for the compression of fuel rods for nuclear power production."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_compressor1"
	density = 1
	anchored = 1
	layer = 4
	construct_state = /decl/machine_construction/default/panel_closed
	var/list/stored_material = list()
	var/list/rod_makeup = list()

/obj/machinery/fuel_compressor/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/fuel_compressor/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	for(var/mat_type in stored_material)
		var/decl/material/mat = decls_repository.get_decl(mat_type)
		data["stored_material"] += list(list("name" = mat.name, "amount" = stored_material[mat_type]))
	
	for(var/mat_type in rod_makeup)
		var/decl/material/mat = decls_repository.get_decl(mat_type)
		data["rod_makeup"] += list(list("name" = mat.name, "amount" = rod_makeup[mat_type]))
	
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fuel_compressor.tmpl", name, 500, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/fuel_compressor/OnTopic(user, href_list, state)
	. = ..()
	if(href_list["eject_material"])
		. = eject_material(href_list["eject_material"])
	if(href_list["make_rod"])
		. = make_rod()
	if(href_list["change_makeup"])
		. = change_makeup(href_list["change_makeup"], user)
	if(href_list["clear_makeup"])
		rod_makeup.Cut()
		return TOPIC_REFRESH

/obj/machinery/fuel_compressor/proc/eject_material(var/mat_name)
	var/mat_type
	for(var/mat_p in stored_material)
		var/decl/material/mat = decls_repository.get_decl(mat_p)
		if(mat.name == mat_name)
			mat_type = mat.type
			break

	if(!mat_type)
		return TOPIC_HANDLED

	var/decl/material/mat = decls_repository.get_decl(mat_type)
	if(mat && stored_material[mat_type] >= SHEET_MATERIAL_AMOUNT)
		var/sheet_count = FLOOR(stored_material[mat_type]/SHEET_MATERIAL_AMOUNT)
		stored_material[mat_type] -= sheet_count * SHEET_MATERIAL_AMOUNT
		SSmaterials.create_object(mat_type, get_turf(src), sheet_count)
		if(isnull(stored_material[mat_type]))
			stored_material -= mat_type
	else if(!isnull(stored_material[mat_type]))
		stored_material -= mat_type
	
	return TOPIC_REFRESH

/obj/machinery/fuel_compressor/proc/make_rod()
	var/total_matter = 0
	for(var/mat_p in rod_makeup)
		total_matter += rod_makeup[mat_p]
		if(total_matter > MAX_ROD_MATERIAL)
			visible_message(SPAN_WARNING("\The [src] flashes an 'Over max material' error!"))
			return TOPIC_HANDLED
		if(rod_makeup[mat_p] > stored_material[mat_p])
			visible_message(SPAN_WARNING("\The [src] flashes an 'Insufficient Materials' error!"))
			return TOPIC_HANDLED
	
	for(var/mat_p in rod_makeup)
		stored_material[mat_p] -= rod_makeup[mat_p]
		if(stored_material[mat_p] == 0)
			stored_material -= mat_p
	
	visible_message(SPAN_NOTICE("\The [src] compresses the material into a new fuel assembly."))
	new /obj/item/fuel_assembly(get_turf(src), null, rod_makeup)
	return TOPIC_REFRESH

/obj/machinery/fuel_compressor/proc/change_makeup(var/mat_name, var/mob/user)
	var/mat_type
	for(var/mat_p in stored_material)
		var/decl/material/mat = decls_repository.get_decl(mat_p)
		if(mat.name == mat_name)
			mat_type = mat.type
			break

	if(!mat_type)
		return TOPIC_HANDLED
	var/amt = input(user, "Enter the amount of this material per rod (Max [MAX_ROD_MATERIAL]):", "Fuel Rod Makeup", rod_makeup[mat_type]) as null|num
	if(!CanInteract(user, DefaultTopicState()))
		return TOPIC_HANDLED
	amt = round(Clamp(amt, 0, MAX_ROD_MATERIAL))
	if(!amt)
		rod_makeup -= mat_type
		return TOPIC_REFRESH			
	rod_makeup[mat_type] = amt
	return TOPIC_REFRESH

/obj/machinery/fuel_compressor/receive_mouse_drop(var/atom/movable/dropping, var/mob/user)
	if(user.incapacitated() || !user.Adjacent(src))
		return
	return !add_material(dropping, user)

/obj/machinery/fuel_compressor/attackby(var/obj/item/thing, var/mob/user)
	return add_material(thing, user) || ..()

/obj/machinery/fuel_compressor/proc/add_material(var/obj/item/thing, var/mob/user)
	if(istype(thing) && thing.reagents && thing.reagents.total_volume && ATOM_IS_OPEN_CONTAINER(thing))
		for(var/R in thing.reagents.reagent_volumes)
			var/taking_reagent = REAGENT_VOLUME(thing.reagents, R)
			thing.reagents.remove_reagent(R, taking_reagent)
			stored_material[R] += taking_reagent
	
		to_chat(user, SPAN_NOTICE("You add the contents of \the [thing] to \the [src]'s material buffer."))
		return TRUE

	if(istype(thing, /obj/machinery/power/supermatter/shard))
		stored_material[/decl/material/solid/exotic_matter] = 5 * SHEET_MATERIAL_AMOUNT
		to_chat(user, SPAN_NOTICE("You awkwardly cram \the [thing] into \the [src]'s material buffer."))
		qdel(thing)
		return TRUE

	if(istype(thing, /obj/item/stack/material))
		var/obj/item/stack/material/M = thing
		var/decl/material/mat = M.get_material()
		
		var/taken = min(M.amount, 5)
		M.use(taken)
		stored_material[mat.type] += taken * SHEET_MATERIAL_AMOUNT
		to_chat(user, SPAN_NOTICE("You add [taken] sheet\s of \the [thing] to \the [src]'s material buffer."))
		return TRUE

	return FALSE

#undef MAX_ROD_MATERIAL