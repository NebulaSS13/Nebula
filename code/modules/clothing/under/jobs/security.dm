/obj/item/clothing/under/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon = 'icons/clothing/under/uniform_dispatch.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)

/obj/item/clothing/under/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/clothing/under/uniform_redshirt.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)
