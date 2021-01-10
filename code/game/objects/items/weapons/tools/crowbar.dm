/obj/item/crowbar
	name = "crowbar"
	desc = "A heavy crowbar, good and solid in your hand."
	icon = 'icons/obj/items/tool/crowbar.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	material_force_multiplier = 0.25
	attack_cooldown = 2*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'engineering':1}"
	material = /decl/material/solid/metal/steel
	center_of_mass = @"{'x':16,'y':20}"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	applies_material_colour = TRUE
	var/global/valid_colours = list(COLOR_RED_GRAY, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_GRAY20)
	var/handle_color
	var/shape_variations = 1
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
	icon_state = "[get_world_inventory_state()][shape_type]"
	if(!handle_color)
		handle_color = pick(valid_colours)
	overlays += mutable_appearance(icon, "[get_world_inventory_state()]_handle[shape_type]", handle_color)

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
		user.put_in_hands(new /obj/item/shard(get_turf(user), material.type))
	return

/obj/item/crowbar/red
	handle_color = COLOR_MAROON

/obj/item/crowbar/gold
	material = /decl/material/solid/metal/gold

/obj/item/crowbar/cheap
	name = "discount pry bar"
	desc = "A plastic bar with a wedge. It looks so poorly manufactured that you're sure it will break if you try to use it."
	material = /decl/material/solid/plastic
	w_class = ITEM_SIZE_TINY
	shape_variations = 6
