/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEM_SIZE_TINY
	material           = /decl/material/solid/wax
	attack_verb = list("attacked", "coloured")
	colour = "#ff0000" //RGB
	color_description = "red crayon"
	iscrayon = TRUE

	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes

/obj/item/pen/crayon/Initialize()
	name = "[colourName] crayon"
	. = ..()
