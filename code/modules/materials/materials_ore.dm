/obj/item/ore
	name = "ore"
	icon_state = "lump"
	icon = 'icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = ITEM_SIZE_SMALL

/obj/item/ore/Initialize(ml, material_key)
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material)
		name =       material.ore_name ? material.ore_name : "[material.name] chunk"
		desc =       material.ore_desc ? material.ore_desc : "A lump of ore."
		color =      material.color
		icon_state = material.ore_icon_overlay ? material.ore_icon_overlay : "lump"
		if(icon_state == "dust")
			slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.check_has_eyes() && prob(85))
			H << "<span class='danger'>Some of \the [src] gets in your eyes!</span>"
			ADJ_STATUS(H, STAT_BLIND, 5)
			ADJ_STATUS(H, STAT_BLURRY, 10)
			QDEL_IN(src, 1)

/obj/item/ore/explosion_act(var/severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1 && prob(25))
		qdel(src)

// Map definitions.
/obj/item/ore/uranium
	material_composition = list(/decl/material/solid/mineral/pitchblende = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/iron
	material_composition = list(/decl/material/solid/mineral/hematite = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/coal
	material_composition = list(/decl/material/solid/mineral/graphite = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/glass
	material_composition = list(/decl/material/solid/mineral/sand = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/silver
	material_composition = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/gold
	material_composition = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/diamond
	material_composition = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/osmium
	material_composition = list(/decl/material/solid/metal/platinum = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/hydrogen
	material_composition = list(/decl/material/solid/metallic_hydrogen = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/slag
	material_composition = list(/decl/material/solid/slag = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/phosphorite
	material_composition = list(/decl/material/solid/mineral/phosphorite = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/aluminium
	material_composition = list(/decl/material/solid/mineral/bauxite = MATTER_AMOUNT_PRIMARY)
/obj/item/ore/rutile
	material_composition = list(/decl/material/solid/mineral/rutile = MATTER_AMOUNT_PRIMARY)
