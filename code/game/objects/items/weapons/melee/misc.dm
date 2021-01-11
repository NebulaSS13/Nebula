/obj/item/whip
	name = "whip"
	desc = "A generic whip."
	icon = 'icons/obj/items/weapon/whip.dmi'
	icon_state = "chain"
	item_state = "chain"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	force = 10
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':4}"
	attack_verb = list("flicked", "whipped", "lashed")

/obj/item/whip/abyssal
	name = "abyssal whip"
	desc = "A weapon from the abyss. Requires 70 attack to wield."
	icon_state = "whip"
	item_state = "whip"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	force = 16 //max hit with 60 strength and no equipment. Duel Arena no No forfeit - Snapshot
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':4}"
	attack_verb = list("flicked", "whipped", "lashed")

/obj/item/whip/tail
	name = "drake's tail"
	desc = "The tail of a large scaled creature, obviously evolved as some kind of whipping weapon. It's razor sharp and incredibly tough, though relatively lightweight."
	icon_state = "tailwhip"
	item_state = "whip"
	obj_flags = null
	force = 19
	edge = TRUE
	origin_tech = "{'combat':6,'materials':5}"

/obj/item/whip/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	icon_state = "chain"
	item_state = "whip"

/obj/item/sword/replica/officersword
	name = "fleet officer's sword"
	desc = "A polished sword issued to officers of the fleet."
	icon = 'icons/obj/items/weapon/parade_sword.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	applies_material_colour = FALSE

/obj/item/sword/replica/officersword/army
	name = "army NCO's sword"
	desc = "A polished sword issued to NCOs."
	icon = 'icons/obj/items/weapon/parade_sword_army.dmi'

/obj/item/sword/replica/officersword/armyofficer
	name = "army officer's sword"
	desc = "A curved sword issued to officers."
	icon = 'icons/obj/items/weapon/parade_sword_armyofficer.dmi'

/obj/item/sword/replica/officersword/pettyofficer
	name = "chief petty officer's cutlass"
	desc = "A polished cutlass issued to chief petty officers of the fleet."
	icon = 'icons/obj/items/weapon/parade_sword_pettyofficer.dmi'
