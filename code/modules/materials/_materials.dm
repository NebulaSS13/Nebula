/obj/effect/gas_overlay
	name = "gas"
	desc = "You shouldn't be clicking this."
	icon = 'icons/effects/tile_effects.dmi'
	icon_state = "generic"
	layer = FIRE_LAYER
	appearance_flags = RESET_COLOR
	mouse_opacity = 0
	var/decl/material/material

/obj/effect/gas_overlay/proc/update_alpha_animation(var/new_alpha)
	animate(src, alpha = new_alpha)
	alpha = new_alpha
	animate(src, alpha = 0.8 * new_alpha, time = 10, easing = SINE_EASING | EASE_OUT, loop = -1)
	animate(alpha = new_alpha, time = 10, easing = SINE_EASING | EASE_IN, loop = -1)

/obj/effect/gas_overlay/Initialize(mapload, gas)
	. = ..()
	material = decls_repository.get_decl(gas)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(material.gas_tile_overlay)
		icon_state = material.gas_tile_overlay
	color = material.icon_colour

/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation.

	PATHS THAT USE DATUMS
		turf/simulated/wall
		obj/item
		obj/structure/barricade
		obj/structure/table

	VALID ICONS
		WALLS
			stone
			metal
			solid
			cult
		DOORS
			stone
			metal
			resin
			wood
*/

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return

//mostly for convenience
/obj/proc/get_material_type()
	var/decl/material/mat = get_material()
	. = mat && mat.type

// Material definition and procs follow.
/decl/material
	var/name                              // Prettier name for display.
	var/adjective_name
	var/solid_name
	var/liquid_name
	var/gas_name
	var/use_name
	var/wall_name = "wall"                // Name given to walls of this material
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel
	var/hidden_from_codex
	var/lore_text = "A nondescript material."
	var/mechanics_text
	var/antag_text

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this material.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.
	var/foam_state = "foam"

	// Icons
	var/icon_colour = COLOR_WHITE                        // Colour applied to products of this material.
	var/icon_colour_weight = 1                           // Weighting of colour in substance mixes.
	var/icon_base = "metal"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/icon_reinf = "reinf_metal"                       // Overlay used
	var/table_icon_base = "metal"
	var/table_reinf = "reinf_metal"
	var/list/stack_origin_tech = "{'materials':1}" // Research level for stacks.

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation var. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the material catches on fire.
	var/brute_armor = 2	 		 // Brute damage to a wall is divided by this value if the wall is reinforced by this material.
	var/burn_armor				 // Same as above, but for Burn damage type. If blank brute_armor's value is used.
	var/integrity = 150          // General-use HP value for products.
	var/opacity = 1              // Is the material transparent? 0.5< makes transparent walls/doors.
	var/explosion_resistance = 5 // Only used by walls currently.
	var/conductive = 1           // Objects with this var add CONDUCTS to flags on spawn.
	var/luminescence
	var/list/alloy_materials     // If set, material can be produced via alloying these materials in these amounts.
	var/wall_support_value = 30
	var/pH = 7                   // Neutral pH by default. Determines acid burns.

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = MAT_VALUE_HARD            // Prob of wall destruction by hulk, used for edge damage in weapons.
	var/reflectiveness = MAT_VALUE_DULL

	var/weight = MAT_VALUE_NORMAL             // Determines blunt damage/throwforce for weapons.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Noise made when you hit structure made of this material.
	var/hitsound = 'sound/weapons/genhit.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type = /obj/item/stack/material/generic
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"
	// Modifies skill checks when constructing with this material.
	var/construction_difficulty = MAT_VALUE_EASY_DIY
	// Determines what is used to remove or dismantle this material.
	var/removed_by_welder

	// Mining behavior.
	var/alloy_product
	var/ore_name
	var/ore_desc
	var/ore_smelts_to
	var/ore_compresses_to
	var/ore_result_amount
	var/ore_spread_chance
	var/ore_scan_icon
	var/ore_icon_overlay
	var/ore_icon_colour
	var/sale_price
	var/value = 1

	// State transition variables.
	var/melting_point = 1800     // K, walls will take damage if they're next to a fire hotter than this
	var/boiling_point = INFINITY // K, gasses will condense below this point.

	// Gas behavior.
	var/gas_overlay_limit
	var/gas_burn_product =  MAT_CO2 // todo make realistic
	var/gas_specific_heat = 20    // J/(mol*K)
	var/gas_molar_mass =    0.032 // kg/mol
	var/gas_tile_overlay =  "generic"
	var/gas_flags = 0
	var/gas_symbol_html
	var/gas_symbol

	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	// Matter state data.
	var/chilling_point
	var/chilling_message = "crackles and freezes!"
	var/chilling_sound = 'sound/effects/bubbles.ogg'
	var/list/chilling_products
	var/list/heating_products
	var/heating_point
	var/heating_message = "begins to boil!"
	var/heating_sound = 'sound/effects/bubbles.ogg'
	var/fuel_value = 0
	var/temperature_multiplier = 1
	var/scent //refer to _scent.dm
	var/scent_intensity = /decl/scent_intensity/normal
	var/scent_descriptor = SCENT_DESC_SMELL
	var/scent_range = 1

// Placeholders for light tiles and rglass.
/decl/material/proc/reinforce(var/mob/user, var/obj/item/stack/material/used_stack, var/obj/item/stack/material/target_stack)
	if(!used_stack.can_use(1))
		to_chat(user, "<span class='warning'>You need need at least one [used_stack.singular_name] to reinforce [target_stack].</span>")
		return

	var/needed_sheets = 2 * used_stack.matter_multiplier
	if(!target_stack.can_use(needed_sheets))
		to_chat(user, "<span class='warning'>You need need at least [needed_sheets] [target_stack.plural_name] for reinforcement with [used_stack].</span>")
		return

	var/decl/material/reinf_mat = used_stack.material
	if(reinf_mat.integrity <= integrity || reinf_mat.is_brittle())
		to_chat(user, "<span class='warning'>The [reinf_mat.name] is too structurally weak to reinforce the [name].</span>")
		return

	to_chat(user, "<span class='notice'>You reinforce the [target_stack] with the [reinf_mat.name].</span>")
	used_stack.use(1)
	var/obj/item/stack/material/S = target_stack.split(needed_sheets)
	S.reinf_material = reinf_mat
	S.update_strings()
	S.update_icon()
	S.dropInto(target_stack.loc)

/decl/material/proc/build_wired_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]."))	
		return
	if(!used_stack.can_use(5) || !target_stack.can_use(1))
		to_chat(user, SPAN_WARNING("You need five wires and one sheet of [name] to make anything useful."))
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, SPAN_NOTICE("You attach wire to the [name]."))
	var/obj/item/product = new wire_product(get_turf(user))
	if(!(user.l_hand && user.r_hand))
		user.put_in_hands(product)

// Make sure we have a use name and shard icon even if they aren't explicitly set.
/decl/material/New()
	..()
	if(!use_name)
		use_name = name

	if(!solid_name)
		if(melting_point >= T20C && boiling_point >= T100C)
			solid_name = name
		else
			solid_name = "solid [name]"

	if(!liquid_name)
		if(melting_point < T20C)
			liquid_name = name
		else
			liquid_name = "molten [name]"

	if(!gas_name)
		if(boiling_point > T100C)
			gas_name = name
		else
			gas_name = "[name] vapour"

	if(ore_name && !ore_icon_colour)
		ore_icon_colour = icon_colour

	if(!adjective_name)
		adjective_name = name
	if(!shard_icon)
		shard_icon = shard_type
	if(!burn_armor)
		burn_armor = brute_armor

// Return the matter comprising this material.
/decl/material/proc/get_matter()
	var/list/temp_matter = list()
	temp_matter[type] = SHEET_MATERIAL_AMOUNT
	return temp_matter

/decl/material/proc/is_a_gas()
	. = !isnull(gas_specific_heat) && !isnull(gas_molar_mass) // Arbitrary but good enough.

// Weapons handle applying a divisor for this value locally.
/decl/material/proc/get_blunt_damage()
	return weight //todo

// As above.
/decl/material/proc/get_edge_damage()
	return hardness //todo

/decl/material/proc/get_attack_cooldown()
	if(weight <= MAT_VALUE_LIGHT)
		return FAST_WEAPON_COOLDOWN
	if(weight >= MAT_VALUE_HEAVY)
		return SLOW_WEAPON_COOLDOWN
	return DEFAULT_WEAPON_COOLDOWN

// Snowflakey, only checked for alien doors at the moment.
/decl/material/proc/can_open_material_door(var/mob/living/user)
	return 1

// Currently used for weapons and objects made of uranium to irradiate things.
/decl/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls when qdel()ing to avoid neighbor merging.
/decl/material/placeholder
	name = "placeholder"
	hidden_from_codex = TRUE

// Places a girder object when a wall is dismantled, also applies reinforced material.
/decl/material/proc/place_dismantled_girder(var/turf/target, var/decl/material/reinf_material)
	new /obj/structure/girder(target, type, reinf_material && reinf_material.type)

// General wall debris product placement.
// Not particularly necessary aside from snowflakey cult girders.
/decl/material/proc/place_dismantled_product(var/turf/target,var/is_devastated)
	place_sheet(target, is_devastated ? 1 : 2)

// Debris product. Used ALL THE TIME.
/decl/material/proc/place_sheet(var/turf/target, var/amount = 1)
	return stack_type ? new stack_type(target, amount, type) : null

// As above.
/decl/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/material/shard(target, type)

// Used by walls and weapons to determine if they break or not.
/decl/material/proc/is_brittle()
	return !!(flags & MAT_FLAG_BRITTLE)

/decl/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

// Dumb overlay to apply over wall sprite for cheap texture effect
/decl/material/proc/get_wall_texture()
	return