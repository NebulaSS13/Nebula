//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."
	icon = 'icons/obj/items/tool/clippers.dmi'

/obj/item/wirecutters/clippers/Initialize(ml, material_key)
	. = ..()
	handle_color = pick(COLOR_GREEN_GRAY, COLOR_BOTTLE_GREEN, COLOR_PALE_BTL_GREEN, COLOR_DARK_GREEN_GRAY, COLOR_PAKISTAN_GREEN)
