/datum/materials
	var/weakref/owner
	var/list/matter
	var/list/color_overrides

/datum/materials/New(var/obj/new_owner)
	if(!istype(new_owner))
		PRINT_STACK_TRACE("Materials datum initialized with a non-obj owner.")
		return
	owner = weakref(new_owner)

/datum/materials/Destroy(force)
	. = ..()
	if(owner)
		var/obj/owner_obj = owner.resolve()
		if(istype(owner_obj) && owner_obj.get_material_composition() == src)
			owner_obj.set_material_composition(null)
		owner = null

/datum/materials/proc/set_material_composition(var/list/new_materials)
	matter = (islist(new_materials) && length(new_materials)) ? new_materials : null
	if(!length(matter))
		qdel(src)
		return
	matter = sortTim(matter, /proc/cmp_numeric_dsc, TRUE)

/datum/materials/proc/get_primary_material()
	. = length(matter) >= 1 && GET_DECL(matter[1])

/datum/materials/proc/set_primary_material(var/material)
	var/obj/owner_obj = owner?.resolve()
	if(!istype(owner_obj) || !length(matter) || matter[1] == material)
		return
	var/new_val = max(matter[matter[1]], MATTER_AMOUNT_PRIMARY * owner_obj.get_matter_amount_modifier())
	matter -= material
	matter.Insert(1, material)
	matter[material] = new_val
	owner_obj.on_material_change()

/datum/materials/proc/get_reinforcing_material()
	. = length(matter) >= 2 && GET_DECL(matter[2])

/datum/materials/proc/set_reinforcing_material(var/material)
	var/obj/owner_obj = owner?.resolve()
	if(!istype(owner_obj) || length(matter) < 2 || matter[2] == material)
		return
	var/new_val = max(matter[matter[2]], MATTER_AMOUNT_SECONDARY * owner_obj.get_matter_amount_modifier())
	matter -= material
	matter.Insert(2, material)
	matter[material] = new_val
	owner_obj.on_material_change()

/datum/materials/proc/get_material(var/material_type)
	return LAZYACCESS(matter, material_type)

/datum/materials/proc/set_material(var/material_type, var/material_amount)
	material_amount = max(0, round(material_amount))
	if(!isnum(material_amount) || material_amount < 0)
		return
	LAZYREMOVE(matter, material_type)
	if(material_amount <= 0)
		if(!length(matter))
			qdel(src)
			. = TRUE
	if(!.)
		if(!length(matter))
			LAZYSET(matter, material_type, material_amount)
			. = TRUE
		else
			for(var/i = 1 to length(matter))
				if(material_amount >= matter[matter[i]])
					matter.Insert(i, material_type)
					matter[material_type] = material_amount
					. = TRUE
					break
	if(.)
		var/obj/owner_obj = owner?.resolve()
		if(istype(owner_obj))
			owner_obj.on_material_change()

/datum/materials/proc/add_material(var/material_type, var/material_amount)
	set_material(material_type, material_amount + LAZYACCESS(matter, material_type))

/datum/materials/proc/remove_material(var/material_type, var/material_amount)
	var/existing_amount = LAZYACCESS(matter, material_type) || 0
	if(existing_amount)
		set_material(material_type, max(0, round(existing_amount - material_amount)))

/datum/materials/proc/clear_material(var/material_type)
	if(LAZYACCESS(matter, material_type))
		set_material(material_type, 0)

/datum/materials/proc/convert_to_sheets(var/atom/dump_loc)
	for(var/material_type in matter)
		LAZYADD(., convert_material_to_sheets(material_type, dump_loc))

/datum/materials/proc/convert_material_to_sheets(var/material_type, var/dump_loc)
	var/decl/material/material = GET_DECL(material_type)
	if(material)
		LAZYADD(., material.place_sheet(dump_loc, round(matter[material_type]/SHEET_MATERIAL_AMOUNT)))
		clear_material(material_type)
