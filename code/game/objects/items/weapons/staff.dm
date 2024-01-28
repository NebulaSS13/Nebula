/obj/item/staff
	name = "wizards staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3.0
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("bludgeoned", "whacked", "disciplined")
	material = /decl/material/solid/organic/wood

/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"
	material = /decl/material/solid/organic/wood
	matter = list(/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY)

/obj/item/staff/gentcane
	name = "gentleman's cane"
	desc = "An ebony can with an ivory tip."
	icon = 'icons/obj/items/cane.dmi'
	icon_state = "cane"
	item_state = "stick"
	material = /decl/material/solid/organic/wood/ebony
	matter = list(/decl/material/solid/organic/bone = MATTER_AMOUNT_TRACE) //No ivory material :c
