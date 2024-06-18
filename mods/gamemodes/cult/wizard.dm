// #ifdef GAMEMODE_PACK_WIZARD
// todo: add wizard gamemode define check once it's modularized
/decl/modpack/cult/post_initialize()
	. = ..()
	global.artefact_feedback[/obj/structure/closet/wizard/souls] = "SS"

/datum/spellbook/standard/New()
	spells[/obj/structure/closet/wizard/souls] = 1
	..()

/datum/spellbook/druid/New()
	spells[/obj/structure/closet/wizard/souls] = 1
	..()

/obj/structure/closet/wizard/souls
	name = "Soul Shard Belt"
	desc = "Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The spell Artificer allows you to create arcane machines for the captured souls to pilot. This also includes the spell Artificer, used to create the shells used in construct creation."

/obj/structure/closet/wizard/souls/WillContain()
	return list(
		/obj/item/contract/boon/wizard/artificer,
		/obj/item/belt/soulstone/full,
	)

/datum/storage/belt/soulstone
	can_hold = list(
		/obj/item/soulstone
	)

/obj/item/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away."
	icon = 'icons/clothing/belt/soulstones.dmi'
	storage = /datum/storage/belt/soulstone

/obj/item/belt/soulstone/full/WillContain()
	return list(/obj/item/soulstone = max(1, storage?.storage_slots))

/obj/item/contract/boon/wizard/artificer
	path = /spell/aoe_turf/conjure/construct
	desc = "This contract has a passage dedicated to an entity known as 'Nar-Sie'."

/obj/item/magic_rock
	material = /decl/material/solid/stone/cult

/obj/item/summoning_stone
	material = /decl/material/solid/stone/cult