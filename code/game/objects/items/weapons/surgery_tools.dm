/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/*
 * Retractor
 */
/obj/item/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'biotech':1}"

/*
 * Hemostat
 */
/obj/item/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'biotech':1}"
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'biotech':1}"
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'materials':1,'biotech':1}"
	attack_verb = list("drilled")

/*
 * Scalpel
 */
/obj/item/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 10.0
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "{'materials':1,'biotech':1}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)

/obj/item/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)

/obj/item/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/*
 * Circular Saw
 */
/obj/item/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "{'materials':1,'biotech':1}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1

/obj/item/circular_saw/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

//misc, formerly from code/defines/weapons.dm
/obj/item/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0

/obj/item/sutures
	name = "sutures"
	desc = "Surgical needles and thread in a handy sterile package."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = "{'materials':1,'biotech':3}"
	w_class = ITEM_SIZE_SMALL

/obj/item/bonesetter
	name = "bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
