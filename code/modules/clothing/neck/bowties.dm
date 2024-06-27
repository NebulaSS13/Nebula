//Bowties
/obj/item/clothing/neck/tie/bow/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/untied)
	)
	return expected_state_modifiers

/obj/item/clothing/neck/tie/bow/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon = 'icons/clothing/accessories/ties/bowtie.dmi'

/obj/item/clothing/neck/tie/bow/color/red
	paint_color = COLOR_RED

/obj/item/clothing/neck/tie/bow/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon = 'icons/clothing/accessories/ties/bowtie_ugly.dmi'
