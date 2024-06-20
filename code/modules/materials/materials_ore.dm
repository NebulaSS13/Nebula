#define ORE_MAX_AMOUNT 200
#define ORE_MAX_OVERLAYS 10

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
	material_alteration        = MAT_FLAG_ALTERATION_COLOR //Name is handled in override
	randpixel                  = 6
	is_spawnable_type          = TRUE
	crafting_stack_type        = /obj/item/stack/material/ore
	craft_verb                 = "knap"
	craft_verbing              = "knapping"
	can_be_pulverized          = TRUE
	matter_multiplier          = 1.5

	///Associative list of cache key to the generate icons for the ore piles. We pre-generate a pile of all possible ore icon states, and make them available
	var/static/list/cached_ore_icon_states
	///A list of all the existing ore icon states in the ore file
	var/static/list/ore_icon_states = icon_states('icons/obj/materials/ore.dmi')

/obj/item/stack/material/ore/get_stack_conversion_dictionary()
	var/static/list/converts_into = list(
		TOOL_HAMMER = /obj/item/stack/material/brick
	)
	return converts_into

///Returns a cached ore pile icon state
/obj/item/stack/material/ore/proc/get_cached_ore_pile_overlay(var/state_name, var/stack_icon_index)
	if(!cached_ore_icon_states)
		cache_ore_pile_icons()
	var/nb_icon_states = length(cached_ore_icon_states[state_name])
	if(nb_icon_states <= 0)
		CRASH("Ore pile is missing an icon state!")
	stack_icon_index = clamp(stack_icon_index, 1, nb_icon_states)
	return cached_ore_icon_states[state_name][stack_icon_index]

///Caches the icon state of the ore piles for each possible icon states. The images are greyscale so their color can be changed by the individual materials.
/obj/item/stack/material/ore/proc/cache_ore_pile_icons()
	//#TODO: Replace with pre-made icons. This is more or less a placeholder.
	cached_ore_icon_states = list()
	for(var/IS in ore_icon_states)
		var/list/states = list(null) //First index is null since we're creating overlays
		var/image/scrapboard = image(null)
		//Generate base image
		for(var/i = 2 to ORE_MAX_OVERLAYS)
			//Randomize the orientation and position of each ores in the image
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-6, 6))
			M.Turn(pick(-72, -58, -45, -27.-5, 0, 0, 0, 0, 0, 27.5, 45, 58, 72))
			var/image/oreoverlay = image('icons/obj/materials/ore.dmi', IS)
			oreoverlay.transform = M
			scrapboard.overlays += oreoverlay

		//Generate all indices from generated overlays
		for(var/i = length(scrapboard.overlays), i > 1, i--)
			var/image/copy = new(scrapboard)
			copy.overlays.Cut(1, i)
			states += copy

		//inseert full state last
		states += scrapboard
		cached_ore_icon_states[IS] = states

/obj/item/stack/material/ore/update_state_from_amount()
	if(amount > 1)
		add_overlay(get_cached_ore_pile_overlay(icon_state, amount))
//#TODO: Ideally, since ore piles contain a lot of ores for performances reasons,
// it might be a good idea to scale the item size dynamically. But currently containers and inventories do not support that.
// 	if(amount >= (max_amount * 0.75))
// 		w_class = ITEM_SIZE_HUGE
// 	else if(amount >= (max_amount * 0.5))
// 		w_class = ITEM_SIZE_LARGE
// 	else if(amount >= (max_amount * 0.25))
// 		w_class = ITEM_SIZE_NORMAL
// 	else
// 		w_class = ITEM_SIZE_SMALL

/obj/item/stack/material/ore/set_material(var/new_material)
	. = ..()
	if(istype(material))
		LAZYSET(matter, material.type, SHEET_MATERIAL_AMOUNT)
		icon_state = material.ore_icon_overlay ? material.ore_icon_overlay : initial(icon_state)
		if(icon_state == "dust")
			slot_flags = SLOT_HOLSTER
		queue_icon_update()

/obj/item/stack/material/ore/update_strings()
	. = ..()
	SetName("[(material.ore_name ? material.ore_name : "[material.name] chunk")][(amount > 1? " pile" : "")]")
	desc = material.ore_desc ? material.ore_desc : "A lump of ore."

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
		var/mob/living/human/H = hit_atom
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
/obj/item/stack/material/ore/galena
	material = /decl/material/solid/galena
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
/obj/item/stack/material/ore/meat
	material = /decl/material/solid/organic/meat

/obj/item/stack/material/ore/handful
	singular_name         = "handful"
	plural_name           = "handfuls"
	stack_merge_type      = /obj/item/stack/material/ore/handful
	matter_multiplier     = 1
	can_be_pulverized     = FALSE

// Override as it doesn't make much sense to squash sand.
/obj/item/stack/material/ore/handful/squash_item(skip_qdel = FALSE)
	return

/obj/item/stack/material/ore/handful/get_stack_conversion_dictionary()
	return

/obj/item/stack/material/ore/handful/sand
	material      = /decl/material/solid/sand

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
			var/drop_type = mat.ore_type || /obj/item/stack/material/ore
			new drop_type(T, mat.ore_result_amount, mtype)

#undef ORE_MAX_AMOUNT
#undef ORE_MAX_OVERLAYS