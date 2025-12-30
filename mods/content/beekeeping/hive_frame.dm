/obj/item/hive_frame
	abstract_type = /obj/item/hive_frame
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material_alteration = MAT_FLAG_ALTERATION_ALL
	chem_volume = 20
	var/destroy_on_centrifuge = FALSE

/obj/item/hive_frame/on_reagent_change()
	. = ..()
	if(REAGENT_TOTAL_VOLUME(reagents))
		SetName("filled [initial(name)] ([reagents.get_primary_reagent_name()])")
	else
		SetName(initial(name))
	queue_icon_update()

/obj/item/hive_frame/on_update_icon()
	. = ..()
	var/mesh_state = "[icon_state]-mesh"
	if(check_state_in_icon(mesh_state, icon))
		add_overlay(overlay_image(icon, mesh_state, COLOR_WHITE, RESET_COLOR))
	if(REAGENT_TOTAL_VOLUME(reagents))
		var/comb_state = "[icon_state]-comb"
		if(check_state_in_icon(comb_state, icon))
			add_overlay(overlay_image(icon, comb_state, reagents.get_color(), RESET_COLOR))
	compile_overlays()

/obj/item/hive_frame/handle_centrifuge_process(obj/machinery/centrifuge/centrifuge)
	if(!(. = ..()))
		return
	if(REAGENT_TOTAL_VOLUME(reagents))
		reagents.trans_to_holder(centrifuge.loaded_beaker.reagents, REAGENT_TOTAL_VOLUME(reagents))
	for(var/obj/item/thing in contents)
		thing.dropInto(centrifuge.loc)
	if(destroy_on_centrifuge)
		for(var/atom/movable/thing in convert_matter_to_lumps())
			thing.dropInto(centrifuge.loc)

// Crafted frame used in apiaries.
/obj/item/hive_frame/crafted
	name = "hive frame"
	desc = "A wooden frame for insect hives that the workers will fill with products like honey."
	icon = 'mods/content/beekeeping/icons/frame.dmi'
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL

// TEMP until beewrite redoes hives.
/obj/item/hive_frame/crafted/filled/Initialize()
	. = ..()
	new /obj/item/stack/material/bar/wax(src)
	update_icon()

/obj/item/hive_frame/crafted/filled/populate_reagents()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/honey, REAGENT_MAXIMUM_VOLUME(reagents))
