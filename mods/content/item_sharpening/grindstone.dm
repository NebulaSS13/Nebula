// TODO: better sound effects for working.
/obj/structure/working/grindstone
	name = "grindstone"
	desc = "A rotating section of coarse stone used to polish and sharpen metalwork like blades."
	icon = 'mods/content/item_sharpening/icons/grindstone.dmi'
	material_alteration = MAT_FLAG_ALTERATION_COLOR // Name and desc handled manually.
	var/decl/material/stone_material = /decl/material/solid/quartz

/obj/structure/working/grindstone/Initialize()
	stone_material = GET_DECL(stone_material)
	. = ..()
	update_material_name()
	update_material_desc()

/obj/structure/working/grindstone/update_material_name(override_name)
	. = ..()
	if(stone_material)
		SetName("[stone_material.adjective_name] [name]")

/obj/structure/working/grindstone/update_material_desc(override_desc)
	. = ..()
	if(stone_material && istype(material))
		desc = "[desc] This one is made from [stone_material.solid_name] with \a [material.adjective_name] frame."

/obj/structure/working/grindstone/on_update_icon()
	. = ..()
	underlays = list(
		overlay_image(icon, "[icon_state]-grindstone", stone_material.color, RESET_COLOR),
		overlay_image(icon, "[initial(icon_state)]-backdrop")
	)

// Slightly wonky override, but this basically intercepts items being used on the grindstone.
/obj/structure/working/grindstone/try_take_input(obj/item/used_item, mob/user, silent)
	if(working)
		if(!silent)
			to_chat(user, SPAN_WARNING("\The [src] is already in use, please wait for it to be free."))
	else
		start_working()
		used_item.try_sharpen_with(user, src)
		if(!QDELETED(src) && working)
			stop_working()
	return TRUE

/obj/structure/working/grindstone/get_sharpening_material()
	RETURN_TYPE(/decl/material)
	return stone_material
