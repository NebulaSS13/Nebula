/decl/loadout_option/mask/skrell
	name = "skrellian gill cover"
	path = /obj/item/clothing/mask/gas/skrell
	whitelisted = list(BODYTYPE_SKRELL)

/obj/item/clothing/mask/gas/skrell
	name = "skrellian gill cover"
	desc = "A comfy technological piece used typically by those suffering from gill-related disorders. It goes around the neck and shoulders with a small water tank on the back, featuring a hookup for oxytanks to keep the water oxygenated."
	icon = 'mods/species/bayliens/skrell/icons/clothing/mask/gill_cover.dmi'
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/mask/gas/skrell/mob_can_equip(mob/living/M, slot, disable_warning = 0, ignore_equipped = FALSE)
	. = ..()
	if(. && M?.get_bodytype()?.name != BODYTYPE_SKRELL)
		return FALSE