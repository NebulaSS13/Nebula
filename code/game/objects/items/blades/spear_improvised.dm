/obj/item/bladed/polearm/spear/improvised
	material       = /decl/material/solid/glass
	hilt_material  = /decl/material/solid/metal/steel
	guard_material = /decl/material/solid/metal/copper
	var/force_binding_color

/obj/item/bladed/polearm/spear/improvised/Initialize(ml, material_key, _hilt_mat, _guard_mat, _binding_color)
	if(_binding_color)
		force_binding_color = _binding_color
	if(!force_binding_color)
		force_binding_color = pick(global.cable_colors)
	. = ..(ml, material_key, _hilt_mat, _guard_mat)

/obj/item/bladed/polearm/spear/improvised/update_name()
	. = ..()
	SetName("improvised [name]")

/obj/item/bladed/polearm/spear/improvised/get_guard_color()
	return force_binding_color || ..()

/obj/item/bladed/polearm/spear/improvised/shatter(var/consumed)
	if(!consumed)
		if(istype(hilt_material))
			SSmaterials.create_object(hilt_material, get_turf(src), 1, /obj/item/stack/material/rods)
		if(istype(guard_material))
			new /obj/item/stack/cable_coil(get_turf(src), 3, cable_color)
	..()

// Subtypes for mapping/spawning
/obj/item/bladed/polearm/spear/improvised/diamond
	material = /decl/material/solid/gemstone/diamond
	hilt_material = /decl/material/solid/metal/gold
	force_binding_color = COLOR_PURPLE

/obj/item/bladed/polearm/spear/improvised/steel
	material = /decl/material/solid/metal/steel
	hilt_material = /decl/material/solid/organic/wood
	force_binding_color = COLOR_GREEN

/obj/item/bladed/polearm/spear/improvised/supermatter
	material = /decl/material/solid/exotic_matter
	hilt_material = /decl/material/solid/organic/wood/ebony
	force_binding_color = COLOR_INDIGO
