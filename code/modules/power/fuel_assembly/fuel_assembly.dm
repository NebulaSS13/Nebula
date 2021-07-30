/obj/item/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"
	layer = 4

	var/material_name
	var/percent_depleted = 1
	var/radioactivity = 0
	var/luminescence = 0
	var/initial_amount

/obj/item/fuel_assembly/Initialize(mapload, var/_material, var/list/makeup, var/_colour)
	. = ..(mapload, _material)
	LAZYINITLIST(matter)
	
	if(makeup)
		if(length(makeup) == 1) // Rod is only made from one material.
			var/decl/material/mat = decls_repository.get_decl(makeup[1])
			SetName("[mat.use_name] fuel rod assembly")
			desc = "A fuel rod for nuclear power production. This one is made from [mat.use_name]."
			material_name = mat.use_name
		else
			desc = "A fuel rod for nuclear power production, made up from various materials."
			material_name = "Mixed material"

		for(var/mat_p in makeup)
			var/decl/material/mat = decls_repository.get_decl(mat_p)
			matter[mat_p] = makeup[mat_p]
			initial_amount += makeup[mat_p]
			radioactivity = max(radioactivity, mat.radioactivity)
			luminescence = max(luminescence, mat.luminescence)
	else
		initial_amount = SHEET_MATERIAL_AMOUNT * 5
		matter[material.type] = initial_amount
		SetName("[material.use_name] fuel rod assembly")
		desc = "A fuel rod for nuclear power production. This one is made from [material.use_name]."
		material_name = material.use_name
		if(material.radioactivity)
			radioactivity = material.radioactivity
		if(material.luminescence)
			luminescence = material.luminescence
	if(luminescence)
		set_light(material.luminescence, material.luminescence, material.color)
	if(radioactivity)
		desc += " It is warm to the touch."
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/fuel_assembly/on_update_icon()
	icon_state = "fuel_assembly"
	if(material)
		color = material.color
	else if(length(matter))
		var/list/colors = list()
		for(var/mat_p in matter)
			var/decl/material/mat = decls_repository.get_decl(mat_p)
			colors += mat.color
		color = MixColors(colors)
	var/image/I = image(icon, "fuel_assembly_bracket")
	I.appearance_flags |= RESET_COLOR
	set_overlays(I)

/obj/item/fuel_assembly/Process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		SSradiation.radiate(src, max(1,CEILING(radioactivity/15)))

/obj/item/fuel_assembly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Mapper shorthand.
/obj/item/fuel_assembly/deuterium
	material = /decl/material/gas/hydrogen/deuterium

/obj/item/fuel_assembly/tritium
	material = /decl/material/gas/hydrogen/tritium
	
/obj/item/fuel_assembly/supermatter
	material = /decl/material/solid/exotic_matter

/obj/item/fuel_assembly/hydrogen
	material = /decl/material/gas/hydrogen

/obj/item/fuel_assembly/uranium
	material = /decl/material/solid/metal/uranium

/obj/item/fuel_assembly/plutonium
	material = /decl/material/solid/metal/plutonium

/obj/item/fuel_assembly/graphite
	material = /decl/material/solid/mineral/graphite

/obj/item/fuel_assembly/boron
	material = /decl/material/solid/boron