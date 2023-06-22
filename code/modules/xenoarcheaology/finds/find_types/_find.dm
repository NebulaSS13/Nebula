var/global/list/responsive_carriers = list(
	/decl/material/solid/carbon          = "Trace organic cells",
	/decl/material/solid/potassium       = "Long exposure particles",
	/decl/material/liquid/fuel/hydrazine = "Trace water particles",
	/decl/material/gas/ammonia 			 = "Crystalline structures",
	/decl/material/liquid/mercury        = "Metallic derivative",
	/decl/material/solid/metal/iron      = "Metallic composite",
	/decl/material/gas/chlorine          = "Metamorphic/igneous rock composite",
	/decl/material/solid/phosphorus      = "Metamorphic/sedimentary rock composite"
)

/decl/archaeological_find
	var/item_type = "object"
	var/modification_flags = XENOFIND_APPLY_PREFIX | XENOFIND_APPLY_DECOR | XENOFIND_REPLACE_ICON
	var/engraving_chance = 0
	var/new_icon = 'icons/obj/xenoarchaeology.dmi'
	var/new_icon_state
	var/list/name_prefixes = list("strange","ancient","alien")
	var/responsive_reagent = /decl/material/liquid/mercury
	var/list/possible_types = list(/obj/item)

/decl/archaeological_find/proc/create_find(atom/location)
	var/obj/item/I = spawn_item(location)
	var/list/descriptors = list()
	if(modification_flags & XENOFIND_APPLY_DECOR)
		descriptors += generate_material_decorations(I)

	if(prob(engraving_chance))
		descriptors += generate_engravings(I)

	var/extra_desc = get_additional_description()
	if(extra_desc)
		descriptors += extra_desc
	if(!length(descriptors))
		descriptors += "This item is completely [pick("alien","bizarre")]."

	var/new_name = generate_name()
	if(modification_flags & XENOFIND_APPLY_PREFIX)
		new_name = "[pick(name_prefixes)] [new_name]"
	I.SetName(new_name)
	if(modification_flags & XENOFIND_REPLACE_ICON)
		I.icon = new_icon()
		I.has_inventory_icon = check_state_in_icon(ICON_STATE_INV, I.icon)
		I.icon_state = new_icon_state()
	I.desc = jointext(descriptors, "\n")
	I.forceMove(location)
	I.set_material(/decl/material/solid/metal/aliumium)
	if(modification_flags & XENOFIND_APPLY_PREFIX)
		new_name = "[pick(name_prefixes)] [new_name]"
	I.SetName(new_name)
	if(prob(5))
		I.talking_atom = new(I)

	return I

/decl/archaeological_find/proc/spawn_item(atom/loc)
	var/spawn_type = pickweight(possible_types)
	return new spawn_type(loc)

/decl/archaeological_find/proc/new_icon()
	return new_icon

/decl/archaeological_find/proc/new_icon_state()
	if(new_icon_state)
		return new_icon_state
	else
		return "unknown[rand(1,4)]"

/decl/archaeological_find/proc/generate_name()
	return item_type

/decl/archaeological_find/proc/get_additional_description()
	return

/decl/archaeological_find/proc/generate_engravings(obj/item/I)
	var/datum/planetoid_data/P = SSmapping.planetoid_data_by_z[get_z(I)]
	. = "[pick("Engraved","Carved","Etched")] on the item is [pick("an image of","a frieze of","a depiction of")] "
	if(istype(P) && P.engraving_generator)
		. += P.engraving_generator.generate_engraving_text()
	else
		. += "[pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")] \
		[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
		[pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")]"
		if(prob(50))
			. += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
		. += "."

/decl/archaeological_find/proc/generate_material_decorations(obj/item/I)
	var/material_descriptor
	if(prob(40))
		material_descriptor = pick("rusted","dusty","archaic","fragile")
	var/result = "A [material_descriptor ? "[material_descriptor] " : ""][item_type] made of an alien alloy, all craftsmanship is of [pick("the lowest","low","average","high","the highest")] quality"
	var/list/descriptors = list()
	if(prob(30))
		descriptors.Add("is encrusted with [pick("","synthetic ","multi-faceted ","uncut ","sparkling ") + pick("rubies","emeralds","diamonds","opals","lapiz lazuli")]")
	if(prob(30))
		descriptors.Add("is studded with [pick("gold","silver","aluminium","titanium")]")
	if(prob(30))
		descriptors.Add("is encircled with bands of [pick("quadrinium","cordite","ferritic-alloy","plasteel","duranium")]")
	if(prob(30))
		descriptors.Add("menaces with spikes of [pick("purple crystal","uranium","white pearl","black steel")]")

	if(length(descriptors))
		result += ". It [english_list(descriptors)]."
	return result