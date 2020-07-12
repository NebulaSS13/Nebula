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

/obj/item/storage/tray/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(istype(target, /obj/structure/table))
		dump_contents(user, get_turf(target))

/obj/item/storage/tray/proc/scatter_contents(var/neatly = FALSE, target_loc = get_turf(src))
	set waitfor = 0
	for(var/obj/item/I in contents)
		if(remove_from_storage(I, target_loc) && !neatly)
			I.throw_at(get_edge_target_turf(I.loc, pick(GLOB.alldirs)), rand(1,3), round(10/I.w_class))
	update_icon()

/obj/item/storage/tray/shatter(consumed)
	scatter_contents()
	. = ..()

/obj/item/storage/tray/attack(mob/living/carbon/M, mob/living/carbon/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50)) // There is a better way to do this but I'll be damned if I'm the one to fix it.
		to_chat(user, SPAN_DANGER("You accidentally slam yourself with the [src]!"))
		user.Weaken(1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(M, hitsound, 50, 1)
		. = TRUE
	else
		. = ..()
	if(.)
		scatter_contents()

/obj/item/storage/tray/attackby(obj/item/W, mob/user) // Keeping this from old trays because... i guess?
	if(istype(W, /obj/item/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("\The [user] bashes \the [src] with \the [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/storage/tray/dump_contents(var/mob/user, turf/new_loc = loc)
	if(!isturf(new_loc)) //to handle hand switching
		return FALSE
	if(user)
		close(user)
	if(!(locate(/obj/structure/table) in new_loc) && user && contents.len)
		visible_message(SPAN_DANGER("Everything falls off the [name]! Good job, [user]."))
		scatter_contents(FALSE, new_loc)
	else
		scatter_contents(TRUE, new_loc)
	return TRUE

/obj/item/storage/tray/dropped(mob/user)
	. = ..()
	dump_contents(user)

/obj/item/storage/tray/on_update_icon()
	..()
	overlays.Cut()
	for(var/obj/item/I in contents)
		var/mutable_appearance/MA = new(I)
		MA.layer = FLOAT_LAYER
		MA.appearance_flags = RESET_COLOR
		overlays += MA

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