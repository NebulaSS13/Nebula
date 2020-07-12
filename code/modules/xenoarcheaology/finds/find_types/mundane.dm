
// Radio beacon
/decl/archaeological_find/beacon
	item_type = "device"
	possible_types = list(/obj/item/radio/beacon)
	modification_flags = XENOFIND_APPLY_PREFIX | XENOFIND_APPLY_DECOR

// Cutlery
/decl/archaeological_find/cutlery
	item_type = "cutlery"
	possible_types = list(
		/obj/item/kitchen/utensil/fork,
		/obj/item/knife/table,
		/obj/item/kitchen/utensil/spoon
	)

/decl/archaeological_find/cutlery/new_icon_state()
	return "cutlery[rand(1,3)]"

/decl/archaeological_find/cutlery/get_additional_description()
	return pick(
		"It's like no [item_type] you've ever seen before.",
		"It's a mystery how anyone is supposed to eat with this.",
		"You wonder what the creator's mouth was shaped like.")
		
// Coin
/decl/archaeological_find/coin
	item_type = "coin"
	modification_flags = XENOFIND_REPLACE_ICON
	engraving_chance = 100
	responsive_reagent = /decl/material/solid/metal/iron
	possible_types = list(/obj/item/coin)

/decl/archaeological_find/coin/new_icon_state()
	return "coin[rand(1,3)]"

// Musical Instrument
/decl/archaeological_find/instrument
	item_type = "instrument"
	possible_types = list(/obj/item/synthesized_instrument/synthesizer)
	new_icon_state = "instrument"

/decl/archaeological_find/instrument/get_additional_description()
	if(prob(30))
		return pick(
			"You're not sure how anyone could have played this.",
			"You wonder how many mouths the creator had.",
			"You wonder what it sounds like.",
			"You wonder what kind of music was made with it.")

//Gas tank
/decl/archaeological_find/tank
	item_type = "tank"
	possible_types = list(/obj/item/tank)

/decl/archaeological_find/tank/spawn_item(atom/loc)
	var/obj/item/tank/new_item = ..()
	new_item.air_contents.gas.Cut()
	new_item.air_contents.adjust_gas(pick(subtypesof(/decl/material/gas)),15)
	return new_item

/decl/archaeological_find/tank/generate_name()
	return pick("cylinder","tank","chamber")

/decl/archaeological_find/tank/get_additional_description()
	return "It [pick("gloops","sloshes")] slightly when you shake it."

//Random tool
/decl/archaeological_find/tool
	item_type = "tool"
	responsive_reagent = /decl/material/solid/metal/iron
	possible_types = list(
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/screwdriver
		)

/decl/archaeological_find/tool/get_additional_description()
	return pick(
		"It doesn't look safe.",
		"You wonder what it was used for.",
		"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains on it.")

//Crystal
/decl/archaeological_find/crystal
	item_type = "crystal"
	modification_flags = XENOFIND_REPLACE_ICON
	engraving_chance = 100
	responsive_reagent = /decl/material/gas/ammonia

/decl/archaeological_find/crystal/new_icon_state()
	if(prob(25))
		return "Green lump"
	else if(prob(33))
		return "Phazon"
	else
		return "changerock"

/decl/archaeological_find/crystal/get_additional_description()
	return pick(
		"It shines faintly as it catches the light.",
		"It appears to have a faint inner glow.",
		"It seems to draw you inward as you look it at.",
		"Something twinkles faintly as you look at it.",
		"It's mesmerizing to behold.")
