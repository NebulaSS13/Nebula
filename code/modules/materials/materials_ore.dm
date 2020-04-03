/obj/item/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = ITEM_SIZE_SMALL

/obj/item/ore/set_material(var/new_material)
	. = ..()
	if(istype(material))
		matter = list()
		matter[material.type] = SHEET_MATERIAL_AMOUNT
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
		if(istype(H) && H.check_has_eyes() && prob(85))
			H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
			H.eye_blind += 5
			H.eye_blurry += 10
			QDEL_IN(src, 1)

// Map definitions.
/obj/item/ore/uranium
	material = MAT_PITCHBLENDE
/obj/item/ore/iron
	material = MAT_HEMATITE
/obj/item/ore/coal
	material = MAT_GRAPHITE
/obj/item/ore/glass
	material = MAT_SAND
/obj/item/ore/silver
	material = MAT_SILVER
/obj/item/ore/gold
	material = MAT_GOLD
/obj/item/ore/diamond
	material = MAT_DIAMOND
/obj/item/ore/osmium
	material = MAT_PLATINUM
/obj/item/ore/hydrogen
	material = MAT_METALLIC_HYDROGEN
/obj/item/ore/slag
	material = MAT_WASTE
/obj/item/ore/phoron
	material = MAT_PHORON
/obj/item/ore/aluminium
	material = MAT_BAUXITE
/obj/item/ore/rutile
	material = MAT_RUTILE
