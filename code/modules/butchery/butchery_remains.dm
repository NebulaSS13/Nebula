/obj/item/bone
	icon = 'icons/obj/items/bones.dmi'
	material = /decl/material/solid/organic/bone
	abstract_type = /obj/item/bone

/obj/item/bone/skull
	name = "skull"
	desc = "Looks like someone lost their head."
	icon_state = "skull"

/obj/item/bone/skull/deer
	name = "deer skull"
	icon_state = "deer_skull"

/obj/item/bone/arm
	name = "arm bone"
	desc = "Wielding this, you're armed and dangerous, no bones about it."
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "bonked", "boned", "slapped", "punched")
	icon_state = "arm"

/obj/item/bone/leg
	name = "leg bone"
	desc = "Don't worry about getting into an argument with the owner of this. They don't have a leg to stand on."
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "bonked", "boned", "kicked")
	icon_state = "leg"

/obj/item/bone/ribs
	name = "ribcage"
	desc = "If you had some mallets, you could probably use this as a makeshift xylophone."
	icon_state = "ribs"

/obj/item/bone/skull/unknown
	desc = "A skull. You're not sure what species it might be, though."
	icon_state = "xenoskull"
