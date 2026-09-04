/obj/item/bladed/proc/get_sharpened_effect_params()
	return list(
		(IE_CAT_DAMAGE) = list(
			(IE_PAR_USES)           = max(1, max(1, rand(round(10 * 0.3), round(20 * 0.6)))),
			(IE_PAR_MAX_USES)       = 30,
			(IE_PAR_SHARP_DAM_MULT) = 0.25
		),
		(IE_CAT_EXAMINE)
	)

/obj/item/bladed/Initialize(ml, material_key, _hilt_mat, _guard_mat, _pommel_mat)
	var/list/sharpened_params = get_sharpened_effect_params()
	if(length(sharpened_params))
		add_item_effect(/decl/item_effect/sharpened, sharpened_params)
	. = ..()
	if(length(sharpened_params))
		update_attack_force()
		update_name()

/obj/item/bladed/folding/try_sharpen_with(mob/user, obj/sharpening_with)
	if(!open)
		to_chat(user, SPAN_WARNING("You cannot sharpen \the [src] while it's closed!"))
		return FALSE
	return ..()
