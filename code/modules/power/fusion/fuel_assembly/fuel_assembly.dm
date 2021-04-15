/obj/item/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"
	layer = 4

	var/material_name
	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/radioactivity = 0
	var/initial_amount

/obj/item/fuel_assembly/Initialize(mapload, var/_material, var/_colour)
	. = ..(mapload, _material)
	initial_amount = SHEET_MATERIAL_AMOUNT * 5 // Fuel compressor eats 5 sheets.
	var/decl/material/material = get_primary_material()
	if(material)
		SetName("[material.use_name] fuel rod assembly")
		desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
		if(material.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			START_PROCESSING(SSobj, src)
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.color)
		rod_quantities[get_primary_material_type()] = initial_amount
		update_icon()

/obj/item/fuel_assembly/on_update_icon()
	icon_state = "fuel_assembly"
	var/decl/material/material = get_primary_material()
	color = material?.color || COLOR_WHITE
	var/image/I = image(icon, "fuel_assembly_bracket")
	I.appearance_flags |= RESET_COLOR
	set_overlays(list(I))

/obj/item/fuel_assembly/Process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		SSradiation.radiate(src, max(1,ceil(radioactivity/15)))

/obj/item/fuel_assembly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Mapper shorthand.
/obj/item/fuel_assembly/deuterium
	material_composition = list(/decl/material/gas/hydrogen/deuterium = MATTER_AMOUNT_PRIMARY)

/obj/item/fuel_assembly/tritium
	material_composition = list(/decl/material/gas/hydrogen/tritium = MATTER_AMOUNT_PRIMARY)

/obj/item/fuel_assembly/supermatter
	material_composition = list(/decl/material/solid/exotic_matter = MATTER_AMOUNT_PRIMARY)

/obj/item/fuel_assembly/hydrogen
	material_composition = list(/decl/material/gas/hydrogen = MATTER_AMOUNT_PRIMARY)
