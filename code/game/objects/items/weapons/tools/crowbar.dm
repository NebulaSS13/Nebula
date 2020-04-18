/obj/item/crowbar
	name = "crowbar"
	desc = "A heavy crowbar of solid steel, good and solid in your hand."
	icon = 'icons/obj/items/tool/crowbar.dmi'
	icon_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 14
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

/obj/item/crowbar/get_autopsy_descriptors()
	. = ..()
	. += "narrow"

/obj/item/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations and colours - collect them all."
	icon_state = "prybar_preview"
	item_state = "crowbar"
	icon = 'icons/obj/items/tool/prybar.dmi'
	force = 4
	throwforce = 6
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	material = MAT_STEEL

	var/prybar_types = list("1","2","3","4","5")
	var/valid_colours = list(COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_BOTTLE_GREEN, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_VIOLET, COLOR_GRAY20)

/obj/item/crowbar/prybar/Initialize()
	var/shape = pick(prybar_types)
	icon_state = "bar[shape]_handle"
	color = pick(valid_colours)
	overlays += overlay_image(icon, "bar[shape]_hardware", flags=RESET_COLOR)
	. = ..()

/obj/item/crowbar/emergency_forcing_tool
	name = "emergency forcing tool"
	desc = "This is an emergency forcing tool, made of steel bar with a wedge on one end, and a hatchet on the other end. It has a blue plastic grip"
	icon = 'icons/obj/items/tool/forcing_tool.dmi'
	icon_state = "emergency_forcing_tool"
	item_state = "emergency_forcing_tool"
	force = 12
	throwforce = 6
	throw_range = 5
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_NORMAL
	material = MAT_STEEL
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "attacked", "slashed", "torn", "ripped", "cut")

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

/obj/item/crowbar/prybar/cheap
	name = "discount pry bar"
	desc = "A plastic bar with a wedge. It looks so poorly manufactured that you're sure it will break if you try to use it."
	force = 2
	throwforce = 4
	material = MAT_PLASTIC
	obj_flags = null
	w_class = ITEM_SIZE_TINY

//List of things prybar has high chance of breaking on. Global for optimzation
var/global/list/prybar_break_chances = list(
	/obj/machinery/door = 80,
	/turf/simulated/floor/tiled = 25,
	/mob/living = 15,
	/obj/machinery = 15
	)

/obj/item/crowbar/prybar/cheap/afterattack(atom/target, mob/user)
	. = ..()
	var/break_chance = 05

	if(QDELETED(src))
		return
	for(var/checktype in prybar_break_chances)
		if(istype(target, checktype))
			break_chance = prybar_break_chances[checktype]
			break
	if(prob(break_chance))
		playsound(user, 'sound/effects/snap.ogg', 40, 1)
		to_chat(user, SPAN_WARNING("\The [src] shatters like the cheap garbage it was!"))
		qdel(src)
		user.put_in_hands(new /obj/item/material/shard(get_turf(user), MAT_PLASTIC))
	return
