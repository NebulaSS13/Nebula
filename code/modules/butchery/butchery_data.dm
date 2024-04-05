/decl/butchery_data
	abstract_type = /decl/butchery_data
	var/meat_type         = /obj/item/chems/food/meat
	var/meat_material     = /decl/material/solid/organic/meat
	var/meat_amount       = 3
	var/bone_type         = /obj/item/stack/material/bone
	var/bone_material     = /decl/material/solid/organic/bone
	var/bone_amount       = 3
	var/skin_type         = /obj/item/stack/material/skin
	var/skin_material     = /decl/material/solid/organic/skin
	var/skin_amount       = 3
	var/gut_type          = /obj/item/chems/food/butchery/offal
	var/gut_material      = /decl/material/solid/organic/meat/gut
	var/gut_amount        = 1
	var/butchery_rotation = 90
	var/must_use_hook     = TRUE

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

/decl/butchery_data/proc/harvest_innards(mob/living/donor)
	. = place_products(donor, gut_material,  gut_amount,  gut_type)

/decl/butchery_data/proc/harvest_bones(mob/living/donor)
	. = place_products(donor, bone_material, bone_amount, bone_type)

/decl/butchery_data/proc/harvest_meat(mob/living/donor)
	. = place_products(donor, meat_material, meat_amount, meat_type)
	if(!istype(donor) || !donor?.reagents || !length(.))
		return
	var/list/meat
	for(var/obj/item/chems/food/slab in .)
		LAZYADD(meat, slab)
	if(length(meat))
		var/reagent_split = round(donor.reagents.total_volume/length(meat), 1)
		for(var/obj/item/chems/food/slab as anything in meat)
			donor.reagents.trans_to_obj(slab, reagent_split)

/decl/butchery_data/proc/get_all_products(mob/living/donor)
	for(var/thing in harvest_skin(donor))
		LAZYDISTINCTADD(., thing)
	for(var/thing in harvest_innards(donor))
		LAZYDISTINCTADD(., thing)
	for(var/thing in harvest_bones(donor))
		LAZYDISTINCTADD(., thing)
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

	if(skin_type && skin_amount <= 0)
		. += "valid skin type but skin amount is less than or equal to zero"
	if(!skin_type && skin_amount > 0)
		. += "invalid skin type but skin amount is larger than zero"

	if(bone_type && bone_amount <= 0)
		. += "valid bone type but bone amount is less than or equal to zero"
	if(!bone_type && bone_amount > 0)
		. += "invalid bone type but bone amount is larger than zero"

	if(gut_type && gut_amount <= 0)
		. += "valid bone type but bone amount is less than or equal to zero"
	if(!gut_type && gut_amount > 0)
		. += "invalid bone type but bone amount is larger than zero"
