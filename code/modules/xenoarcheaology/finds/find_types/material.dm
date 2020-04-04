//Material stacks
/decl/archaeological_find/material
	item_type = "material lump"
	modification_flags = XENOFIND_APPLY_PREFIX
	var/list/possible_materials = list(MAT_STEEL, MAT_PLASTEEL, MAT_TITANIUM, MAT_GLASS)

/decl/archaeological_find/material/spawn_item(atom/loc)
	var/mat_to_spawn = pickweight(possible_materials)
	var/material/M = SSmaterials.materials_by_name[mat_to_spawn]
	var/obj/item/stack/material/new_item = new M.stack_type(loc)
	new_item.amount = rand(5,45)
	return new_item

/decl/archaeological_find/material/exotic
	item_type = "rare material lump"
	possible_materials = list(MAT_ALIENALLOY, MAT_PHORON, MAT_METALLIC_HYDROGEN, MAT_PHORON_GLASS)

//Machinery parts
/decl/archaeological_find/parts
	item_type = "machinery part"
	modification_flags = XENOFIND_APPLY_PREFIX 
	responsive_reagent = /datum/reagent/potassium
	possible_types = list()

/decl/archaeological_find/parts/Initialize()
	. = ..()
	for(var/T in subtypesof(/obj/item/stock_parts))
		var/obj/item/stock_parts/P = T
		if(initial(P.part_flags) & PART_FLAG_HAND_REMOVE)
			possible_types += T
