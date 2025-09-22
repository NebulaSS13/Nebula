/obj/item/hive_frame
	abstract_type       = /obj/item/hive_frame
	icon_state          = ICON_STATE_WORLD
	w_class             = ITEM_SIZE_SMALL
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

/obj/item/hive_frame/honey/populate_reagents()
	. = ..()
	var/decl/insect_species/bees = GET_DECL(/decl/insect_species/honeybees)
	bees.fill_hive_frame(src)

/obj/item/hive_frame/forceMove(atom/dest)
	var/atom/old_loc = loc
	. = ..()
	if(. && istype(old_loc))
		check_hive_loc(old_loc)

/obj/item/hive_frame/Move()
	var/atom/old_loc = loc
	. = ..()
	if(. && istype(old_loc))
		check_hive_loc(old_loc)

/obj/item/hive_frame/proc/check_hive_loc(atom/check_loc)
	var/datum/extension/insect_hive/hive = get_extension(check_loc, /datum/extension/insect_hive)
	if(istype(hive) && loc != hive.holder)
		hive.frame_removed(src)

// Crafted frame used in apiaries.
/obj/item/hive_frame/crafted
	name = "hive frame"
	desc = "A wooden frame for insect hives that the workers will fill with products like honey."
	icon = 'mods/content/beekeeping/icons/frame.dmi'
	material = /decl/material/solid/organic/wood/oak

// Raw version of honeycomb for wild hives.
/obj/item/hive_frame/comb
	name = "comb"
	icon = 'mods/content/beekeeping/icons/comb.dmi'
	material = /decl/material/solid/organic/wax
	destroy_on_centrifuge = TRUE
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	is_spawnable_type = FALSE
	w_class = ITEM_SIZE_NORMAL // Larger than crafted frames, because you should use crafted frames in your hive.

/obj/item/hive_frame/comb/Initialize(ml, material_key, decl/insect_species/spawning_hive)
	. = ..()
	if(istype(spawning_hive))
		SetName(spawning_hive.native_frame_name)
		desc = spawning_hive.native_frame_desc
		spawning_hive.fill_hive_frame(src)

// Comb subtype for mapping and debugging.
/obj/item/hive_frame/comb/honey
	is_spawnable_type = TRUE
	color = COLOR_GOLD

/obj/item/hive_frame/comb/honey/Initialize(ml, material_key)
	return ..(ml, material_key, GET_DECL(/decl/insect_species/honeybees))
