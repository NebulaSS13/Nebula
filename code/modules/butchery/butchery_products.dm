/obj/item/food/butchery
	abstract_type       = /obj/item/food/butchery
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/meat
	color               = /decl/material/solid/organic/meat::color
	w_class             = ITEM_SIZE_NORMAL
	chem_volume         = 20
	nutriment_type      = /decl/material/solid/organic/meat
	nutriment_desc      = list("umami" = 10)
	nutriment_amt       = 20
	slice_path          = null
	slice_num           = null
	max_health          = 180
	cooked_food         = FOOD_RAW
	var/fat_material    = /decl/material/solid/organic/meat/gut
	var/meat_name       = "meat"
	/// The initial butchery data to use (if a typepath), otherwise the butchery data of our donor.
	var/decl/butchery_data/butchery_data
	/// A multiplier for the number of slices, when autosetting from butchery_data.
	var/slices_multiplier = 1

// This contains, specifically, initialisation code that must run before the parent call in Initialize().
/obj/item/food/butchery/proc/initialize_butchery_data(decl/butchery_data/new_data, new_meat_name)
	if(new_data)
		if(ispath(new_data))
			butchery_data = GET_DECL(new_data)
		else if(istype(new_data))
			butchery_data = new_data
		else
			PRINT_STACK_TRACE("Invalid value passed to [type], expected /decl/butchery_data, got [new_data]")
	else if(ispath(butchery_data))
		butchery_data = GET_DECL(butchery_data)
	if(butchery_data)
		if(butchery_data.meat_material)
			material = butchery_data.meat_material
		fat_material = butchery_data.gut_material
		if(isnull(slice_num))
			if(slices_multiplier != 1)
				slice_num =  max(1, round(butchery_data.meat_amount * slices_multiplier))
			else
				slice_num = butchery_data.meat_amount
		if(slice_num > 0 && isnull(slice_path)) // Don't autoset a path if we're intentionally not sliceable.
			slice_path = butchery_data.meat_type
		// only butchery_data's meat_name, not src's meat_name, to avoid synthmeat that tastes like 'synthetic'
		if(butchery_data.meat_name)
			nutriment_desc = list((butchery_data.meat_name) = 10)

/obj/item/food/butchery/Initialize(mapload, material_key, skip_plate = FALSE, decl/butchery_data/new_data, new_meat_name)
	initialize_butchery_data(new_data, new_meat_name)
	. = ..()
	if(butchery_data)
		add_allergen_flags(butchery_data.meat_flags)
	if(new_meat_name)
		meat_name = new_meat_name
	else if(butchery_data)
		meat_name = butchery_data.meat_name || initial(meat_name)
	if(meat_name)
		set_meat_name(meat_name)

/obj/item/food/butchery/create_slice()
	if(ispath(slice_path, /obj/item/food/butchery))
		return new slice_path(loc, material?.type, TRUE, butchery_data, meat_name)
	else
		return ..()

/obj/item/food/butchery/get_drying_state(var/obj/rack)
	return "meat"

/obj/item/food/butchery/get_drying_overlay(var/obj/rack)
	var/image/overlay = ..()
	if(fat_material)
		if(istext(overlay))
			overlay = image('icons/obj/drying_rack.dmi', overlay)
		var/drying_state = "[get_drying_state(rack)]_fat"
		if(check_state_in_icon(drying_state, 'icons/obj/drying_rack.dmi'))
			var/decl/material/fat_material_data = GET_DECL(fat_material)
			overlay.overlays += overlay_image('icons/obj/drying_rack.dmi', drying_state, fat_material_data.color, RESET_COLOR)
	return overlay

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
		food.add_allergen_flags(allergen_flags)
		if(meat_name && istype(., /obj/item/food/butchery))
			var/obj/item/food/butchery/meat = .
			meat.set_meat_name(meat_name)

/obj/item/food/butchery/get_dried_product()
	. = ..()
	if(. && istype(., /obj/item/food))
		var/obj/item/food/food = .
		food.cooked_food = FOOD_COOKED
		food.add_allergen_flags(allergen_flags)
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
			food.add_allergen_flags(allergen_flags)
		if(meat_name)
			for(var/obj/item/food/butchery/meat in .)
				meat.set_meat_name(meat_name)

/obj/item/food/butchery/offal
	name                = "offal"
	desc                = "An assortment of organs and lumps of unidentified gristle. Packed with nutrients and bile."
	icon                = 'icons/obj/food/butchery/offal.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 15
	slice_path          = /obj/item/food/butchery/offal/small
	slice_num           = 4
	var/_cleaned        = FALSE
	var/work_skill      = SKILL_CONSTRUCTION

/obj/item/food/butchery/offal/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1 && user.skill_check(work_skill, SKILL_BASIC) && !dry)
		if(_cleaned && drying_wetness)
			. += "\The [src] can be hung on a drying rack to dry it in preparation for being twisted into thread."
		else if(!_cleaned)
			. += "\The [src] can be scraped clean with a sharp object like a knife."
		else if(!drying_wetness)
			. += "\The [src] can be soaked in water to prepare it for drying."

/obj/item/food/butchery/offal/attackby(obj/item/used_item, mob/user)
	if(IS_KNIFE(used_item) && !_cleaned && !dry)
		if(used_item.do_tool_interaction(TOOL_KNIFE, user, src, 3 SECONDS, "scraping", "scraping", check_skill = work_skill, set_cooldown = TRUE) && !_cleaned)
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
	if(!QDELETED(src) && REAGENT_TOTAL_VOLUME(fluids) && material?.tans_to)
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
	icon                = 'icons/obj/food/butchery/offal_small.dmi'
	nutriment_amt       = 5
	w_class             = ITEM_SIZE_SMALL
	slice_path          = null
	slice_num           = 0 // null means autoset, 0 means none

/obj/item/food/butchery/offal/beef
	butchery_data = /decl/butchery_data/animal/ruminant/cow

/obj/item/food/butchery/offal/small/beef
	butchery_data = /decl/butchery_data/animal/ruminant/cow

/obj/item/food/butchery/haunch
	name                = "haunch"
	desc                = "A severed leg of some unfortunate beast, cleaned and ready for cooking."
	icon                = 'icons/obj/food/butchery/haunch.dmi'
	slice_num           = 2
	slice_path          = /obj/item/food/butchery/meat
	w_class             = ITEM_SIZE_LARGE
	var/bone_material   = /decl/material/solid/organic/bone

/obj/item/food/butchery/haunch/initialize_butchery_data(decl/butchery_data/new_data, new_meat_name)
	. = ..() // sets butchery_data for us
	if(butchery_data)
		bone_material = butchery_data.bone_material
	if(bone_material)
		LAZYSET(matter, bone_material, MATTER_AMOUNT_REINFORCEMENT)

/obj/item/food/butchery/haunch/on_update_icon()
	..()

	if(bone_material && check_state_in_icon("[icon_state]-bone", icon))
		var/decl/material/bones = GET_DECL(bone_material)
		add_overlay(overlay_image(icon, "[icon_state]-bone", bones.color, RESET_COLOR))

	if(fat_material && check_state_in_icon("[icon_state]-fat", icon))
		var/decl/material/fat = GET_DECL(fat_material)
		add_overlay(overlay_image(icon, "[icon_state]-fat", fat.color, RESET_COLOR))

/obj/item/food/butchery/haunch/beef
	butchery_data = /decl/butchery_data/animal/ruminant/cow

/obj/item/food/butchery/haunch/shoulder
	name                = "shoulder"

/obj/item/food/butchery/haunch/shoulder/beef
	butchery_data = /decl/butchery_data/animal/ruminant/cow

/obj/item/food/butchery/haunch/side
	name                = "side of meat"
	desc                = "Approximately half the torso and body of an unfortunate animal, split lengthways, cleaned, and ready for cooking."
	icon                = 'icons/obj/food/butchery/side.dmi'
	w_class             = ITEM_SIZE_HUGE
	slices_multiplier   = 0.5

/obj/item/food/butchery/haunch/side/set_meat_name(new_meat_name)
	meat_name = new_meat_name
	SetName("side of [new_meat_name]")

/obj/item/food/butchery/haunch/side/beef
	butchery_data = /decl/butchery_data/animal/ruminant/cow

// TODO: unify with organ/internal/stomach?
/obj/item/food/butchery/stomach
	name                = "stomach"
	desc                = "The stomach of a large animal. It would probably make a decent waterskin if properly treated."
	icon                = 'icons/obj/food/butchery/ruminant_stomach.dmi'
	material            = /decl/material/solid/organic/meat/gut
	nutriment_amt       = 8
	dried_type          = /obj/item/chems/glass/waterskin
	w_class             = ITEM_SIZE_SMALL
	var/stomach_reagent = /decl/material/liquid/acid/stomach

/obj/item/food/butchery/stomach/get_dried_product()
	var/obj/item/chems/glass/waterskin/result = ..()
	if(istype(result) && REAGENT_TOTAL_VOLUME(reagents))
		reagents.trans_to_holder(result.reagents, REAGENT_TOTAL_VOLUME(reagents))
	return result

/obj/item/food/butchery/stomach/get_max_drying_wetness()
	return 80

/obj/item/food/butchery/stomach/populate_reagents()
	..()
	add_to_reagents(stomach_reagent, 12)

/obj/item/food/butchery/stomach/ruminant
	desc                = "A secondary stomach from an unfortunate cow, or some other ruminant. A good source of rennet."
	stomach_reagent     = /decl/material/liquid/enzyme/rennet
