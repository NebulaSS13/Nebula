/obj/item/food/butchery
	abstract_type       = /obj/item/food/butchery
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/meat
	w_class             = ITEM_SIZE_LARGE
	volume              = 20
	nutriment_type      = /decl/material/solid/organic/meat
	nutriment_desc      = list("umami" = 10)
	nutriment_amt       = 20
	slice_path          = null
	slice_num           = null
	max_health          = 180
	cooked_food         = FOOD_RAW
	ingredient_flags    = INGREDIENT_FLAG_MEAT
	var/fat_material    = /decl/material/solid/organic/meat/gut
	var/meat_name       = "meat"

/obj/item/food/butchery/Initialize(ml, material_key, mob/living/donor)
	var/decl/butchery_data/butchery_decl = GET_DECL(donor?.butchery_data)
	if(butchery_decl)
		if(butchery_decl.meat_material)
			material = butchery_decl.meat_material
		fat_material = butchery_decl.gut_material
		if(isnull(slice_path))
			slice_path = butchery_decl.meat_type
		if(isnull(slice_num))
			slice_num = butchery_decl.meat_amount
		ingredient_flags = butchery_decl.meat_flags
	. = ..()
	if(istype(donor))
		meat_name = donor.get_butchery_product_name()
	if(meat_name)
		set_meat_name(meat_name)

/obj/item/food/butchery/on_update_icon()
	..()
	underlays = null
	icon_state = get_world_inventory_state()
	if(fat_material && check_state_in_icon("[icon_state]-fat", icon))
		var/decl/material/fat = GET_DECL(fat_material)
		add_overlay(overlay_image(icon, "[icon_state]-fat", fat.color, RESET_COLOR))

/obj/item/food/butchery/proc/set_meat_name(new_meat_name)
	meat_name = new_meat_name
	if(cooked_food == FOOD_RAW)
		SetName("raw [meat_name] [initial(name)]")
	else
		SetName("[meat_name] [initial(name)]")

/obj/item/food/butchery/get_grilled_product()
	. = ..()
	if(. && istype(., /obj/item/food))
		var/obj/item/food/food = .
		food.cooked_food = FOOD_COOKED
		food.ingredient_flags = ingredient_flags
		if(meat_name && istype(., /obj/item/food/butchery))
			var/obj/item/food/butchery/meat = .
			meat.set_meat_name(meat_name)

/obj/item/food/butchery/get_dried_product()
	. = ..()
	if(. && istype(., /obj/item/food))
		var/obj/item/food/food = .
		food.cooked_food = FOOD_COOKED
		food.ingredient_flags = ingredient_flags
		if(meat_name)
			if(istype(., /obj/item/food/butchery))
				var/obj/item/food/butchery/meat = .
				meat.set_meat_name(meat_name)
			else if(istype(., /obj/item/food/jerky))
				var/obj/item/food/jerky/jerk = .
				jerk.set_meat_name(meat_name)

/obj/item/food/butchery/handle_utensil_cutting(obj/item/tool, mob/user)
	. = ..()
	if(length(.))
		for(var/obj/item/food/food in .)
			food.cooked_food = cooked_food
			food.ingredient_flags = ingredient_flags
		if(meat_name)
			for(var/obj/item/food/butchery/meat in .)
				meat.set_meat_name(meat_name)

/obj/item/food/butchery/offal
	name                = "offal"
	desc                = "An assortmant of organs and lumps of unidentified gristle. Packed with nutrients and bile."
	icon                = 'icons/obj/items/butchery/offal.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 15
	slice_path          = /obj/item/food/butchery/offal/small
	slice_num           = 4
	var/_cleaned        = FALSE
	var/work_skill      = SKILL_CONSTRUCTION

/obj/item/food/butchery/offal/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && user.skill_check(work_skill, SKILL_BASIC))
		if(_cleaned && drying_wetness)
			to_chat(user, "\The [src] can be hung on a drying rack to dry it in preparation for being twisted into thread.")
		else if(!_cleaned)
			to_chat(user, "\The [src] can be scraped clean with a sharp object like a knife.")
		else if(!drying_wetness)
			to_chat(user, "\The [src] can be soaked in water to prepare it for drying.")

/obj/item/food/butchery/offal/attackby(obj/item/W, mob/user)
	if(IS_KNIFE(W) && !_cleaned)
		if(W.do_tool_interaction(TOOL_KNIFE, user, src, 3 SECONDS, "scraping", "scraping", check_skill = work_skill, set_cooldown = TRUE) && !_cleaned)
			_cleaned = TRUE
			SetName("cleaned [name]")
		return TRUE
	return ..()

/obj/item/food/butchery/offal/is_dryable()
	return _cleaned && ..()

/obj/item/food/butchery/offal/handle_utensil_cutting(obj/item/tool, mob/user)
	. = ..()
	for(var/obj/item/food/butchery/offal/guts in .)
		if(dry && !guts.dry)
			guts.dry = TRUE
			guts.SetName("dried [guts.name]")
		else if(_cleaned && !guts._cleaned)
			guts._cleaned = TRUE
			guts.SetName("cleaned [guts.name]")

/obj/item/food/butchery/offal/fluid_act(var/datum/reagents/fluids)
	. = ..()
	if(!QDELETED(src) && fluids?.total_volume && material?.tans_to)
		if(!dried_type)
			dried_type = type
		drying_wetness = get_max_drying_wetness()

/obj/item/food/butchery/offal/get_max_drying_wetness()
	return 120

/obj/item/food/butchery/offal/get_dried_product()
	if(dried_type == type && material)
		var/obj/item/food/dried = new dried_type(loc, (material.tans_to || material.type))
		if(istype(dried))
			dried.dry = TRUE
			dried.SetName("dried [dried.name]")
		return dried
	return ..()

/obj/item/food/butchery/offal/small
	icon                = 'icons/obj/items/butchery/offal_small.dmi'
	nutriment_amt       = 5
	w_class             = ITEM_SIZE_SMALL
	slice_path          = null
	slice_num           = null

/obj/item/food/butchery/haunch
	name                = "haunch"
	desc                = "A severed leg of some unfortunate beast, cleaned and ready for cooking."
	icon                = 'icons/obj/items/butchery/haunch.dmi'
	slice_num           = 2
	slice_path          = /obj/item/food/butchery/meat
	w_class             = ITEM_SIZE_HUGE
	var/bone_material   = /decl/material/solid/organic/bone

/obj/item/food/butchery/haunch/Initialize(ml, material_key, mob/living/donor)
	var/decl/butchery_data/butchery_decl = GET_DECL(donor?.butchery_data)
	if(butchery_decl)
		bone_material = butchery_decl.bone_material
	if(bone_material)
		LAZYSET(matter, bone_material, MATTER_AMOUNT_REINFORCEMENT)
	. = ..()

/obj/item/food/butchery/haunch/on_update_icon()
	..()

	if(bone_material && check_state_in_icon("[icon_state]-bone", icon))
		var/decl/material/bones = GET_DECL(bone_material)
		add_overlay(overlay_image(icon, "[icon_state]-bone", bones.color, RESET_COLOR))

	if(fat_material && check_state_in_icon("[icon_state]-fat", icon))
		var/decl/material/fat = GET_DECL(fat_material)
		add_overlay(overlay_image(icon, "[icon_state]-fat", fat.color, RESET_COLOR))

/obj/item/food/butchery/haunch/shoulder
	name                = "shoulder"

/obj/item/food/butchery/haunch/side
	name                = "side of meat"
	desc                = "Approximately half the torso and body of an unfortunate animal, split lengthways, cleaned, and ready for cooking."
	icon                = 'icons/obj/items/butchery/side.dmi'
	w_class             = ITEM_SIZE_GARGANTUAN

/obj/item/food/butchery/haunch/side/Initialize(ml, material_key, mob/living/donor)
	. = ..()
	if(donor && !isnull(slice_num))
		slice_num = max(1, round(slice_num/2))

/obj/item/food/butchery/haunch/side/set_meat_name(new_meat_name)
	meat_name = new_meat_name
	SetName("side of [new_meat_name]")

/obj/item/food/butchery/stomach
	name                = "stomach"
	desc                = "The stomach of a large animal. It would probably make a decent waterskin if properly treated."
	icon                = 'icons/obj/items/butchery/ruminant_stomach.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 8
	dried_type          = /obj/item/chems/waterskin
	var/stomach_reagent = /decl/material/liquid/acid/stomach

/obj/item/food/butchery/stomach/get_dried_product()
	var/obj/item/chems/waterskin/result = ..()
	if(istype(result) && reagents?.total_volume)
		reagents.trans_to_holder(result.reagents, reagents.total_volume)
	return result

/obj/item/food/butchery/stomach/get_max_drying_wetness()
	return 80

/obj/item/food/butchery/stomach/populate_reagents()
	..()
	add_to_reagents(stomach_reagent, 12)

/obj/item/food/butchery/stomach/ruminant
	desc                = "A secondary stomach from an unfortunate cow, or some other ruminant. A good source of rennet."
	stomach_reagent     = /decl/material/liquid/enzyme/rennet
