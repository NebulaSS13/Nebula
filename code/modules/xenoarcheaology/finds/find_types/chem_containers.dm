/decl/archaeological_find/bowl
	item_type = "bowl"
	modification_flags = XENOFIND_APPLY_PREFIX | XENOFIND_APPLY_DECOR | XENOFIND_REPLACE_ICON
	engraving_chance = 100
	possible_types = list(
		/obj/item/chems/glass/replenishing,
		/obj/item/chems/glass/beaker = 2
		)
	new_icon_state = "bowl"

/decl/archaeological_find/bowl/get_additional_description()
	if(prob(20))
		return "There appear to be [pick("dark","faintly glowing","pungent","bright")] [pick("red","purple","green","blue")] stains inside."

/decl/archaeological_find/bowl/urn
	item_type = "urn"
	new_icon_state = "urn"

/decl/archaeological_find/bowl/urn/get_additional_description()
	if(prob(20))
		return "It [pick("whispers faintly","makes a quiet roaring sound","whistles softly","thrums quietly","throbs")] if you put it to your ear."

//endless reagents!

/obj/item/chems/glass/replenishing
	var/spawning_id

/obj/item/chems/glass/replenishing/Initialize()
	. = ..()
	spawning_id = pick(
		/decl/material/liquid/blood,     \
		/decl/material/liquid/lube,      \
		/decl/material/liquid/sedatives, \
		/decl/material/liquid/ethanol,   \
		/decl/material/liquid/water,   \
		/decl/material/solid/ice,  \
		/decl/material/liquid/fuel,      \
		/decl/material/liquid/cleaner    \
	)
	START_PROCESSING(SSobj, src)

/obj/item/chems/glass/replenishing/Process()
	reagents.add_reagent(spawning_id, 0.3)