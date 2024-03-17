/obj/item/clothing/accessory/long
	icon = 'icons/clothing/accessories/ties/tie_long.dmi'

/obj/item/clothing/accessory/long/red
	name = "long red tie"
	color = "#a02929"

/obj/item/clothing/accessory/black
	name = "black tie"
	color = "#1e1e1e"

/obj/item/clothing/accessory/red
	name = "red tie"
	color = "#800000"

/obj/item/clothing/accessory/blue
	name = "blue tie"
	color = "#123c5a"

/obj/item/clothing/accessory/blue_clip
	name = "blue tie with a clip"
	icon = 'icons/clothing/accessories/ties/tie_clip.dmi'

/obj/item/clothing/accessory/long/yellow
	name = "long yellow tie"
	color = "#c4c83d"

/obj/item/clothing/accessory/navy
	name = "navy tie"
	color = "#182e44"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon = 'icons/clothing/accessories/ties/tie_horrible.dmi'

/obj/item/clothing/accessory/brown
	name = "brown tie"
	icon = 'icons/clothing/accessories/ties/tie_long.dmi'
	color = "#b18345"

//Bowties
/obj/item/clothing/accessory/bowtie/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/untied)
	)
	return expected_state_modifiers

/obj/item/clothing/accessory/bowtie/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon = 'icons/clothing/accessories/ties/bowtie.dmi'

/obj/item/clothing/accessory/bowtie/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon = 'icons/clothing/accessories/ties/bowtie_ugly.dmi'
