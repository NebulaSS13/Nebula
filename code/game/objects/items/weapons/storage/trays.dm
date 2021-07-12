// New and improved(?) trays. Apologies to Agouri, and Doohl, wherever you may be.

/obj/item/storage/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray_material"
	desc = "A tray to serve food on."
	force = 4
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	melee_accuracy_bonus = -10
	w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE
	attack_verb = list("served","slammed","hit")
	use_to_pickup = 1
	allow_quick_gather = 1
	use_sound = null

	var/cooldown = 0	//Cooldown for banging the tray with a rolling pin. based on world.time. very silly
	var/no_drop = FALSE

	material = /decl/material/solid/cardboard
	applies_material_colour = TRUE
	applies_material_name = TRUE

/obj/item/storage/tray/resolve_attackby(var/atom/A, mob/user)
	if(istype(A, /obj/item/storage)) //Disallow putting in bags without raising w_class. Don't know why though, it was part of the old trays
		to_chat(user, SPAN_WARNING("The tray won't fit in \the [A]."))
		return
	. = ..()

/obj/item/storage/tray/gather_all(var/turf/T, var/mob/user)
	..()
	update_icon()

/obj/item/storage/tray/proc/scatter_contents(var/neatly = FALSE, target_loc = get_turf(src))
	set waitfor = 0
	for(var/obj/item/I in contents)
		if(remove_from_storage(I, target_loc) && !neatly)
			I.throw_at(get_edge_target_turf(I.loc, pick(global.alldirs)), rand(1,3), round(10/I.w_class))
	update_icon()

/obj/item/storage/tray/shatter(consumed)
	scatter_contents()
	. = ..()

/obj/item/storage/tray/attack(mob/living/carbon/M, mob/living/carbon/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50)) // There is a better way to do this but I'll be damned if I'm the one to fix it.
		to_chat(user, SPAN_DANGER("You accidentally slam yourself with the [src]!"))
		SET_STATUS_MAX(user, STAT_WEAK, 1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(M, hitsound, 50, 1)
		. = TRUE
	else
		. = ..()
	if(.)
		scatter_contents()

/obj/item/storage/tray/attackby(obj/item/W, mob/user, click_params)
	if(istype(W, /obj/item/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("\The [user] bashes \the [src] with \the [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
		return TRUE
	. = ..()
	if (.)
		auto_align(W, click_params)

//This proc handles alignment on trays, a la tables.
/obj/item/storage/tray/proc/auto_align(obj/item/W, click_params)
	if (!W.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		W.pixel_x = rand(-W.randpixel, W.randpixel)
		W.pixel_y = rand(-W.randpixel, W.randpixel)
		W.pixel_z = 0
		return

	if (!click_params)
		return

	var/list/click_data = params2list(click_params)
	if (!click_data["icon-x"] || !click_data["icon-y"])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data["icon-x"])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data["icon-y"])-1

	var/cell_x = Clamp(round(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = Clamp(round(mouse_y/CELLSIZE), 0, CELLS-1)

	var/list/center = cached_json_decode(W.center_of_mass)

	W.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	W.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	W.pixel_z = 0

/obj/item/storage/tray/dump_contents(var/mob/user, turf/new_loc = loc)
	if(!isturf(new_loc)) //to handle hand switching
		return FALSE
	if(user)
		close(user)
	if(!(locate(/obj/structure/table) in new_loc) && user && contents.len)
		visible_message(SPAN_DANGER("Everything falls off the [name]! Good job, [user]."))
		scatter_contents(FALSE, new_loc)
	return TRUE

/obj/item/storage/tray/dropped(mob/user)
	. = ..()
	if(!no_drop)
		dump_contents(user)

/obj/item/storage/tray/throw_at(atom/target, range, speed, mob/thrower, spin, datum/callback/callback)
	no_drop = TRUE
	. = ..()

/obj/item/storage/tray/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	no_drop = FALSE
	scatter_contents(FALSE, get_turf(hit_atom))

/obj/item/storage/tray/on_update_icon()
	..()
	vis_contents.Cut()
	for(var/obj/item/I in contents)
		I.vis_flags |= VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
		I.appearance_flags |= RESET_COLOR
		vis_contents |= I

/obj/item/storage/tray/remove_from_storage(obj/item/W, atom/new_location, var/NoUpdate = 0)
	. = ..()
	W.vis_flags = initial(W.vis_flags)
	W.appearance_flags = initial(W.appearance_flags)
	W.update_icon() // in case it updates vis_flags

/obj/item/storage/tray/examine(mob/user) // So when you look at the tray you can see whats on it.
	. = ..()
	if(.)
		if(contents.len)
			var/tray_examine = list()
			for(var/obj/item/I in contents)
				tray_examine += "\a [I.name]"
			to_chat(user, "There is [english_list(tray_examine)] on the tray.")
		else
			to_chat(user, "\The [src] is empty.")

/*
-----------------------------------------------------------------
TRAY TYPES GO HERE
-----------------------------------------------------------------
 */

/obj/item/storage/tray/wood
	name = "tray" //material names are automatic kay?
	desc = "A wooden tray to serve food on."
	material = /decl/material/solid/wood

/obj/item/storage/tray/metal
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/storage/tray/metal/attack(mob/living/carbon/M, mob/living/carbon/user) // So metal trays make the fun noise
	hitsound = pick('sound/items/trayhit1.ogg','sound/items/trayhit2.ogg')
	. = ..()

/obj/item/storage/tray/metal/aluminium
	name = "tray"
	desc = "An aluminium tray to serve food on."
	material = /decl/material/solid/metal/aluminium

/obj/item/storage/tray/metal/silver
	name = "platter"
	desc = "You lazy bum."
	material = /decl/material/solid/metal/silver

/obj/item/storage/tray/metal/gold
	name = "platter"
	desc = "A gold tray to serve food on. But oh sofancy."
	material = /decl/material/solid/metal/gold