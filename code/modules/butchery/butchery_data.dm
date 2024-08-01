/decl/butchery_data

	abstract_type         = /decl/butchery_data

	/// Decorative string. 'beef', 'chicken', 'lamb', etc. Uses mob name if unset.
	var/meat_name         = "meat"
	var/meat_flags        = INGREDIENT_FLAG_MEAT

	var/meat_type         = /obj/item/food/butchery/meat
	var/meat_material     = /decl/material/solid/organic/meat
	var/meat_amount       = 3

	var/bone_type         = /obj/item/stack/material/bone
	var/bone_material     = /decl/material/solid/organic/bone
	var/bone_amount       = 3

	var/skin_type         = /obj/item/stack/material/skin
	var/skin_material     = /decl/material/solid/organic/skin
	var/skin_amount       = 3

	var/gut_type          = /obj/item/food/butchery/offal
	var/gut_material      = /decl/material/solid/organic/meat/gut
	var/gut_amount        = 1

	var/butchery_rotation = 270
	/// A two-element lazylist of the form list(x, y), used to translate the mob's appearance on a butcher hook. Applied after rotation.
	var/butchery_offset
	var/must_use_hook     = TRUE
	var/needs_surface     = FALSE

/decl/butchery_data/proc/place_products(mob/living/donor, product_material, product_amount, product_type)
	if((istype(donor) && donor.butchery_data != type) || !product_material || !product_amount || !product_type)
		return null
	var/product_loc = donor ? get_turf(donor) : null
	if(donor && product_loc)
		blood_splatter(product_loc, donor, large = TRUE)
	if(ispath(product_type, /obj/item/stack))
		LAZYADD(., new product_type(product_loc, product_amount, product_material, donor))
	else
		for(var/i = 1 to product_amount)
			LAZYADD(., new product_type(product_loc, product_material, donor))

/decl/butchery_data/proc/harvest_skin(mob/living/donor)
	. = place_products(donor, skin_material, skin_amount, skin_type)
	if(donor && length(.))
		var/skin_color = donor.get_skin_colour()
		if(skin_color)
			for(var/obj/item/thing in .)
				thing.set_color(skin_color)

/decl/butchery_data/proc/harvest_innards(mob/living/donor)

	. = place_products(donor, gut_material,  gut_amount,  gut_type)

	var/removed_organ = FALSE
	for(var/obj/item/organ/organ in donor?.get_internal_organs())
		if(istype(organ))
			donor.remove_organ(organ, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE)
			removed_organ = TRUE
		else if(isitem(organ))
			organ.dropInto(get_turf(donor))
		else
			continue
		LAZYADD(., organ)

	if(removed_organ)
		donor.update_health()
		donor.update_icon()

/decl/butchery_data/proc/harvest_bones(mob/living/donor)
	. = place_products(donor, bone_material, bone_amount, bone_type)

/decl/butchery_data/proc/harvest_meat(mob/living/donor)

	. = place_products(donor, meat_material, meat_amount, meat_type)

	if(!istype(donor))
		return

	if(donor.reagents && length(.))
		var/list/meat
		for(var/obj/item/food/slab in .)
			LAZYADD(meat, slab)
		if(length(meat))
			var/reagent_split = round(donor.reagents.total_volume/length(meat), 1)
			for(var/obj/item/food/slab as anything in meat)
				donor.reagents.trans_to_obj(slab, reagent_split)

	// This process will delete the mob, so do it last.
	for(var/obj/item/organ/organ as anything in donor?.get_external_organs())
		if(istype(organ))
			donor.remove_organ(organ, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE)
		else if(isitem(organ))
			organ.dropInto(get_turf(donor))
		else
			continue
		LAZYADD(., organ)

// TODO: make meat spikes use/set these.
/mob/living/proc/currently_has_skin()
	return TRUE

/mob/living/proc/currently_has_innards()
	return TRUE

/mob/living/proc/currently_has_bones()
	return TRUE

/mob/living/proc/currently_has_meat()
	return TRUE

/decl/butchery_data/proc/get_all_products(mob/living/donor)
	if(!donor || donor.currently_has_skin())
		for(var/thing in harvest_skin(donor))
			LAZYDISTINCTADD(., thing)
	if(!donor || donor.currently_has_innards())
		for(var/thing in harvest_innards(donor))
			LAZYDISTINCTADD(., thing)
	if(!donor || donor.currently_has_bones())
		for(var/thing in harvest_bones(donor))
			LAZYDISTINCTADD(., thing)
	if(!donor || donor.currently_has_meat())
		for(var/thing in harvest_meat(donor))
			LAZYDISTINCTADD(., thing)

/decl/butchery_data/proc/get_monetary_worth(mob/living/donor)
	. = 0
	if(meat_type)
		. += atom_info_repository.get_combined_worth_for(meat_type) * meat_amount
	if(skin_material)
		var/decl/material/M = GET_DECL(skin_material)
		. += skin_amount * M.value * 10
	if(bone_material)
		var/decl/material/M = GET_DECL(bone_material)
		. += bone_amount * M.value * 10

/decl/butchery_data/validate()
	. = ..()
	if(meat_type && meat_amount <= 0)
		. += "valid meat type but meat amount is less than or equal to zero"
	if(!meat_type && meat_amount > 0)
		. += "invalid meat type but meat amount is larger than zero"
	if((meat_type || meat_amount) && !meat_material)
		. += "invalid meat material but meat type or meat amount are set"

	if(skin_type && skin_amount <= 0)
		. += "valid skin type but skin amount is less than or equal to zero"
	if(!skin_type && skin_amount > 0)
		. += "invalid skin type but skin amount is larger than zero"
	if((skin_type || skin_amount) && !skin_material)
		. += "invalid skin material but skin type or skin amount are set"

	if(bone_type && bone_amount <= 0)
		. += "valid bone type but bone amount is less than or equal to zero"
	if(!bone_type && bone_amount > 0)
		. += "invalid bone type but bone amount is larger than zero"
	if((bone_type || bone_amount) && !bone_material)
		. += "invalid bone material but bone type or bone amount are set"

	if(gut_type && gut_amount <= 0)
		. += "valid gut type but gut amount is less than or equal to zero"
	if(!gut_type && gut_amount > 0)
		. += "invalid gut type but gut amount is larger than zero"
	if((gut_type || gut_amount) && !gut_material)
		. += "invalid gut material but gut type or gut amount are set"

	// Try to retrieve all products to ensure nothing trips any runtimes.
	for(var/atom/thing in get_all_products())
		qdel(thing)
