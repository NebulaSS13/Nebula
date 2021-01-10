/obj/item/wrench
	name = "wrench"
	desc = "A good, durable combination wrench, with self-adjusting, universal open- and ring-end mechanisms to match a wide variety of nuts and bolts."
	icon = 'icons/obj/items/tool/wrench.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	material_force_multiplier = 0.2
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'engineering':1}"
	material = /decl/material/solid/metal/steel
	center_of_mass = @"{'x':17,'y':16}"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	applies_material_colour = TRUE
	var/handle_color
	var/global/valid_colours = list(COLOR_RED_GRAY, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_GRAY20)

/obj/item/wrench/on_update_icon()
	. = ..()
	if(!handle_color)
		handle_color = pick(valid_colours)
	overlays += mutable_appearance(icon, "[get_world_inventory_state()]_handle", handle_color)