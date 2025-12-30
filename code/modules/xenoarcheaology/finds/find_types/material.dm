//Material stacks
/decl/archaeological_find/material
	item_type = "material lump"
	modification_flags = XENOFIND_APPLY_PREFIX
	var/list/possible_materials = list(
		/decl/material/solid/metal/steel,
		/decl/material/solid/metal/plasteel,
		/decl/material/solid/metal/titanium,
		/decl/material/solid/glass
	)

/decl/archaeological_find/material/spawn_item(atom/loc)
	return SSmaterials.create_object(pick(possible_materials), loc, rand(5,45))?[1]

/decl/archaeological_find/material/exotic
	item_type = "rare material lump"
	possible_materials = list(
		/decl/material/solid/metal/aliumium,
		/decl/material/solid/metallic_hydrogen,
		/decl/material/solid/glass/borosilicate
	)

//Machinery parts
/decl/archaeological_find/parts
	item_type = "machinery part"
	modification_flags = XENOFIND_APPLY_PREFIX
	responsive_reagent = /decl/material/solid/potassium
	possible_types = list()

/decl/archaeological_find/parts/Initialize()
	. = ..()
	for(var/T in subtypesof(/obj/item/stock_parts))
		var/obj/item/stock_parts/P = T
		if(initial(P.part_flags) & PART_FLAG_HAND_REMOVE)
			possible_types += T
