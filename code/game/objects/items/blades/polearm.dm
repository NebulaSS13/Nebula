/obj/item/bladed/polearm
	abstract_type  = /obj/item/bladed/polearm
	can_be_twohanded = TRUE
	pickup_sound   = 'sound/foley/scrape1.ogg'
	drop_sound     = 'sound/foley/tooldrop1.ogg'
	w_class        = ITEM_SIZE_HUGE
	slot_flags     = SLOT_BACK

/obj/item/bladed/polearm/spear
	name                      = "spear"
	desc                      = "A haphazardly-constructed yet still deadly weapon of ancient design."
	icon                      = 'icons/obj/items/bladed/spear.dmi'
	throw_speed               = 3
	edge                      = 0
	sharp                     = 1
	attack_verb               = list("attacked", "poked", "jabbed", "torn", "gored")
	material                  = /decl/material/solid/glass
	material_alteration       = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	does_spin                 = FALSE
	var/shaft_material        = /decl/material/solid/metal/steel
	var/cable_color           = COLOR_RED

/obj/item/bladed/polearm/spear/shatter(var/consumed)
	if(!consumed)
		SSmaterials.create_object(shaft_material, get_turf(src), 1, /obj/item/stack/material/rods)
		new /obj/item/stack/cable_coil(get_turf(src), 3, cable_color)
	..()

/obj/item/bladed/polearm/spear/on_update_icon()
	. = ..()
	add_overlay(list(
			get_shaft_overlay("shaft"),
			mutable_appearance(icon, "cable", cable_color)
		))


/obj/item/bladed/polearm/spear/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		if(check_state_in_icon("[overlay.icon_state]-shaft", overlay.icon))
			overlay.overlays += get_shaft_overlay("[overlay.icon_state]-shaft")
		if(check_state_in_icon("[overlay.icon_state]-cable", overlay.icon))
			overlay.overlays += mutable_appearance(icon, "[overlay.icon_state]-cable", cable_color)
	. = ..()

/obj/item/bladed/polearm/spear/proc/get_shaft_overlay(var/base_state)
	var/decl/material/M = GET_DECL(shaft_material)
	var/mutable_appearance/shaft = mutable_appearance(icon, base_state, M.color)
	shaft.alpha = 155 + 100 * M.opacity
	return shaft

/obj/item/bladed/polearm/spear/diamond
	material = /decl/material/solid/gemstone/diamond
	shaft_material = /decl/material/solid/metal/gold
	cable_color = COLOR_PURPLE

/obj/item/bladed/polearm/spear/steel
	material = /decl/material/solid/metal/steel
	shaft_material = /decl/material/solid/organic/wood
	cable_color = COLOR_GREEN

/obj/item/bladed/polearm/spear/supermatter
	material = /decl/material/solid/exotic_matter
	shaft_material = /decl/material/solid/organic/wood/ebony
	cable_color = COLOR_INDIGO
