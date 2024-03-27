/obj/item/mould
	name = "mould"
	material = /decl/material/solid/stone/pottery
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	abstract_type = /obj/item/mould
	max_health = 100
	var/product_type
	var/list/product_metadata

/obj/item/mould/Initialize()
	. = ..()
	var/datum/extension/labels/lext = get_or_create_extension(src, /datum/extension/labels)
	if(ispath(product_type, /obj))
		var/obj/product = product_type
		lext.AttachLabel(null, initial(product.name))
		update_icon()
	else
		lext.AttachLabel(null, "blank")

/obj/item/mould/Destroy()
	product_metadata = null
	return ..()

/obj/item/mould/populate_reagents()
	if(!ispath(product_type, /obj))
		return
	var/required_volume = 0
	var/list/matter_for_product = atom_info_repository.get_matter_for(product_type)
	for(var/mat in matter_for_product)
		required_volume += matter_for_product[mat]
	required_volume = CEILING(required_volume * REAGENT_UNITS_PER_MATERIAL_UNIT)
	if(required_volume > 0)
		if(reagents)
			reagents.maximum_volume = required_volume
			reagents.update_total()
		else
			create_reagents(required_volume)

/*
/obj/item/mould/get_max_health()
	return max_health * some material hardness or integrity constant
*/

/obj/item/mould/attackby(obj/item/W, mob/user)
	. = ..()
	if(!. && user.a_intent != I_HURT)
		if(try_crack_mold(user, W))
			return TRUE
		if(try_take_impression(user, W))
			return TRUE

/obj/item/mould/proc/try_crack_mold(mob/user, obj/item/hammer)

	if(!product_type)
		return FALSE

	if(reagents?.total_volume <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return TRUE

	if(reagents.total_volume < reagents.maximum_volume)
		to_chat(user, SPAN_WARNING("\The [src] is not full yet!"))
		return TRUE

	for(var/reagent_type in reagents.reagent_volumes)
		var/decl/material/reagent = GET_DECL(reagent_type)
		if(reagent.melting_point && temperature >= reagent.melting_point)
			to_chat(user, SPAN_WARNING("The contents of \the [src] are still molten! Wait for it to cool down."))
			return TRUE

	if(user && !IS_HAMMER(hammer))
		to_chat(user, SPAN_WARNING("You will need a hammer to crack open \the [src]."))
		return TRUE

	crack_mold(user, hammer)
	return TRUE

/obj/item/mould/proc/crack_mold(mob/user, obj/item/hammer)

	var/decl/material/product_mat = reagents?.get_primary_reagent_decl()
	var/obj/product = new product_type(get_turf(src), product_mat?.type)
	product.dropInto(loc)

	reagents.remove_reagent(product_mat.type, REAGENT_VOLUME(reagents, product_mat.type))
	for(var/reagent_type in reagents.reagent_volumes)
		if(reagent_type == product_mat.type)
			continue
		LAZYINITLIST(product.matter)
		product.matter[reagent_type] += max(1, round(reagents.reagent_volumes[reagent_type] / REAGENT_UNITS_PER_MATERIAL_UNIT))
	reagents.clear_reagents()
	if(length(product_metadata))
		product.take_mould_metadata(product_metadata)
	product.update_icon()
	. = product

	// TODO: hardness check?
	if(istype(material, /decl/material/solid/clay) || istype(material, /decl/material/solid/stone/pottery))
		physically_destroyed(src)
	else
		take_damage(rand(10, 20))

/obj/item/mould/proc/try_take_impression(mob/user, obj/item/thing)

	// TODO: hardness check?
	if(!istype(material, /decl/material/solid/clay))
		to_chat(user, SPAN_WARNING("\The [src] has already been fired - it's too hard to take another impression."))
		return TRUE

	// TODO: pottery skill check?
	if(thing.is_complex_mould_item())
		to_chat(user, SPAN_WARNING("\The [thing] is too complex to be replicated with a mold."))
		return TRUE

	// TODO: pottery skill
	if(user.do_skilled(5 SECONDS, SKILL_CONSTRUCTION, src) && !QDELETED(thing) && (thing.loc == user || thing.Adjacent(user)))
		user.visible_message("\The [src] shapes [material.use_name] around \the [thing], creating a mold.")
		var/datum/extension/labels/lext = get_or_create_extension(src, /datum/extension/labels)
		lext.RemoveAllLabels()
		lext.AttachLabel(null, initial(thing.name))
		product_type = thing.get_mould_product_type()
		product_metadata = thing.get_mould_metadata()
		update_icon()

	return TRUE

// TODO: silhouette impression of the product_type
/*
/obj/item/mould/on_update_icon()
	return ..()
*/

// Crucible is premade as you can't reasonably be expected to find one in the wild to take an impression.
/obj/item/mould/crucible
	product_type = /obj/item/storage/crucible
