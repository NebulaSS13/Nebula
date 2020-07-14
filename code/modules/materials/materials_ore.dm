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
		color =      material.color
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

/obj/item/ore/explosion_act(var/severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1 && prob(25))
		qdel(src)

// Map definitions.
/obj/item/ore/uranium
	material = /decl/material/solid/mineral/pitchblende
/obj/item/ore/iron
	material = /decl/material/solid/mineral/hematite
/obj/item/ore/coal
	material = /decl/material/solid/mineral/graphite
/obj/item/ore/glass
	material = /decl/material/solid/mineral/sand
/obj/item/ore/silver
	material = /decl/material/solid/metal/silver
/obj/item/ore/gold
	material = /decl/material/solid/metal/gold
/obj/item/ore/diamond
	material = /decl/material/solid/gemstone/diamond
/obj/item/ore/osmium
	material = /decl/material/solid/metal/platinum
/obj/item/ore/hydrogen
	material = /decl/material/solid/metallic_hydrogen
/obj/item/ore/slag
	material = /decl/material/solid/slag
/obj/item/ore/phosphorite
	material = /decl/material/solid/mineral/phosphorite
/obj/item/ore/aluminium
	material = /decl/material/solid/mineral/bauxite
/obj/item/ore/rutile
	material = /decl/material/solid/mineral/rutile
