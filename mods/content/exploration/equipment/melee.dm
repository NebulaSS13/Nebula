/obj/item/knife/folding/swiss/explorer
	name = "explorer's combi-knife"
	desc = "A small, purple, multi-purpose folding knife. This one adds a wood saw and prybar."
	handle_color = COLOR_PURPLE
	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_WBLADE, SWISSKNF_CROWBAR)

/obj/item/knife/survival
	name = "survival knife"
	desc = "A hunting-grade survival knife."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/items/bladed/knife.dmi'
	_base_attack_force = 6
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC // base icon is too dark to work with steel color
