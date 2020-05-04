
/obj/item/clothing/suit/storage/toggle/labcoat/rd/corp
	name = "\improper EXO research director's labcoat"
	markings_color = COLOR_BOTTLE_GREEN

/obj/item/clothing/suit/storage/toggle/labcoat/rd/corp/nanotrasen
	name = "\improper NT research director's labcoat"
	markings_color = COLOR_NT_RED

/obj/item/clothing/suit/storage/toggle/labcoat/rd/corp/heph
	name = "\improper HI research director's labcoat"
	markings_color = COLOR_LUMINOL

/obj/item/clothing/suit/storage/toggle/labcoat/rd/corp/zeng
	name = "\improper Z-H research director's labcoat"
	markings_color = COLOR_PALE_YELLOW

/obj/item/clothing/suit/storage/toggle/labcoat/science/corp/nanotrasen
	name = "\improper NanoTrasen labcoat"
	markings_color = COLOR_NT_RED

/obj/item/clothing/suit/storage/toggle/labcoat/science/corp/heph
	name = "\improper Hephaestus Industries labcoat"
	markings_color = COLOR_LUMINOL

/obj/item/clothing/suit/storage/toggle/labcoat/science/corp/zeng
	name = "\improper Zeng-Hu labcoat"
	markings_color = COLOR_PALE_YELLOW

/obj/item/clothing/suit/storage/toggle/labcoat/science/corp/morpheus
	name = "\improper Morpheus Cyberkinetics labcoat"
	markings_color = COLOR_SILVER

/obj/item/clothing/suit/storage/toggle/labcoat/science/corp/dais
	name = "\improper DAIS labcoat"
	desc = "A labcoat with a the logo of Deimos Advanced Information Systems emblazoned on the back. It has a stylish blue \
	trim and the pockets are reinforced to hold tools. It seems to have an insulated material woven in to prevent static shocks."
	markings_color = COLOR_NAVY_BLUE
	armor = list(
		melee = ARMOR_MELEE_MINOR
	)//They don't need to protect against the environment very much.
	siemens_coefficient = 0.5 //These guys work with electronics. DAIS's labcoats shouldn't conduct very well.
