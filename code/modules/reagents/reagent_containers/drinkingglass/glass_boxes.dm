////////////////////////////////////////////////////////////////////
// Box of Mixed Glasses
////////////////////////////////////////////////////////////////////
/obj/item/storage/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware"
	can_hold = list(/obj/item/chems/drinks/glass2)

/obj/item/storage/box/mixedglasses/WillContain()
	return list(
		/obj/item/chems/drinks/glass2/square,
		/obj/item/chems/drinks/glass2/rocks,
		/obj/item/chems/drinks/glass2/shake,
		/obj/item/chems/drinks/glass2/cocktail,
		/obj/item/chems/drinks/glass2/shot,
		/obj/item/chems/drinks/glass2/pint,
		/obj/item/chems/drinks/glass2/mug,
		/obj/item/chems/drinks/glass2/wine
	)

/obj/item/storage/box/mixedglasses/Initialize(ml, material_key)
	. = ..()
	if(length(contents))
		make_exact_fit()

////////////////////////////////////////////////////////////////////
// Box of Glasses
////////////////////////////////////////////////////////////////////
/obj/item/storage/box/glasses
	name          = "box of glasses"
	can_hold      = list(/obj/item/chems/drinks/glass2)
	storage_slots = 7
	abstract_type = /obj/item/storage/box/glasses

/obj/item/storage/box/glasses/Initialize(ml, material_key)
	. = ..()
	//Name the box accordingly
	setup_name()
	if(length(contents))
		make_exact_fit()

///Looks at the contents of the box and name if after the first thing it finds inside
/obj/item/storage/box/glasses/proc/setup_name()
	if(length(contents))
		var/atom/movable/O = contents[1]
		SetName("box of [text_make_plural(O.name)]")

/obj/item/storage/box/glasses/square/WillContain()
	return list(/obj/item/chems/drinks/glass2/square = storage_slots)

/obj/item/storage/box/glasses/rocks/WillContain()
	return list(/obj/item/chems/drinks/glass2/rocks = storage_slots)

/obj/item/storage/box/glasses/shake/WillContain()
	return list(/obj/item/chems/drinks/glass2/shake = storage_slots)

/obj/item/storage/box/glasses/cocktail/WillContain()
	return list(/obj/item/chems/drinks/glass2/cocktail = storage_slots)

/obj/item/storage/box/glasses/shot/WillContain()
	return list(/obj/item/chems/drinks/glass2/shot = storage_slots)

/obj/item/storage/box/glasses/pint/WillContain()
	return list(/obj/item/chems/drinks/glass2/pint = storage_slots)

/obj/item/storage/box/glasses/mug/WillContain()
	return list(/obj/item/chems/drinks/glass2/mug = storage_slots)

/obj/item/storage/box/glasses/wine/WillContain()
	return list(/obj/item/chems/drinks/glass2/wine = storage_slots)

////////////////////////////////////////////////////////////////////
// Extras
////////////////////////////////////////////////////////////////////
/obj/item/storage/box/glass_extras
	name = "box of cocktail garnishings"
	can_hold = list(/obj/item/glass_extra)
	storage_slots = 14

/obj/item/storage/box/glass_extras/Initialize(ml, material_key)
	. = ..()
	setup_name()
	if(length(contents))
		make_exact_fit()

/obj/item/storage/box/glass_extras/proc/setup_name()
	if(length(contents))
		var/atom/movable/O = contents[1]
		SetName("box of [text_make_plural(O.name)]")

/obj/item/storage/box/glass_extras/straws/WillContain()
	return list(/obj/item/glass_extra/straw = storage_slots)

/obj/item/storage/box/glass_extras/sticks/WillContain()
	return list(/obj/item/glass_extra/stick = storage_slots)
