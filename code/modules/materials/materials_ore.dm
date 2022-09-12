#define ORE_MAX_AMOUNT 200

/obj/item/stack/material/ore
	name                       = "ore pile"
	singular_name              = "ore"
	plural_name                = "ores"
	icon_state                 = "lump"
	plural_icon_state          = null
	max_icon_state             = null
	icon                       = 'icons/obj/materials/ore.dmi'
	w_class                    = ITEM_SIZE_SMALL
	max_amount                 = ORE_MAX_AMOUNT
	material                   = /decl/material/solid/stone/granite //By default is just a rock
	material_health_multiplier = 0.5
	stack_merge_type           = /obj/item/stack/material/ore
	randpixel                  = 8
	///Associative list of cache key to the generate icons for the ore piles. We pre-generate a pile of all possible ore icon states, and make them available
	var/static/list/cached_ore_icon_states
	///A list of all the existing ore icon states in the ore file
	var/static/list/ore_icon_states = list("shiny", "gems", "dust", "nugget", "lump")

///Caches the icon state of the ore piles for each possible icon states. The images are greyscale so their color can be changed by the individual materials.
/obj/item/stack/material/ore/proc/cache_ore_pile_icons()
	cached_ore_icon_states = list()
	for(var/IS in ore_icon_states)
		var/list/states = list()
		//Generate an icon state of the first 10 ores in the pile, any extra ore won't show on the pile
		for(var/i = 1 to 9)
			var/image/oreimage = image('icons/obj/materials/ore.dmi', IS)
			for(var/j = 1 to i)
				//Randomize the orientation and position of each ores in the image
				var/matrix/M = matrix()
				M.Translate(rand(-7, 7), rand(-8, 8))
				M.Turn(pick(-58, -45, -27.-5, 0, 0, 0, 0, 0, 27.5, 45, 58))
				var/image/oreoverlay = image('icons/obj/materials/ore.dmi', IS)
				oreoverlay.transform = M
				oreimage.overlays += oreoverlay
			states += oreimage
		
		cached_ore_icon_states[IS] = states
	log_debug("Generated ore pile cached icons!") //#REMOVEME

/obj/item/stack/material/ore/update_state_from_amount()
	if(!cached_ore_icon_states)
		cache_ore_pile_icons()
	var/nb_icon_states = length(cached_ore_icon_states[icon_state])
	if(!nb_icon_states)
		CRASH("Ore pile is missing an icon state!")
	var/icon_state_index = between(1, amount, 10)
	log_debug("Setting cached icon state '[icon_state]', length: [nb_icon_states], index: [icon_state_index].") //#REMOVEME
	icon = cached_ore_icon_states[icon_state][icon_state_index]

/obj/item/stack/material/ore/set_material(var/new_material)
	. = ..()
	if(istype(material))
		LAZYSET(matter, material.type, SHEET_MATERIAL_AMOUNT)
		name       = "[(amount > 1? "a pile of" : "a")] [(material.ore_name ? material.ore_name : "[material.name] chunk")]"
		desc       = material.ore_desc ? material.ore_desc : "A lump of ore."
		color      = material.color
		icon_state = material.ore_icon_overlay ? material.ore_icon_overlay : initial(icon_state)
		if(icon_state == "dust")
			slot_flags = SLOT_HOLSTER

/obj/item/stack/material/ore/get_recipes()
	return //Can't use recipes with ore

//#TODO: Ideally, since ore piles contain a lot of ores for performances reasons,
// it might be a good idea to scale the item size dynamically. But currently containers and inventories do not support that.
// /obj/item/stack/material/ore/update_state_from_amount()
// 	. = ..()
// 	if(amount >= (max_amount * 0.75))
// 		w_class = ITEM_SIZE_HUGE
// 	else if(amount >= (max_amount * 0.5))
// 		w_class = ITEM_SIZE_LARGE
// 	else if(amount >= (max_amount * 0.25))
// 		w_class = ITEM_SIZE_NORMAL
// 	else
// 		w_class = ITEM_SIZE_SMALL

/obj/item/stack/material/ore/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stack/material) && !is_same(W))
		return FALSE //Don't reinforce

	if(reinf_material && reinf_material.default_solid_form && IS_WELDER(W))
		return FALSE //Don't melt stuff with welder
	return ..()

/// POCKET SAND!
/obj/item/stack/material/ore/throw_impact(atom/hit_atom)
	. = ..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.check_has_eyes() && prob(85))
			to_chat(H, SPAN_DANGER("Some of \the [src] gets in your eyes!"))
			ADJ_STATUS(H, STAT_BLIND, 5)
			ADJ_STATUS(H, STAT_BLURRY, 10)
			QDEL_IN(src, 1)

// Map definitions.
/obj/item/stack/material/ore/uranium
	material = /decl/material/solid/pitchblende
/obj/item/stack/material/ore/iron
	material = /decl/material/solid/hematite
/obj/item/stack/material/ore/coal
	material = /decl/material/solid/graphite
/obj/item/stack/material/ore/glass
	material = /decl/material/solid/sand
/obj/item/stack/material/ore/silver
	material = /decl/material/solid/metal/silver
/obj/item/stack/material/ore/gold
	material = /decl/material/solid/metal/gold
/obj/item/stack/material/ore/diamond
	material = /decl/material/solid/gemstone/diamond
/obj/item/stack/material/ore/osmium
	material = /decl/material/solid/metal/platinum
/obj/item/stack/material/ore/hydrogen
	material = /decl/material/solid/metallic_hydrogen
/obj/item/stack/material/ore/slag
	material = /decl/material/solid/slag
/obj/item/stack/material/ore/phosphorite
	material = /decl/material/solid/phosphorite
/obj/item/stack/material/ore/aluminium
	material = /decl/material/solid/bauxite
/obj/item/stack/material/ore/rutile
	material = /decl/material/solid/rutile
/obj/item/stack/material/ore/hydrogen_hydrate
	material = /decl/material/solid/ice/hydrogen // todo: set back to hydrate when clathrate is added to hydrogen hydrate dname
/obj/item/stack/material/ore/methane
	material = /decl/material/solid/ice/hydrate/methane
/obj/item/stack/material/ore/oxygen
	material = /decl/material/solid/ice/hydrate/oxygen
/obj/item/stack/material/ore/nitrogen
	material = /decl/material/solid/ice/hydrate/nitrogen
/obj/item/stack/material/ore/carbon_dioxide
	material = /decl/material/solid/ice/hydrate/carbon_dioxide
/obj/item/stack/material/ore/argon
	material = /decl/material/solid/ice/hydrate/argon
/obj/item/stack/material/ore/neon
	material = /decl/material/solid/ice/hydrate/neon
/obj/item/stack/material/ore/krypton
	material = /decl/material/solid/ice/hydrate/krypton
/obj/item/stack/material/ore/xenon
	material = /decl/material/solid/ice/hydrate/xenon

/client/proc/spawn_ore_pile()
	set name = "Spawn Ore Pile"
	set category = "Debug"
	set src = usr

	if(!check_rights(R_SPAWN))
		return

	var/turf/T = get_turf(usr)
	if(!istype(T))
		return

	var/list/all_materials = decls_repository.get_decls_of_subtype(/decl/material)
	for(var/mtype in all_materials)
		var/decl/material/mat = all_materials[mtype]
		if(mat.ore_result_amount)
			new /obj/item/stack/material/ore(T, mat.ore_result_amount, mtype)

#undef ORE_MAX_AMOUNT
