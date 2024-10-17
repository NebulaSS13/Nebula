/proc/blood_splatter(atom/target, atom/source, var/large = FALSE, var/spray_dir)

	var/obj/effect/decal/cleanable/blood/splatter
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/bleed_turf = get_turf(target)

	// Are we dripping or splattering?
	var/list/drips
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in bleed_turf)
		LAZYDISTINCTADD(drips, drop.drips)
		qdel(drop)
	if(!large && LAZYLEN(drips) < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	if(bleed_turf)
		var/list/existing = filter_list(bleed_turf.contents, decal_type)
		if(length(existing) > 3)
			splatter = pick(existing)
	if(!splatter)
		splatter = new decal_type(bleed_turf)

	if(QDELETED(splatter))
		return

	var/obj/effect/decal/cleanable/blood/drip/drop = splatter
	if(istype(drop) && LAZYLEN(drips) && !large)
		drop.drips |= drips
		drop.update_icon()

	// If there's no data to copy, call it quits here.
	var/blood_data
	var/blood_type
	if(isliving(source))
		var/mob/living/donor = source
		blood_data = donor.get_blood_data()
		blood_type = donor.get_blood_type()
	else if(isatom(source))
		var/atom/donor = source
		blood_data = REAGENT_DATA(donor.reagents, /decl/material/liquid/blood)
	if(!islist(blood_data))
		return splatter

	if(spray_dir)
		splatter.icon_state = "squirt"
		splatter.set_dir(spray_dir)

	// Update blood information.
	if(LAZYACCESS(blood_data, DATA_BLOOD_DNA))
		LAZYSET(splatter.blood_data, blood_data[DATA_BLOOD_DNA], blood_data)
		splatter.blood_DNA = list()
		if(LAZYACCESS(blood_data, DATA_BLOOD_TYPE))
			splatter.blood_DNA[blood_data[DATA_BLOOD_DNA]] = blood_data[DATA_BLOOD_TYPE]
		else
			splatter.blood_DNA[blood_data[DATA_BLOOD_DNA]] = "O+"
		var/datum/extension/forensic_evidence/forensics = get_or_create_extension(splatter, /datum/extension/forensic_evidence)
		forensics.add_data(/datum/forensics/blood_dna, blood_data[DATA_BLOOD_DNA])

	if(!blood_type && LAZYACCESS(blood_data, DATA_BLOOD_TYPE))
		blood_type = LAZYACCESS(blood_data, DATA_BLOOD_TYPE)

	// Update appearance.
	if(blood_type)
		var/decl/blood_type/blood_type_decl = get_blood_type_by_name(blood_type)
		splatter.name =      blood_type_decl.splatter_name
		splatter.desc =      blood_type_decl.splatter_desc
		splatter.basecolor = blood_type_decl.splatter_colour

	if(LAZYACCESS(blood_data, DATA_BLOOD_COLOR))
		splatter.basecolor = blood_data[DATA_BLOOD_COLOR]

	splatter.update_icon()
	splatter.fluorescent = FALSE
	splatter.set_invisibility(INVISIBILITY_NONE)
	return splatter
