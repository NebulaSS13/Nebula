//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."
	icon = 'icons/obj/items/tool/clippers.dmi'
	var/static/list/handle_colours = list(
		COLOR_GREEN_GRAY,
		COLOR_BOTTLE_GREEN,
		COLOR_PALE_BTL_GREEN,
		COLOR_DARK_GREEN_GRAY,
		COLOR_PAKISTAN_GREEN
	)

/obj/item/wirecutters/clippers/Initialize()
	. = ..()
	handle_color = pick(handle_colours)
