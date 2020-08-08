
/obj/effect/urfc_armour_set
	var/helmet = /obj/item/clothing/head/helmet/urfc
	var/armour = /obj/item/clothing/suit/armor/special/urfc
	var/jumpsuit = /obj/item/clothing/under/urfc_jumpsuit
	var/gloves = /obj/item/clothing/gloves/soegloves/urfc
	var/shoes = /obj/item/clothing/shoes/magboots/urfc

/obj/effect/urfc_armour_set/New()
	new jumpsuit(src.loc)
	new gloves(src.loc)
	new shoes(src.loc)
	new helmet(src.loc)
	new armour(src.loc)
	.=..()

/obj/effect/urfc_armour_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL


/obj/effect/urfc_armour_set/squadleader
	helmet = /obj/item/clothing/head/helmet/urfc/squadleader
	armour = /obj/item/clothing/suit/armor/special/urfc/squadleader

/obj/effect/urfc_armour_set/engineer
	helmet = /obj/item/clothing/head/helmet/urfc/engineer

/obj/effect/urfc_armour_set/medic
	helmet = /obj/item/clothing/head/helmet/urfc/medic

/obj/effect/urfc_armour_set/sniper
	helmet = /obj/item/clothing/head/helmet/urfc/sniper

/obj/effect/urfc_armour_set/cqb
	helmet = /obj/item/clothing/head/helmet/urfc/cqb

/obj/effect/urfc_armour_set/commander
	helmet = /obj/item/clothing/head/helmet/urfccommander
	armour = /obj/item/clothing/suit/armor/special/urfc/squadleader
	jumpsuit = /obj/item/clothing/under/urfc_jumpsuit/commander
