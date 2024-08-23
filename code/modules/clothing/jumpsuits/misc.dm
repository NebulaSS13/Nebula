/obj/item/clothing/jumpsuit/rainbow
	name = "rainbow"
	icon = 'icons/clothing/jumpsuits/jumpsuit_rainbow.dmi'

/obj/item/clothing/jumpsuit/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon = 'icons/clothing/jumpsuits/jumpsuit_psychadelic.dmi'

/obj/item/clothing/jumpsuit/wetsuit
	name = "tactical wetsuit"
	desc = "For when you want to scuba dive your way into an enemy base but still want to show off a little skin."
	icon = 'icons/clothing/jumpsuits/wetsuit.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY

/obj/item/clothing/jumpsuit/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon = 'icons/clothing/jumpsuits/jumpsuit_psionic.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS

/obj/item/clothing/jumpsuit/caretaker
	name = "caretaker's jumpsuit"
	desc = "A holy jumpsuit. Treat it well."
	icon = 'icons/clothing/jumpsuits/caretaker.dmi'
	bodytype_equip_flags = BODY_FLAG_HUMANOID

/obj/item/clothing/jumpsuit/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon = 'icons/clothing/uniform_swat.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)

/*
 * Utility
*/

/obj/item/clothing/jumpsuit/utility
	name = "blue utility uniform"
	desc = "A comfortable blue utility jumpsuit."
	icon = 'icons/clothing/jumpsuits/jumpsuit_utility_blue.dmi'

/obj/item/clothing/jumpsuit/utility/grey
	name = "grey utility uniform"
	desc = "A comfortable grey utility jumpsuit."
	icon = 'icons/clothing/jumpsuits/jumpsuit_utility_grey.dmi'

/obj/item/clothing/jumpsuit/sleekoveralls
	name = "sleek overalls"
	desc = "A set of modern pleather reinforced overalls."
	icon = 'icons/clothing/jumpsuits/jumpsuit_sleekoveralls.dmi'

