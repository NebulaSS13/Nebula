/obj/item/stack/material/fluid_act(var/datum/reagents/fluids)
	. = ..()
	if(!QDELETED(src) && fluids?.total_volume && material?.tans_to)
		if(!dried_type)
			dried_type = type
		drying_wetness = get_max_drying_wetness()
		update_icon()

/obj/item/stack/material/dry_out(var/obj/rack, var/drying_power = 1, var/fire_exposed = FALSE, var/silent = FALSE)
	. = ..()
	if(!QDELETED(src))
		update_icon()

/obj/item/stack/material/get_dried_product()
	if(ispath(dried_type, /obj/item/stack/material) && material)
		return new dried_type(loc, amount, (material.tans_to || material.type))
	return ..()

/obj/item/stack/material/get_drying_overlay(var/obj/rack)
	var/image/I = ..()
	if(I && drying_wetness > 0)
		var/image/soggy = image(I.icon, I.icon_state)
		soggy.appearance_flags |= RESET_COLOR | RESET_ALPHA
		soggy.alpha = 255 * (get_max_drying_wetness() / drying_wetness)
		soggy.color = COLOR_GRAY40
		soggy.blend_mode = BLEND_MULTIPLY
		I.overlays += soggy
	return I
