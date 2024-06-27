/obj/item/clothing/shirt/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon = 'icons/clothing/shirts/hawaiian.dmi'

/obj/item/clothing/shirt/hawaii/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons)
	)
	return expected_state_modifiers

/obj/item/clothing/shirt/hawaii/red
	icon = 'icons/clothing/shirts/hawaiian_alt.dmi'

/obj/item/clothing/shirt/hawaii/random/Initialize()
	. = ..()
	icon = pick('icons/clothing/shirts/hawaiian.dmi', 'icons/clothing/shirts/hawaiian_alt.dmi')
	color = color_matrix_rotate_hue(rand(-11,12)*15)
