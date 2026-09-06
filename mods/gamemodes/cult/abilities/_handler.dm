/obj/screen/ability/category/cult
	name = "Toggle Construct Abilities"
	icon = 'mods/gamemodes/cult/icons/abilities.dmi'

/obj/screen/ability/button/cult
	icon = 'mods/gamemodes/cult/icons/abilities.dmi'

/datum/ability_handler/cult
	category_toggle_type = /obj/screen/ability/category/cult

/decl/ability/cult
	abstract_type           = /decl/ability/cult
	ability_icon            = 'mods/gamemodes/cult/icons/abilities.dmi'
	ability_icon_state      = "artificer"
	associated_handler_type = /datum/ability_handler/cult
	ui_element_type         = /obj/screen/ability/button/cult
	ability_cooldown_time   = 60 SECONDS

/obj/item/ability/cult
	icon                    = 'mods/gamemodes/cult/icons/ability_item.dmi'
	color                   = COLOR_RED
