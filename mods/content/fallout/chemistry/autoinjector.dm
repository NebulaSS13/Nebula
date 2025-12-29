/obj/item/chems/hypospray/autoinjector/stimpak
	name = "stimpak"
	icon = 'mods/content/fallout/chemistry/icons/stimpak.dmi'
	item_state = "stimpak"
	icon_state = "stimpak"
/obj/item/chems/hypospray/autoinjector/stimpak/WillContain()
	return list(/decl/material/liquid/regenerator/stimpak = 5)
