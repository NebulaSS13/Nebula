/obj/random/loot/spawn_choices()
	. = ..() || list()
	. |= list(/obj/item/clothing/mask/gas/vox = 8)

/obj/item/box/vox
	name = "vox survival kit"
	desc = "A box decorated in warning colors that contains a limited supply of survival tools. The panel and black stripe indicate this one contains nitrogen."
	icon_state = "survivalvox"

/obj/item/box/vox/WillContain()
	return list(
			/obj/item/clothing/mask/breath = 1,
			/obj/item/tank/emergency/nitrogen = 1,
			/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer = 1,
			/obj/item/stack/medical/bandage = 1,
			/obj/item/flashlight/flare/glowstick = 1,
			/obj/item/food/junk/candy/proteinbar = 1
		)

/obj/item/tank/emergency/nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red and issued to Vox crewmembers."
	icon = 'mods/species/vox/icons/nitrogen_tank.dmi'
	starting_pressure = list(/decl/material/gas/nitrogen = 10 ATM)
