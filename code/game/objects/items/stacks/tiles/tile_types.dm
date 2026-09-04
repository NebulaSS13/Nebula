/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Linoleum
 *		Carpet
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A nondescript floor tile."
	randpixel = 7
	w_class = ITEM_SIZE_NORMAL
	max_amount = 100
	icon = 'icons/obj/tiles.dmi'
	matter_multiplier = 0.2
	throw_speed = 5
	throw_range = 20
	item_flags = 0
	obj_flags = 0
	_base_attack_force = 1
	var/replacement_turf_type = /turf/floor/plating

/obj/item/stack/tile/proc/try_build_turf(var/mob/user, var/turf/target)

	if(!target.is_plating())
		return FALSE

	var/ladder = (locate(/obj/structure/ladder) in target)
	if(ladder)
		to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
		return FALSE

	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, target)
	if(!lattice && target.is_open())
		to_chat(user, SPAN_WARNING("The tiles need some support, build a lattice first."))
		return FALSE

	if(use(1))
		playsound(target, 'sound/weapons/Genhit.ogg', 50, 1)
		target.ChangeTurf(replacement_turf_type, keep_air = TRUE)
		qdel(lattice)
		return TRUE
	return FALSE

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	origin_tech = @'{"biotech":1}'

/obj/item/stack/tile/woven
	name = "woven tile"
	singular_name = "woven floor tile"
	desc = "A piece of woven material suitable for covering the floor."
	icon_state = "woven"
	origin_tech = @'{"biotech":1}'
	material = /decl/material/solid/organic/plantmatter/grass/dry
	color = COLOR_BEIGE
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	replacement_turf_type = /turf/floor/woven

/obj/item/stack/tile/floor
	name = "steel floor tile"
	singular_name = "steel floor tile"
	desc = "Some square sections of flooring. They have a satisfying heft in the hand."
	icon_state = "tile"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	_thrown_force_multiplier = 1 // floor tiles were always good throwing weapons for no apparent reason
	_base_attack_force = 6

/obj/item/stack/tile/mono
	name = "steel mono tile"
	singular_name = "steel mono tile"
	icon_state = "tile"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/dark
	name = "dark mono tile"
	singular_name = "dark mono tile"
	icon_state = "tile"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/white
	name = "white mono tile"
	singular_name = "white mono tile"
	icon_state = "tile"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/grid
	name = "grey grid tile"
	singular_name = "grey grid tile"
	icon_state = "tile_grid"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/ridge
	name = "grey ridge tile"
	singular_name = "grey ridge tile"
	icon_state = "tile_ridged"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techmaint
	name = "dark techfloor tile"
	singular_name = "dark techfloor tile"
	icon_state = "techtile_maint"
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/floor_white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	material = /decl/material/solid/organic/plastic

/obj/item/stack/tile/floor_white/fifty
	amount = 50

/obj/item/stack/tile/floor_dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "fr_tile"
	material = /decl/material/solid/metal/plasteel

/obj/item/stack/tile/floor_dark/fifty
	amount = 50

/obj/item/stack/tile/floor_freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	material = /decl/material/solid/organic/plastic

/obj/item/stack/tile/floor_freezer/fifty
	amount = 50

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stack_merge_type = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor
	max_health = ITEM_HEALTH_NO_DAMAGE
	is_spawnable_type = FALSE

/obj/item/stack/tile/roof/cyborg
	name = "roofing tile synthesizer"
	desc = "A device that makes roofing tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	stack_merge_type = /obj/item/stack/tile/roof
	build_type = /obj/item/stack/tile/roof
	max_health = ITEM_HEALTH_NO_DAMAGE
	is_spawnable_type = FALSE

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile_linoleum"

/obj/item/stack/tile/linoleum/fifty
	amount = 50

/obj/item/stack/tile/stone
	name = "stone slabs"
	singular_name = "stone slab"
	desc = "A smooth, flat slab of some kind of stone."
	icon_state = "tile_stone"

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	build_type = /obj/item/stack/tile/carpet
	name = "brown carpet"
	singular_name = "brown carpet"
	desc = "A piece of brown carpet."
	icon_state = "tile_carpet"
	material = /decl/material/solid/organic/cloth
	paint_color = "#6e391d"
	var/detail_color = "#aa6300"

/obj/item/stack/tile/carpet/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/tile/carpet/on_update_icon()
	. = ..()
	if(detail_color)
		add_overlay(overlay_image(icon, "[icon_state]_detail", detail_color, RESET_COLOR))

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue
	build_type = /obj/item/stack/tile/carpet/blue
	name = "blue carpet"
	desc = "A piece of blue and gold carpet."
	singular_name = "blue carpet"
	paint_color = "#464858"

/obj/item/stack/tile/carpet/blue/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue2
	build_type = /obj/item/stack/tile/carpet/blue2
	name = "pale blue carpet"
	desc = "A piece of blue and pale blue carpet."
	singular_name = "pale blue carpet"
	paint_color = "#356287"
	detail_color = "#868e96"

/obj/item/stack/tile/carpet/blue2/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue3
	build_type = /obj/item/stack/tile/carpet/blue3
	name = "sea blue carpet"
	desc = "A piece of blue and green carpet."
	singular_name = "sea blue carpet"
	detail_color = "#528c3c"
	paint_color = "#356287"

/obj/item/stack/tile/carpet/blue3/fifty
	amount = 50

/obj/item/stack/tile/carpet/magenta
	build_type = /obj/item/stack/tile/carpet/magenta
	name = "magenta carpet"
	desc = "A piece of magenta carpet."
	singular_name = "magenta carpet"
	paint_color = "#91265e"
	detail_color = "#be6208"

/obj/item/stack/tile/carpet/magenta/fifty
	amount = 50

/obj/item/stack/tile/carpet/purple
	build_type = /obj/item/stack/tile/carpet/purple
	name = "purple carpet"
	desc = "A piece of purple carpet."
	singular_name = "purple carpet"
	paint_color = "#4f3365"
	detail_color = "#a25204"

/obj/item/stack/tile/carpet/purple/fifty
	amount = 50

/obj/item/stack/tile/carpet/orange
	build_type = /obj/item/stack/tile/carpet/orange
	name = "orange carpet"
	desc = "A piece of orange carpet."
	singular_name = "orange carpet"
	paint_color = "#9d480c"
	detail_color = "#d07708"

/obj/item/stack/tile/carpet/orange/fifty
	amount = 50

/obj/item/stack/tile/carpet/green
	build_type = /obj/item/stack/tile/carpet/green
	name = "green carpet"
	desc = "A piece of green carpet."
	singular_name = "green carpet"
	paint_color = "#2a6e47"
	detail_color = "#328e63"

/obj/item/stack/tile/carpet/green/fifty
	amount = 50

/obj/item/stack/tile/carpet/red
	name = "red carpet"
	desc = "A piece of red carpet."
	singular_name = "red carpet"
	paint_color = "#873221"
	detail_color = "#aa6300"

/obj/item/stack/tile/carpet/red/fifty
	amount = 50

/obj/item/stack/tile/carpet/rustic
	build_type = /obj/item/stack/tile/carpet/rustic
	name = "rustic carpet"
	desc = "A piece of simple, rustic carpeting."
	singular_name = "rustic carpet"
	paint_color = COLOR_CHESTNUT
	detail_color = null

/obj/item/stack/tile/pool
	name = "pool tiling"
	desc = "A set of tiles designed to build fluid pools."
	singular_name = "pool tile"
	icon_state = "tile_pool"
	material = /decl/material/solid/metal/steel

// Roofing tiles; not quite the same behavior here.
/obj/item/stack/tile/roof
	name = "roofing tile"
	singular_name = "roofing tile"
	desc = "A nondescript roofing tile."
	matter_multiplier = 0.3
	icon_state = "tile"
	material = /decl/material/solid/metal/steel

/obj/item/stack/tile/roof/woven
	name = "woven roofing tile"
	desc = "A flimsy, woven roofing tile."
	icon_state = "woven"
	material = /decl/material/solid/organic/plantmatter/grass/dry
	replacement_turf_type = /turf/floor/woven
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/stack/tile/roof/try_build_turf(var/mob/user, var/turf/target)

	// No point roofing a tile that is set explicitly to be roofed.
	if(target.is_outside == OUTSIDE_NO)
		to_chat(user, SPAN_WARNING("\The [target] is already roofed."))
		return FALSE

	// We need either a wall on our level, or a non-open turf one level up, to support the roof.
	var/has_support = FALSE
	for(var/checkdir in global.cardinal)
		var/turf/T = get_step(target, checkdir)
		if(!T)
			continue
		if(T.density || T.is_outside == OUTSIDE_NO) // Explicit check for roofed turfs
			has_support = TRUE
			break
		if(HasAbove(T.z))
			var/turf/above = GetAbove(T)
			if(!above.is_open())
				has_support = TRUE
				break
	if(!has_support)
		to_chat(user, SPAN_WARNING("You need either an adjacent wall below, or an adjacent roof tile above, to build a new roof section."))
		return FALSE

	// Multiz needs a turf spawned above, while single-level does not.
	var/turf/replace_turf
	if(HasAbove(target.z))
		replace_turf = GetAbove(target)
		if(!replace_turf.is_open())
			to_chat(user, SPAN_WARNING("\The [target] is already roofed."))
			return FALSE

	if(!use(1))
		return FALSE

	playsound(target, 'sound/weapons/Genhit.ogg', 50, 1)
	if(replace_turf)
		replace_turf.ChangeTurf(replacement_turf_type, keep_air = TRUE)
	target.set_outside(OUTSIDE_NO)
	to_chat(user, SPAN_NOTICE("You put up a roof over \the [target]."))
	return TRUE
