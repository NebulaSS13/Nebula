/obj/item/chems/food/butchery
	abstract_type       = /obj/item/chems/food/butchery
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/meat
	w_class             = ITEM_SIZE_LARGE
	volume              = 20
	nutriment_type      = /decl/material/liquid/nutriment/protein
	nutriment_amt       = 20

/obj/item/chems/food/butchery/Initialize(ml, material_key, mob/donor)
	. = ..()
	if(istype(donor))
		set_name_from(mob/donor)

/obj/item/chems/food/butchery/proc/set_name_from(mob/donor)
	SetName("[donor.name] [name]")

/obj/item/chems/food/butchery/offal
	name                = "offal"
	desc                = "An assortmant of organs and lumps of unidentified gristle. Packed with nutrients and bile."
	icon                = 'icons/obj/items/butchery/offal.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 15

/obj/item/chems/food/butchery/haunch
	name                = "haunch"
	desc                = "A severed leg of some unfortunate beast, cleaned and ready for cooking."
	icon                = 'icons/obj/items/butchery/haunch.dmi'
	w_class             = ITEM_SIZE_HUGE
	var/bone_over       = FALSE
	var/bone_material   = /decl/material/solid/organic/bone

/obj/item/chems/food/butchery/haunch/Initialize(ml, material_key, mob/donor, _bone)
	if(donor)
		bone_material = _bone // null bone is valid here
	if(bone_material)
		LAZYSET(matter, bone_material, MATTER_AMOUNT_REINFORCEMENT)
	. = ..()

/obj/item/chems/food/butchery/haunch/shoulder
	name                = "shoulder"

/obj/item/chems/food/butchery/haunch/on_update_icon()
	..()
	underlays = null
	icon_state = get_world_inventory_state()
	if(bone_material)
		var/decl/material/bones = GET_DECL(bone_material)
		var/image/bone_image = overlay_image(icon, "[icon_state]-bone", bones.color, RESET_COLOR)
		if(bone_over)
			add_overlay(bone_image)
		else
			underlays += bone_image

/obj/item/chems/food/butchery/haunch/side
	name                = "side of meat"
	desc                = "Approximately half the torso and body of an unfortunate animal, split lengthways, cleaned, and ready for cooking."
	icon                = 'icons/obj/items/butchery/side.dmi'
	bone_over           = TRUE
	w_class             = ITEM_SIZE_GARGANTUAN

/obj/item/chems/food/butchery/haunch/side/set_name_from(mob/donor)
	SetName("side of [name] meat")

/obj/item/chems/food/butchery/stomach
	name                = "stomach"
	desc                = "The stomach of a large animal. It would probably make a decent waterskin if properly treated."
	icon                = 'icons/obj/items/butchery/ruminant_stomach.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 8
	var/stomach_reagent = /decl/material/liquid/acid/stomach

/obj/item/chems/food/butchery/stomach/populate_reagents()
	..()
	add_to_reagents(stomach_reagent, 12)

/obj/item/chems/food/butchery/stomach/ruminant
	desc                = "A secondary stomach from an unfortunate cow, or some other ruminant. A good source of rennet."
	stomach_reagent     = /decl/material/liquid/enzyme/rennet
