/obj/item/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = 2
	var/datum/geosample/geologic_data

/obj/item/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/obj/item/ore/set_material(var/new_material)
	. = ..()
	if(istype(material))
		matter = list()
		matter[material.name] = SHEET_MATERIAL_AMOUNT
		name =       material.ore_name
		desc =       material.ore_desc ? material.ore_desc : "A lump of ore."
		color =      material.icon_colour
		icon_state = material.ore_icon_overlay
		if(material.ore_desc)
			desc = material.ore_desc
		if(icon_state == "dust")
			slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.has_eyes() && prob(85))
			H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
			H.eye_blind += 5
			H.eye_blurry += 10
			QDEL_IN(src, 1)

// Map definitions.
/obj/item/ore/uranium
	material = MATERIAL_PITCHBLENDE
/obj/item/ore/iron
	material = MATERIAL_HEMATITE
/obj/item/ore/coal
	material = MATERIAL_GRAPHITE
/obj/item/ore/glass
	material = MATERIAL_SAND
/obj/item/ore/silver
	material = MATERIAL_SILVER
/obj/item/ore/gold
	material = MATERIAL_GOLD
/obj/item/ore/diamond
	material = MATERIAL_DIAMOND
/obj/item/ore/osmium
	material = MATERIAL_PLATINUM
/obj/item/ore/hydrogen
	material = MATERIAL_HYDROGEN
/obj/item/ore/slag
	material = MATERIAL_WASTE
/obj/item/ore/phoron
	material = MATERIAL_PHORON
/obj/item/ore/aluminium
	material = MATERIAL_BAUXITE
/obj/item/ore/rutile
	material = MATERIAL_RUTILE
