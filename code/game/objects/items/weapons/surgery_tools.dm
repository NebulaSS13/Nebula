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
	desc = "A surgical tool for widening incisions or adjusting bones."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":1,"biotech":1}'
	drop_sound = 'sound/foley/knifedrop3.ogg'

/obj/item/retractor/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_RETRACTOR = TOOL_QUALITY_DEFAULT))

/*
 * Hemostat
 */
/obj/item/hemostat
	name = "hemostat"
	desc = "A surgical tool for clamping veins or manipulating internal organs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":1,"biotech":1}'
	attack_verb = list("attacked", "pinched")
	drop_sound = 'sound/foley/knifedrop3.ogg'

/obj/item/hemostat/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_HEMOSTAT = TOOL_QUALITY_DEFAULT))

/*
 * Cautery
 */
/obj/item/cautery
	name = "cautery"
	desc = "A surgical tool for halting bleeding or closing incisions."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":1,"biotech":1}'
	attack_verb = list("burnt")

/obj/item/cautery/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_CAUTERY = TOOL_QUALITY_DEFAULT))

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
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	_base_attack_force = 15
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"materials":1,"biotech":1}'
	attack_verb = list("drilled")

/obj/item/surgicaldrill/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SURGICAL_DRILL = TOOL_QUALITY_DEFAULT))

/*
 * Scalpel
 */
/obj/item/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throw_speed = 3
	throw_range = 5
	origin_tech = @'{"materials":1,"biotech":1}'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	_base_attack_force = 10
	var/tool_quality = TOOL_QUALITY_DEFAULT

/obj/item/scalpel/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SCALPEL = tool_quality))

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	atom_damage_type =  BURN
	_base_attack_force = 10
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	pickup_sound = 'sound/foley/pickup2.ogg'
	tool_quality = TOOL_QUALITY_DECENT
	origin_tech = @'{"biotech":2,"materials":2,"magnets":2}'

/obj/item/scalpel/laser/upgraded
	name = "upgraded laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	_base_attack_force = 12
	icon_state = "scalpel_laser2_on"
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	tool_quality = TOOL_QUALITY_GOOD
	origin_tech = @'{"biotech":3,"materials":4,"magnets":4}'

/obj/item/scalpel/laser/advanced
	name = "advanced laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	_base_attack_force = 15
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)
	tool_quality = TOOL_QUALITY_BEST
	origin_tech = @'{"biotech":4,"materials":6,"magnets":5}'

/obj/item/incision_manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel combines several medical tools into one modular package."
	sharp = 1
	edge = 1
	atom_damage_type =  BURN
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel_manager_on"
	_base_attack_force = 7
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	pickup_sound = 'sound/foley/pickup2.ogg'
	origin_tech = @'{"biotech":4,"materials":7,"magnets":5,"programming":4}'

/obj/item/incision_manager/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool/variable, list(
		TOOL_SAW =       TOOL_QUALITY_GOOD,
		TOOL_SCALPEL =   TOOL_QUALITY_GOOD,
		TOOL_RETRACTOR = TOOL_QUALITY_GOOD,
		TOOL_HEMOSTAT =  TOOL_QUALITY_GOOD
	))

/*
 * Circular Saw
 */
/obj/item/circular_saw
	name = "circular saw"
	desc = "For heavy-duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 3
	throw_range = 5
	origin_tech = @'{"materials":1,"biotech":1}'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1
	pickup_sound = 'sound/foley/pickup2.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	_base_attack_force = 15

/obj/item/circular_saw/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SAW = TOOL_QUALITY_DEFAULT))

/obj/item/circular_saw/get_autopsy_descriptors()
	. = ..()
	. += "serrated"

/obj/item/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	w_class = ITEM_SIZE_SMALL
	item_flags = ITEM_FLAG_NO_BLUDGEON
	obj_flags = OBJ_FLAG_HOLLOW
	material = /decl/material/solid/organic/plastic

/obj/item/bonegel/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_BONE_GEL = TOOL_QUALITY_DEFAULT))

/obj/item/sutures
	name = "sutures"
	desc = "Surgical needles and thread in a handy sterile package."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	origin_tech = @'{"materials":1,"biotech":3}'
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	_base_attack_force = 1

/obj/item/sutures/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SUTURES = TOOL_QUALITY_DEFAULT))

/obj/item/bonesetter
	name = "bone setter"
	desc = "A surgical tool for manipulating and setting bones."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
	pickup_sound = 'sound/foley/pickup2.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	_base_attack_force = 8.0

/obj/item/bonesetter/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_BONE_SETTER = TOOL_QUALITY_DEFAULT))
