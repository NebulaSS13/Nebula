/obj/item/flame/torch
	name                  = "torch"
	desc                  = "A short length of wood topped by a bulbous mass of flammable fuel."
	icon                  = 'icons/obj/items/flame/torch.dmi'
	attack_verb           = list("burnt", "singed")
	randpixel             = 10
	max_force             = 5
	_fuel                 = null
	lit_light_power       = 0.7
	lit_light_range       = 3
	extinguish_on_dropped = FALSE
	sconce_can_hold       = TRUE
	material_alteration   = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/head_material     = /decl/material/solid/organic/cloth
	var/burnt             = FALSE

/obj/item/flame/torch/Initialize()
	. = ..()
	set_color(null) // clear our scent color

/obj/item/flame/torch/get_available_scents()
	var/static/list/available_scents = list(
		/decl/scent_type/woodsmoke
	)
	return available_scents

/obj/item/flame/torch/light(mob/user, no_message)
	if(coating?.total_volume && coating.get_accelerant_value() < FUEL_VALUE_NONE)
		to_chat(user, SPAN_WARNING("You cannot light \the [src] while it is wet!"))
		return FALSE
	if(burnt)
		to_chat(user, SPAN_WARNING("\The [src] is burnt up."))
		return FALSE
	return ..()

/obj/item/flame/torch/Initialize(var/ml, var/material_key, var/_head_material)
	. = ..()

	if(_head_material)
		head_material = _head_material

	var/decl/material/head_mat = GET_DECL(head_material)
	if(!head_mat || head_mat.accelerant_value <= 0)
		head_material = /decl/material/solid/organic/cloth
		head_mat = GET_DECL(head_material)

	if(isnull(_fuel))
		_fuel = round(45 MINUTES / SSobj.wait)
		if(head_mat)
			_fuel = round(_fuel * (1 + head_mat.accelerant_value))

	update_icon()

/obj/item/flame/torch/extinguish(var/mob/user, var/no_message)
	. = ..()
	if(. && _fuel <= 0 && !burnt)
		burnt = TRUE
		name = "burnt torch"
		desc = "A torch. This one has seen better days."
		update_icon()

/obj/item/flame/torch/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay)
		if(head_material)
			var/decl/material/head_mat = GET_DECL(head_material)
			if(burnt)
				overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-burnt", head_mat.color, flags = RESET_COLOR)
			else
				overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-head", head_mat.color, flags = RESET_COLOR)
		if(lit)
			overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-lit", flags = RESET_COLOR)
	return ..()

/obj/item/flame/torch/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(head_material)
		var/decl/material/head_mat = GET_DECL(head_material)
		if(burnt)
			add_overlay(overlay_image(icon, "[icon_state]-burnt", head_mat.color, flags = RESET_COLOR))
		else
			add_overlay(overlay_image(icon, "[icon_state]-head", head_mat.color, flags = RESET_COLOR))
	if(lit)
		add_overlay(overlay_image(icon, "[icon_state]-lit", flags = RESET_COLOR))

/obj/item/flame/torch/get_sconce_overlay()
	. = list(overlay_image(icon, "[icon_state]-sconce", color = color, flags = RESET_COLOR))
	if(head_material)
		var/decl/material/head_mat = GET_DECL(head_material)
		if(burnt)
			. += overlay_image(icon, "[icon_state]-sconce-burnt", head_mat.color, flags = RESET_COLOR)
		else
			. += overlay_image(icon, "[icon_state]-sconce-head", head_mat.color, flags = RESET_COLOR)
	if(lit)
		. += overlay_image(icon, "[icon_state]-sconce-lit", color = lit_light_color, flags = RESET_COLOR)
