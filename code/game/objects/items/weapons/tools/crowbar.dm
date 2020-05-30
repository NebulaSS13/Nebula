/obj/item/crowbar
	name = "crowbar"
	desc = "A heavy crowbar of solid steel, good and solid in your hand."
	icon = 'icons/obj/items/tool/crowbar.dmi'
	icon_state = "crowbar"
	slot_flags = SLOT_BELT
	attack_cooldown = 2*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	throwforce = 7
	throw_range = 3
	item_state = "crowbar"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'engineering':1}"
	material = MAT_STEEL
	center_of_mass = @"{'x':16,'y':20}"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	applies_material_colour = TRUE
	var/shape_variations = 1
	var/possible_handle_colours = list(COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_BOTTLE_GREEN, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_VIOLET, COLOR_GRAY20)
	var/handle_colour
	var/shape_type
	//List of things crowbars made from brittle materials have high chance of breaking on.
	var/global/list/break_chances = list(
		/obj/machinery/door = 80,
		/turf/simulated/floor/tiled = 25,
		/mob/living = 15,
		/obj/machinery = 15
		)

/obj/item/crowbar/get_autopsy_descriptors()
	. = ..()
	. += "narrow"

/obj/item/crowbar/on_update_icon()
	..()
	if(!shape_type)
		shape_type = rand(1,shape_variations)
	icon_state = "bar[shape_type]"
	if(!handle_colour)
		handle_colour = pick(possible_handle_colours)
	overlays += overlay_image(icon, "handle[shape_type]", handle_colour, flags=RESET_COLOR)

/obj/item/crowbar/afterattack(atom/target, mob/user)
	. = ..()
	if(!material.is_brittle())
		return
	var/break_chance = 5

	if(QDELETED(src))
		return
	for(var/checktype in break_chances)
		if(istype(target, checktype))
			break_chance = break_chances[checktype]
			break
	if(prob(break_chance))
		playsound(user, 'sound/effects/snap.ogg', 40, 1)
		to_chat(user, SPAN_WARNING("\The [src] shatters like the cheap garbage it was!"))
		qdel(src)
		user.put_in_hands(new /obj/item/material/shard(get_turf(user), material.type))
	return

/obj/item/crowbar/red
	handle_colour = COLOR_MAROON

/obj/item/crowbar/gold
	material = MAT_GOLD

/obj/item/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations and colours - collect them all."
	icon_state = "prybar_preview"
	item_state = "crowbar"
	icon = 'icons/obj/items/tool/prybar.dmi'
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	shape_variations = 5

/obj/item/crowbar/prybar/cheap
	name = "discount pry bar"
	desc = "A plastic bar with a wedge. It looks so poorly manufactured that you're sure it will break if you try to use it."
	material = MAT_PLASTIC
	w_class = ITEM_SIZE_TINY

/obj/item/crowbar/emergency_forcing_tool
	name = "emergency forcing tool"
	desc = "This is an emergency forcing tool, made of steel bar with a wedge on one end, and a hatchet on the other end. It has a blue plastic grip"
	icon = 'icons/obj/items/tool/forcing_tool.dmi'
	icon_state = "emergency_forcing_tool"
	item_state = "emergency_forcing_tool"
	throw_range = 5
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_NORMAL
	material = MAT_STEEL
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "attacked", "slashed", "torn", "ripped", "cut")
	applies_material_colour = FALSE

/obj/item/crowbar/emergency_forcing_tool/on_update_icon()
	return //snowflake axe thing

/obj/item/crowbar/emergency_forcing_tool/resolve_attackby(atom/A)//extra dmg against glass, it's an emergency forcing tool, it's gotta be good at something
	if(istype(A, /obj/structure/window))
		force = initial(force) * 2
	else
		force = initial(force)
	. = ..()

/obj/item/crowbar/emergency_forcing_tool/iscrowbar()//go ham
	if(ismob(loc))
		var/mob/M = loc
		if(M.a_intent && M.a_intent == I_HURT)
			return FALSE
	return TRUE
