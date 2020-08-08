/*UNSC*/

/obj/item/clothing/under/unsc/marine_fatigues
	desc = "Standard issue uniform for UNSC marine corps."
	name = "UNSC Marine fatigues"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "UNSC Marine Fatigues"
	icon_state = "uniform_obj"
	worn_state = "UNSC Marine Fatigues"
	starting_accessories = /obj/item/clothing/accessory/badge/tags

/*URF*/


/obj/item/clothing/under/urfc_jumpsuit
	name = "URF Commando uniform"
	desc = "Standard issue URF Commando uniform. You won't find a uniform more badass than this."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "commando_uniform"
	item_state = "commando_uniform"
	item_flags = STOPPRESSUREDAMAGE|AIRTIGHT

/obj/item/clothing/under/innie/jumpsuit
	name = "Insurrectionist Jumpsuit"
	desc = "A grey insurrectionist jumpsuit."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "jumpsuit1_s"
	icon_state = "jumpsuit1_s"
	worn_state = "jumpsuit1"
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
