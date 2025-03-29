// New and improved(?) trays. Apologies to Agouri, and Doohl, wherever you may be.
/obj/item/plate/tray
	name                 = "tray"
	desc                 = "A large tray, suitable for serving several servings of food."
	icon                 = 'icons/obj/food/plates/tray.dmi'
	material             = /decl/material/solid/organic/plastic
	w_class              = ITEM_SIZE_NORMAL
	storage              = /datum/storage/tray
	throw_speed          = 1
	throw_range          = 5
	melee_accuracy_bonus = -10
	attack_verb          = list("served","slammed","hit")
	material_alteration  = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	_base_attack_force   = 4
	var/cooldown         = 0 // Cooldown for banging the tray with a rolling pin. based on world.time. very silly
	var/no_drop          = FALSE

// Override this so we can use our storage.
/obj/item/plate/tray/try_plate_food(obj/item/food/food, mob/user)
	return FALSE

/obj/item/plate/tray/resolve_attackby(var/atom/A, mob/user)
	if(A.storage) //Disallow putting in bags without raising w_class. Don't know why though, it was part of the old trays
		to_chat(user, SPAN_WARNING("The tray won't fit in \the [A]."))
		return
	. = ..()

/obj/item/plate/tray/proc/scatter_contents(var/neatly = FALSE, target_loc = get_turf(src))
	set waitfor = FALSE
	if(storage)
		for(var/obj/item/I in storage.get_contents())
			if(storage.remove_from_storage(null, I, target_loc) && !neatly)
				I.throw_at(get_edge_target_turf(I.loc, pick(global.alldirs)), rand(1,3), round(10/I.w_class))
	update_icon()

/obj/item/plate/tray/shatter(consumed)
	scatter_contents()
	. = ..()

/obj/item/plate/tray/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50)) // There is a better way to do this but I'll be damned if I'm the one to fix it.
		to_chat(user, SPAN_DANGER("You accidentally slam yourself with \the [src]!"))
		SET_STATUS_MAX(user, STAT_WEAK, 1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(target, hitsound, 50, 1)
		. = TRUE
	else
		. = ..()
	if(.)
		scatter_contents()

/obj/item/plate/tray/attackby(obj/item/used_item, mob/user, click_params)
	if(istype(used_item, /obj/item/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("\The [user] bashes \the [src] with \the [used_item]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
		return TRUE
	. = ..()
	if (.)
		auto_align(used_item, click_params)

//This proc handles alignment on trays, a la tables.
/obj/item/plate/tray/proc/auto_align(obj/item/aligning, click_params)
	if (!aligning.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		aligning.pixel_x = rand(-aligning.randpixel, aligning.randpixel)
		aligning.pixel_y = rand(-aligning.randpixel, aligning.randpixel)
		aligning.pixel_z = 0
		return

	if (!click_params)
		return

	var/list/click_data = params2list(click_params)
	if (!click_data["icon-x"] || !click_data["icon-y"])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data["icon-x"])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data["icon-y"])-1

	var/cell_x = clamp(round(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = clamp(round(mouse_y/CELLSIZE), 0, CELLS-1)

	var/list/center = cached_json_decode(aligning.center_of_mass)

	aligning.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	aligning.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	aligning.pixel_z = 0

/obj/item/plate/tray/dump_contents(atom/forced_loc = loc, mob/user)
	if(!isturf(forced_loc)) //to handle hand switching
		return FALSE
	if(user && storage)
		storage.close(user)
	if(!(locate(/obj/structure/table) in forced_loc) && contents.len)
		if(user)
			visible_message(SPAN_DANGER("Everything falls off \the [src]! Good job, [user]."))
		scatter_contents(FALSE, forced_loc)
	return ..()

/obj/item/plate/tray/dropped(mob/user)
	. = ..()
	if(!no_drop)
		dump_contents(user = user)

/obj/item/plate/tray/throw_at(atom/target, range, speed, mob/thrower, spin, datum/callback/callback)
	no_drop = TRUE
	. = ..()

/obj/item/plate/tray/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	no_drop = FALSE
	scatter_contents(FALSE, get_turf(hit_atom))

/obj/item/plate/tray/on_update_icon()
	. = ..()
	clear_vis_contents()
	for(var/obj/item/I in contents)
		I.vis_flags |= VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
		I.appearance_flags |= RESET_COLOR
		add_vis_contents(I)

/obj/item/plate/tray/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(.)
		if(contents.len)
			var/tray_examine = list()
			for(var/obj/item/I in contents)
				tray_examine += "\a [I.name]"
			. += "There is [english_list(tray_examine)] on the tray."
		else
			. += "\The [src] is empty."

/*
-----------------------------------------------------------------
TRAY TYPES GO HERE
-----------------------------------------------------------------
 */

/obj/item/plate/tray/cardboard
	desc = "A cardboard tray to serve food on."
	material = /decl/material/solid/organic/cardboard

/obj/item/plate/tray/wood
	desc = "A wooden tray to serve food on."
	material = /decl/material/solid/organic/wood/oak

/obj/item/plate/tray/metal
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	hitsound = "tray_hit" // So metal trays make the fun noise

/obj/item/plate/tray/metal/aluminium
	desc = "An aluminium tray to serve food on."
	material = /decl/material/solid/metal/aluminium

/obj/item/plate/tray/metal/silver
	name = "platter"
	desc = "The new generation is so lazy, they expect everything to be handed to them on this."
	material = /decl/material/solid/metal/silver

/obj/item/plate/tray/metal/gold
	name = "platter"
	desc = "A gold tray to serve food on. Heavy, but oh-so-fancy."
	material = /decl/material/solid/metal/gold