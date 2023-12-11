/obj/item/storage/crucible
	name = "crucible"
	icon = 'icons/obj/metalworking/crucible.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/stone/pottery
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	w_class = ITEM_SIZE_NO_CONTAINER
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_LARGE)

/obj/item/storage/crucible/Initialize()
	. = ..()
	initialize_reagents()

/obj/item/storage/crucible/on_reagent_change()
	. = ..()
	queue_icon_update()

/obj/item/storage/crucible/on_update_icon()
	. = ..()
	var/decl/material/primary_reagent = reagents?.get_primary_reagent_decl()
	if(primary_reagent)
		var/image/I = image(icon, "[icon_state]-filled")
		I.color = primary_reagent.color
		I.alpha = 255 * primary_reagent.opacity
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/storage/crucible/initialize_reagents()
	create_reagents(15 * REAGENT_UNITS_PER_MATERIAL_SHEET)
	return ..()
