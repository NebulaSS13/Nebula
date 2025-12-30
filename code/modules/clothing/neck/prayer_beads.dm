/obj/item/clothing/neck/prayer_beads
	name = "prayer beads"
	desc = "A string of smooth, polished beads."
	icon = 'icons/clothing/accessories/jewelry/prayer_beads.dmi'
	gender = PLURAL
	material = /decl/material/solid/organic/wood/ebony
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/clothing/neck/prayer_beads/gold
	material = /decl/material/solid/metal/gold

/obj/item/clothing/neck/prayer_beads/basalt
	material = /decl/material/solid/stone/basalt

/obj/item/clothing/neck/prayer_beads/bone
	material = /decl/material/solid/organic/bone

/obj/item/clothing/neck/prayer_beads/random
	var/list/random_materials = list(
		/decl/material/solid/organic/bone,
		/decl/material/solid/stone/marble,
		/decl/material/solid/stone/basalt,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/ebony
	)

/obj/item/clothing/neck/prayer_beads/random/Initialize()
	material = pick(random_materials)
	return ..()
