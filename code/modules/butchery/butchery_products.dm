/obj/item/chems/food/butchery
	abstract_type       = /obj/item/chems/food/butchery
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/meat
	w_class             = ITEM_SIZE_LARGE
	volume              = 20
	nutriment_type      = /decl/material/liquid/nutriment/protein
	nutriment_amt       = 20
	slice_path          = null
	slice_num           = null
	max_health          = 180
	var/fat_material    = /decl/material/solid/organic/meat/gut

/obj/item/chems/food/butchery/Initialize(ml, material_key, mob/living/donor)
	var/decl/butchery_data/butchery_decl = GET_DECL(donor?.butchery_data)
	if(butchery_decl)
		if(butchery_decl.meat_material)
			material = butchery_decl.meat_material
		fat_material = butchery_decl.gut_material
		if(isnull(slice_path))
			slice_path = butchery_decl.meat_type
		if(isnull(slice_num))
			slice_num = butchery_decl.meat_amount
	. = ..()
	if(istype(donor))
		set_name_from(donor)

/obj/item/chems/food/butchery/on_update_icon()
	..()
	underlays = null
	icon_state = get_world_inventory_state()
	if(fat_material && check_state_in_icon("[icon_state]-fat", icon))
		var/decl/material/fat = GET_DECL(fat_material)
		add_overlay(overlay_image(icon, "[icon_state]-fat", fat.color, RESET_COLOR))

/obj/item/chems/food/butchery/proc/set_name_from(mob/living/donor)
	SetName("[donor.name] [name]")

/obj/item/chems/food/butchery/offal
	name                = "offal"
	desc                = "An assortmant of organs and lumps of unidentified gristle. Packed with nutrients and bile."
	icon                = 'icons/obj/items/butchery/offal.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 15

/obj/item/chems/food/butchery/offal/small
	icon                = 'icons/obj/items/butchery/offal_small.dmi'
	nutriment_amt       = 5

/obj/item/chems/food/butchery/haunch
	name                = "haunch"
	desc                = "A severed leg of some unfortunate beast, cleaned and ready for cooking."
	icon                = 'icons/obj/items/butchery/haunch.dmi'
	slice_num           = 2
	w_class             = ITEM_SIZE_HUGE
	var/bone_material   = /decl/material/solid/organic/bone
	var/skin_material   = /decl/material/solid/organic/skin

/obj/item/chems/food/butchery/haunch/Initialize(ml, material_key, mob/living/donor)
	var/decl/butchery_data/butchery_decl = GET_DECL(donor?.butchery_data)
	if(butchery_decl)
		bone_material = butchery_decl.bone_material
		skin_material = butchery_decl.skin_material
	if(bone_material)
		LAZYSET(matter, bone_material, MATTER_AMOUNT_REINFORCEMENT)
	. = ..()

/obj/item/chems/food/butchery/haunch/on_update_icon()
	..()

	if(bone_material && check_state_in_icon("[icon_state]-bone", icon))
		var/decl/material/bones = GET_DECL(bone_material)
		add_overlay(overlay_image(icon, "[icon_state]-bone", bones.color, RESET_COLOR))

	if(skin_material && check_state_in_icon("[icon_state]-skin", icon))
		var/decl/material/skin = GET_DECL(skin_material)
		add_overlay(overlay_image(icon, "[icon_state]-skin", skin.color, RESET_COLOR))

/obj/item/chems/food/butchery/haunch/shoulder
	name                = "shoulder"

/obj/item/chems/food/butchery/haunch/side
	name                = "side of meat"
	desc                = "Approximately half the torso and body of an unfortunate animal, split lengthways, cleaned, and ready for cooking."
	icon                = 'icons/obj/items/butchery/side.dmi'
	w_class             = ITEM_SIZE_GARGANTUAN

/obj/item/chems/food/butchery/haunch/side/Initialize(ml, material_key, mob/living/donor)
	. = ..()
	if(donor && !isnull(slice_num))
		slice_num = max(1, round(slice_num/2))

/obj/item/chems/food/butchery/haunch/side/set_name_from(mob/living/donor)
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
