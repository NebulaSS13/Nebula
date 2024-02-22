////////////////////////////////////////////////////////////////////
// Box of Mixed Glasses
////////////////////////////////////////////////////////////////////
/obj/item/storage/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware"
	storage_type = /datum/extension/storage/box/glasses

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
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	if(length(contents) && storage)
		storage.make_exact_fit()

////////////////////////////////////////////////////////////////////
// Box of Glasses
////////////////////////////////////////////////////////////////////
/obj/item/storage/box/glasses
	name          = "box of glasses"
	abstract_type = /obj/item/storage/box/glasses
	storage_type  = /datum/extension/storage/box/glasses

/obj/item/storage/box/glasses/Initialize(ml, material_key)
	. = ..()
	//Name the box accordingly
	setup_name()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	if(length(contents) && storage)
		storage.make_exact_fit()

///Looks at the contents of the box and name if after the first thing it finds inside
/obj/item/storage/box/glasses/proc/setup_name()
	if(length(contents))
		var/atom/movable/O = contents[1]
		SetName("box of [text_make_plural(O.name)]")

/obj/item/storage/box/glasses/square/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/square = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/rocks/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/rocks = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/shake/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/shake = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/cocktail/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/cocktail = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/shot/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/shot = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/pint/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/pint = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/mug/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/mug = max(1, storage?.storage_slots))

/obj/item/storage/box/glasses/wine/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/chems/drinks/glass2/wine = max(1, storage?.storage_slots))

////////////////////////////////////////////////////////////////////
// Extras
////////////////////////////////////////////////////////////////////
/obj/item/storage/box/glass_extras
	name = "box of cocktail garnishings"
	storage_type = /datum/extension/storage/box/glass_extras

/obj/item/storage/box/glass_extras/Initialize(ml, material_key)
	. = ..()
	setup_name()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	if(length(contents) && storage)
		storage.make_exact_fit()

/obj/item/storage/box/glass_extras/proc/setup_name()
	if(length(contents))
		var/atom/movable/O = contents[1]
		SetName("box of [text_make_plural(O.name)]")

/obj/item/storage/box/glass_extras/straws/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/glass_extra/straw = max(1, storage?.storage_slots))

/obj/item/storage/box/glass_extras/sticks/WillContain()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	return list(/obj/item/glass_extra/stick = max(1, storage?.storage_slots))
