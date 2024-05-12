/obj/item/flame/fuelled/lighter/zippo
	name     = "zippo lighter"
	desc     = "It's a zippo-styled lighter, using a replacable flint in a fetching steel case. It makes a clicking sound that everyone loves."
	icon     = 'icons/obj/items/flame/zippo.dmi'
	max_fuel = 10
	material = /decl/material/solid/metal/stainlesssteel

/obj/item/flame/fuelled/lighter/zippo/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay && lit && (slot in global.all_hand_slots))
		overlay.icon_state = "[overlay.icon_state]_open"
	return ..()

/obj/item/flame/fuelled/lighter/zippo/on_update_icon()
	if(!lit)
		icon_state = get_world_inventory_state()
		cut_overlays()
		return
	. = ..()
	icon_state = "[icon_state]_open"

/obj/item/flame/fuelled/lighter/zippo/light_effects(mob/user)
	user.visible_message(SPAN_ROSE("Without even breaking stride, \the [user] flips open and lights \the [src] in one smooth movement."))
	playsound(src.loc, 'sound/items/zippo_open.ogg', 100, 1, -4)

/obj/item/flame/fuelled/lighter/zippo/shutoff_effects(mob/user)
	user.visible_message(SPAN_ROSE("You hear a quiet click, as [user] shuts off \the [src] without even looking at what they're doing."))
	playsound(src.loc, 'sound/items/zippo_close.ogg', 100, 1, -4)

/obj/item/flame/fuelled/lighter/zippo/black
	color = COLOR_DARK_GRAY
	name = "black zippo"

/obj/item/flame/fuelled/lighter/zippo/gunmetal
	color = COLOR_GUNMETAL
	name = "gunmetal zippo"

/obj/item/flame/fuelled/lighter/zippo/brass
	name = "brass zippo"
	material = /decl/material/solid/metal/brass
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/item/flame/fuelled/lighter/zippo/bronze
	name = "bronze zippo"
	material = /decl/material/solid/metal/bronze
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/item/flame/fuelled/lighter/zippo/pink
	color = COLOR_PINK
	name = "pink zippo"

//Spawn using the colour list in the master type
/obj/item/flame/fuelled/lighter/zippo/random
	var/static/list/available_materials = list(
		/decl/material/solid/metal/brass,
		/decl/material/solid/metal/bronze,
		/decl/material/solid/metal/blackbronze,
		/decl/material/solid/metal/stainlesssteel = list(null, COLOR_WHITE, COLOR_DARK_GRAY, COLOR_GUNMETAL), //null color is the natural material color
	)
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/flame/fuelled/lighter/zippo/random/Initialize(ml, material_key)
	var/picked_mat = pick(available_materials)
	var/picked_color
	if(length(available_materials[picked_mat]))
		var/list/available = available_materials[picked_mat]
		picked_color = pick(available)
		log_debug("Picked color : '[picked_color]' out of [length(available)]")
		if(picked_color)
			material_alteration &= ~MAT_FLAG_ALTERATION_COLOR

	. = ..(ml, picked_mat)

	if(picked_color)
		set_color(picked_color)
