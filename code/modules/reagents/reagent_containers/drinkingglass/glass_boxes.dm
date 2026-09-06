////////////////////////////////////////////////////////////////////
// Box of Mixed Glasses
////////////////////////////////////////////////////////////////////
/obj/item/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware"
	storage = /datum/storage/box/glasses

/obj/item/box/mixedglasses/WillContain()
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

/obj/item/box/mixedglasses/Initialize(ml, material_key)
	. = ..()
	if(length(contents) && storage)
		storage.make_exact_fit()

////////////////////////////////////////////////////////////////////
// Box of Glasses
////////////////////////////////////////////////////////////////////
/obj/item/box/glasses
	name          = "box of glasses"
	abstract_type = /obj/item/box/glasses
	storage       = /datum/storage/box/glasses

/obj/item/box/glasses/Initialize(ml, material_key)
	. = ..()
	//Name the box accordingly
	setup_name()
	if(length(contents) && storage)
		storage.make_exact_fit()

///Looks at the contents of the box and name if after the first thing it finds inside
/obj/item/box/glasses/proc/setup_name()
	if(length(contents))
		var/atom/movable/O = contents[1]
		SetName("box of [text_make_plural(O.name)]")

/obj/item/box/glasses/square/WillContain()
	return list(/obj/item/chems/drinks/glass2/square = max(1, storage?.storage_slots))

/obj/item/box/glasses/rocks/WillContain()
	return list(/obj/item/chems/drinks/glass2/rocks = max(1, storage?.storage_slots))

/obj/item/box/glasses/shake/WillContain()
	return list(/obj/item/chems/drinks/glass2/shake = max(1, storage?.storage_slots))

/obj/item/box/glasses/cocktail/WillContain()
	return list(/obj/item/chems/drinks/glass2/cocktail = max(1, storage?.storage_slots))

/obj/item/box/glasses/shot/WillContain()
	return list(/obj/item/chems/drinks/glass2/shot = max(1, storage?.storage_slots))

/obj/item/box/glasses/pint/WillContain()
	return list(/obj/item/chems/drinks/glass2/pint = max(1, storage?.storage_slots))

/obj/item/box/glasses/mug/WillContain()
	return list(/obj/item/chems/drinks/glass2/mug = max(1, storage?.storage_slots))

/obj/item/box/glasses/coffeecup/WillContain()
	return list(/obj/item/chems/drinks/glass2/coffeecup = max(1, storage?.storage_slots))

/obj/item/box/glasses/teacup/WillContain()
	return list(/obj/item/chems/drinks/glass2/coffeecup/teacup = max(1, storage?.storage_slots))

/obj/item/box/glasses/wine/WillContain()
	return list(/obj/item/chems/drinks/glass2/wine = max(1, storage?.storage_slots))

////////////////////////////////////////////////////////////////////
// Extras
////////////////////////////////////////////////////////////////////
/obj/item/box/glass_extras
	name = "box of cocktail garnishings"
	storage = /datum/storage/box/glass_extras

/obj/item/box/glass_extras/Initialize(ml, material_key)
	. = ..()
	setup_name()
	if(length(contents) && storage)
		storage.make_exact_fit()

/obj/item/box/glass_extras/proc/setup_name()
	if(length(contents))
		var/atom/movable/O = contents[1]
		SetName("box of [text_make_plural(O.name)]")

/obj/item/box/glass_extras/straws/WillContain()
	return list(/obj/item/glass_extra/straw = max(1, storage?.storage_slots))

/obj/item/box/glass_extras/sticks/WillContain()
	return list(/obj/item/glass_extra/stick = max(1, storage?.storage_slots))
