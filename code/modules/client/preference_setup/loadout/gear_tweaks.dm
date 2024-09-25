#define GEAR_TWEAK_SUCCESS 1
#define GEAR_TWEAK_SKIPPED 2

/datum/gear_tweak/proc/get_contents(var/metadata)
	return

/datum/gear_tweak/proc/get_metadata(var/user, var/metadata, title)
	return

/datum/gear_tweak/proc/get_default()
	return

/datum/gear_tweak/proc/tweak_gear_data(var/metadata, var/datum/gear_data)
	return

/datum/gear_tweak/proc/tweak_item(mob/user, obj/item/gear, metadata)
	return GEAR_TWEAK_SKIPPED

/datum/gear_tweak/proc/tweak_description(var/description, var/metadata)
	return description

/*
* Color adjustment
*/

/datum/gear_tweak/color
	var/list/valid_colors

/datum/gear_tweak/color/New(var/list/valid_colors)
	src.valid_colors = valid_colors
	..()

/datum/gear_tweak/color/get_contents(var/metadata)
	return "Color: <font color='[metadata]'>&#9899;</font>"

/datum/gear_tweak/color/get_default()
	return valid_colors ? valid_colors[1] : COLOR_WHITE

/datum/gear_tweak/color/get_metadata(var/user, var/metadata, var/title = CHARACTER_PREFERENCE_INPUT_TITLE)
	if(valid_colors)
		return input(user, "Choose a color.", title, metadata) as null|anything in valid_colors
	return input(user, "Choose a color.", title, metadata) as color|null

/datum/gear_tweak/color/tweak_item(mob/user, obj/item/gear, metadata)
	if(valid_colors && !(metadata in valid_colors))
		return GEAR_TWEAK_SKIPPED
	gear.set_color(sanitize_hexcolor(metadata, gear.get_color()))
	return GEAR_TWEAK_SUCCESS

// This subtype sets the markings color for clothing.
/datum/gear_tweak/color/markings/get_contents(var/metadata)
	return "Secondary color: <font color='[metadata]'>&#9899;</font>"

/datum/gear_tweak/color/markings/tweak_item(mob/user, obj/item/clothing/clothes, metadata)
	if(valid_colors && !(metadata in valid_colors))
		return GEAR_TWEAK_SKIPPED
	clothes.markings_color = sanitize_hexcolor(metadata, clothes.markings_color)
	return GEAR_TWEAK_SUCCESS

/*
* Path adjustment
*/

/datum/gear_tweak/path
	var/list/valid_paths

/datum/gear_tweak/path/New(var/list/valid_paths)
	if(!valid_paths.len)
		CRASH("No type paths given")
	var/list/duplicate_keys = duplicates(valid_paths)
	if(duplicate_keys.len)
		CRASH("Duplicate names found: [english_list(duplicate_keys)]")
	var/list/duplicate_values = duplicates(list_values(valid_paths))
	if(duplicate_values.len)
		CRASH("Duplicate types found: [english_list(duplicate_values)]")
	// valid_paths, but with names sanitized to remove \improper
	var/list/valid_paths_san = list()
	for(var/path_name in valid_paths)
		if(!istext(path_name))
			CRASH("Expected a text key, was [log_info_line(path_name)]")
		var/selection_type = valid_paths[path_name]
		if(!ispath(selection_type, /obj/item))
			CRASH("Expected an /obj/item path, was [log_info_line(selection_type)]")
		var/path_name_san = replacetext(path_name, "\improper", "")
		valid_paths_san[path_name_san] = selection_type
	src.valid_paths = sortTim(valid_paths, /proc/cmp_text_asc)

/datum/gear_tweak/path/type/New(var/type_path)
	..(atomtype2nameassoclist(type_path))

/datum/gear_tweak/path/subtype/New(var/type_path)
	..(atomtypes2nameassoclist(subtypesof(type_path)))

/datum/gear_tweak/path/specified_types_list/New(var/type_paths)
	..(atomtypes2nameassoclist(type_paths))

/datum/gear_tweak/path/get_contents(var/metadata)
	return "Type: [metadata]"

/datum/gear_tweak/path/get_default()
	return valid_paths[1]

/datum/gear_tweak/path/get_metadata(var/user, var/metadata, title)
	return input(user, "Choose a type.", CHARACTER_PREFERENCE_INPUT_TITLE, metadata) as null|anything in valid_paths

/datum/gear_tweak/path/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	if(!(metadata in valid_paths))
		return
	gear_data.path = valid_paths[metadata]

/datum/gear_tweak/path/tweak_description(var/description, var/metadata)
	if(!(metadata in valid_paths))
		return ..()
	var/obj/O = valid_paths[metadata]
	return initial(O.desc) || description

/*
* Content adjustment
*/

/datum/gear_tweak/contents
	var/list/valid_contents

/datum/gear_tweak/contents/New()
	valid_contents = args.Copy()
	..()

/datum/gear_tweak/contents/get_contents(var/metadata)
	return "Contents: [english_list(metadata, and_text = ", ")]"

/datum/gear_tweak/contents/get_default()
	. = list()
	for(var/i = 1 to valid_contents.len)
		. += "Random"

/datum/gear_tweak/contents/get_metadata(var/user, var/list/metadata, title)
	. = list()
	for(var/i = metadata.len to (valid_contents.len - 1))
		metadata += "Random"
	for(var/i = 1 to valid_contents.len)
		var/entry = input(user, "Choose an entry.", CHARACTER_PREFERENCE_INPUT_TITLE, metadata[i]) as null|anything in (valid_contents[i] + list("Random", "None"))
		if(entry)
			. += entry
		else
			return metadata

/datum/gear_tweak/contents/tweak_item(mob/user, obj/item/gear, metadata)
	if(length(metadata) != length(valid_contents))
		return GEAR_TWEAK_SKIPPED
	for(var/i = 1 to valid_contents.len)
		var/path
		var/list/contents = valid_contents[i]
		if(metadata[i] == "Random")
			path = pick(contents)
			path = contents[path]
		else if(metadata[i] == "None")
			continue
		else
			path = 	contents[metadata[i]]
		if(path)
			new path(gear)
		else
			log_debug("Failed to tweak item: Index [i] in [json_encode(metadata)] did not result in a valid path. Valid contents: [json_encode(valid_contents)]")
	return GEAR_TWEAK_SUCCESS

/*
* Ragent adjustment
*/

/datum/gear_tweak/reagents
	var/list/valid_reagents

/datum/gear_tweak/reagents/New(var/list/reagents)
	valid_reagents = reagents.Copy()
	..()

/datum/gear_tweak/reagents/get_contents(var/metadata)
	return "Reagents: [metadata]"

/datum/gear_tweak/reagents/get_default()
	return "Random"

/datum/gear_tweak/reagents/get_metadata(var/user, var/list/metadata, title)
	. = input(user, "Choose an entry.", CHARACTER_PREFERENCE_INPUT_TITLE, metadata) as null|anything in (valid_reagents + list("Random", "None"))
	if(!.)
		return metadata

/datum/gear_tweak/reagents/tweak_item(mob/user, obj/item/gear, metadata)
	if(metadata == "None")
		return GEAR_TWEAK_SKIPPED
	var/reagent
	if(metadata == "Random")
		reagent = valid_reagents[pick(valid_reagents)]
	else
		reagent = valid_reagents[metadata]
	if(reagent && gear.reagents)
		gear.reagents?.clear_reagents() // in case we're applying to an existing item with reagents
		gear.add_to_reagents(reagent, REAGENTS_FREE_SPACE(gear.reagents))
	return GEAR_TWEAK_SUCCESS

/*
* Custom Setup
*/
/datum/gear_tweak/custom_setup
	var/custom_setup_proc
	var/additional_arguments

/datum/gear_tweak/custom_setup/New(custom_setup_proc, list/additional_arguments)
	if(additional_arguments && !istype(additional_arguments))
		CRASH("Expected a list of argument, was [log_info_line(additional_arguments)]")

	src.custom_setup_proc = custom_setup_proc
	src.additional_arguments = additional_arguments
	..()

/datum/gear_tweak/custom_setup/tweak_item(mob/user, obj/item/gear, metadata)
	var/list/arglist = list(user)
	if(length(additional_arguments))
		arglist += additional_arguments
	call(gear, custom_setup_proc)(arglist(arglist))
	arglist.Cut()
	return GEAR_TWEAK_SUCCESS

/*
* Tablet Stuff
*/

/datum/gear_tweak/tablet
	var/list/ValidProcessors = list(/obj/item/stock_parts/computer/processor_unit/small)
	var/list/ValidBatteries = list(/obj/item/stock_parts/computer/battery_module/nano, /obj/item/stock_parts/computer/battery_module/micro, /obj/item/stock_parts/computer/battery_module)
	var/list/ValidHardDrives = list(/obj/item/stock_parts/computer/hard_drive/micro, /obj/item/stock_parts/computer/hard_drive/small, /obj/item/stock_parts/computer/hard_drive)
	var/list/ValidNetworkCards = list(/obj/item/stock_parts/computer/network_card, /obj/item/stock_parts/computer/network_card/advanced)
	var/list/ValidNanoPrinters = list(null, /obj/item/stock_parts/computer/nano_printer)
	var/list/ValidCardSlots = list(null, /obj/item/stock_parts/computer/card_slot)
	var/list/ValidTeslaLinks = list(null, /obj/item/stock_parts/computer/tesla_link)

/datum/gear_tweak/tablet/get_contents(var/list/metadata)
	var/list/names = list()
	var/obj/O = null
	if (metadata.len != 7)
		return
	O = ValidProcessors[metadata[1]]
	if(O)
		names += initial(O.name)
	O = ValidBatteries[metadata[2]]
	if(O)
		names += initial(O.name)
	O = ValidHardDrives[metadata[3]]
	if(O)
		names += initial(O.name)
	O = ValidNetworkCards[metadata[4]]
	if(O)
		names += initial(O.name)
	O = ValidNanoPrinters[metadata[5]]
	if(O)
		names += initial(O.name)
	O = ValidCardSlots[metadata[6]]
	if(O)
		names += initial(O.name)
	O = ValidTeslaLinks[metadata[7]]
	if(O)
		names += initial(O.name)
	return english_list(names, and_text = ", ")

/datum/gear_tweak/tablet/get_metadata(var/mob/user, var/metadata, title)
	. = list()
	if(!istype(user))
		return

	var/list/names = list()
	var/counter = 1
	for(var/i in ValidProcessors)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	var/entry = input(user, "Choose a processor.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

	names = list()
	counter = 1
	for(var/i in ValidBatteries)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	entry = input(user, "Choose a battery.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

	names = list()
	counter = 1
	for(var/i in ValidHardDrives)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	entry = input(user, "Choose a hard drive.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

	names = list()
	counter = 1
	for(var/i in ValidNetworkCards)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	entry = input(user, "Choose a network card.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

	names = list()
	counter = 1
	for(var/i in ValidNanoPrinters)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	entry = input(user, "Choose a nanoprinter.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

	names = list()
	counter = 1
	for(var/i in ValidCardSlots)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	entry = input(user, "Choose a card slot.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

	names = list()
	counter = 1
	for(var/i in ValidTeslaLinks)
		if(i)
			var/obj/O = i
			names[initial(O.name)] = counter++
		else
			names["None"] = counter++

	if (!user || !user.client)
		return
	entry = input(user, "Choose a tesla link.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names[entry]

/datum/gear_tweak/tablet/get_default()
	. = list()
	for(var/i in 1 to TWEAKABLE_COMPUTER_PART_SLOTS)
		. += 1

/datum/gear_tweak/tablet/tweak_item(mob/user, obj/item/gear, metadata)
	if(length(metadata) < TWEAKABLE_COMPUTER_PART_SLOTS)
		return GEAR_TWEAK_SKIPPED
	var/datum/extension/assembly/modular_computer/assembly = get_extension(gear, /datum/extension/assembly)
	if(ValidProcessors[metadata[1]])
		var/t = ValidProcessors[metadata[1]]
		assembly.add_replace_component(null, PART_CPU, new t(gear))
	if(ValidBatteries[metadata[2]])
		var/t = ValidBatteries[metadata[2]]
		assembly.add_replace_component(null, PART_BATTERY, new t(gear))
	if(ValidHardDrives[metadata[3]])
		var/t = ValidHardDrives[metadata[3]]
		assembly.add_replace_component(null, PART_HDD, new t(gear))
	if(ValidNetworkCards[metadata[4]])
		var/t = ValidNetworkCards[metadata[4]]
		assembly.add_replace_component(null, PART_NETWORK, new t(gear))
	if(ValidNanoPrinters[metadata[5]])
		var/t = ValidNanoPrinters[metadata[5]]
		assembly.add_replace_component(null, PART_PRINTER, new t(gear))
	if(ValidCardSlots[metadata[6]])
		var/t = ValidCardSlots[metadata[6]]
		assembly.add_replace_component(null, PART_CARD, new t(gear))
	if(ValidTeslaLinks[metadata[7]])
		var/t = ValidTeslaLinks[metadata[7]]
		assembly.add_replace_component(null, PART_TESLA, new t(gear))
	return GEAR_TWEAK_SUCCESS

/*
* Custom name
*/

var/global/datum/gear_tweak/custom_name/gear_tweak_free_name = new()

/datum/gear_tweak/custom_name
	var/list/valid_custom_names

/datum/gear_tweak/custom_name/New(list/valid_custom_names)
	src.valid_custom_names = valid_custom_names
	..()

/datum/gear_tweak/custom_name/get_contents(metadata)
	return "Name: [metadata]"

/datum/gear_tweak/custom_name/get_default()
	return ""

/datum/gear_tweak/custom_name/get_metadata(user, metadata, title)
	if(valid_custom_names)
		return input(user, "Choose an item name.", CHARACTER_PREFERENCE_INPUT_TITLE, metadata) as null|anything in valid_custom_names
	return sanitize(input(user, "Choose the item's name. Leave it blank to use the default name.", "Item Name", metadata) as text|null, MAX_LNAME_LEN)

/datum/gear_tweak/custom_name/tweak_item(mob/user, obj/item/gear, metadata)
	if(metadata)
		gear.set_custom_name(metadata)
		return GEAR_TWEAK_SUCCESS
	return GEAR_TWEAK_SKIPPED

/*
* Custom description
*/

var/global/datum/gear_tweak/custom_desc/gear_tweak_free_desc = new()

/datum/gear_tweak/custom_desc
	var/list/valid_custom_desc

/datum/gear_tweak/custom_desc/New(list/valid_custom_desc)
	src.valid_custom_desc = valid_custom_desc
	..()

/datum/gear_tweak/custom_desc/get_contents(metadata)
	return "Description: [metadata]"

/datum/gear_tweak/custom_desc/get_default()
	return ""

/datum/gear_tweak/custom_desc/get_metadata(user, metadata, title)
	if(valid_custom_desc)
		return input(user, "Choose an item description.", CHARACTER_PREFERENCE_INPUT_TITLE, metadata) as null|anything in valid_custom_desc
	return sanitize(input(user, "Choose the item's description. Leave it blank to use the default description.", "Item Description", metadata) as message|null)

/datum/gear_tweak/custom_desc/tweak_item(mob/user, obj/item/gear, metadata)
	if(metadata)
		gear.set_custom_desc(metadata)
		return GEAR_TWEAK_SUCCESS
	return GEAR_TWEAK_SKIPPED

/*
* Material selection
*/

/datum/gear_tweak/material
	var/list/valid_materials

/datum/gear_tweak/material/New(var/list/_valid_materials)
	if(!length(_valid_materials))
		CRASH("No material paths given")
	var/list/duplicate_keys = duplicates(_valid_materials)
	if(duplicate_keys.len)
		CRASH("Duplicate material names found: [english_list(duplicate_keys)]")
	var/list/duplicate_values = duplicates(list_values(_valid_materials))
	if(duplicate_values.len)
		CRASH("Duplicate material types found: [english_list(duplicate_values)]")
	// valid_materials, but with names sanitized to remove \improper
	var/list/valid_materials_san = list()
	for(var/mat_name in _valid_materials)
		if(!istext(mat_name))
			CRASH("Expected a text key, was [log_info_line(mat_name)]")
		var/selection_type = _valid_materials[mat_name]
		if(ispath(selection_type, /decl/material/solid))
			var/decl/material/solid/mat = GET_DECL(selection_type)
			if(mat?.phase_at_temperature() != MAT_PHASE_SOLID)
				CRASH("Expected a room temperature solid, was [log_info_line(mat?.type) || "NULL"]")
		else
			CRASH("Expected a /decl/material/solid path, was [log_info_line(selection_type) || "NULL"]")
		var/mat_name_san = replacetext(mat_name, "\improper", "")
		valid_materials_san[mat_name_san] = selection_type
	valid_materials = sortTim(_valid_materials, /proc/cmp_text_asc)

/datum/gear_tweak/material/get_contents(var/metadata)
	return "Material: [metadata]"

/datum/gear_tweak/material/get_default()
	return valid_materials[1]

/datum/gear_tweak/material/get_metadata(var/user, var/metadata, title)
	return input(user, "Choose a material.", CHARACTER_PREFERENCE_INPUT_TITLE, metadata) as null|anything in valid_materials

/datum/gear_tweak/material/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	if(!(metadata in valid_materials))
		return
	gear_data.material = valid_materials[metadata]
