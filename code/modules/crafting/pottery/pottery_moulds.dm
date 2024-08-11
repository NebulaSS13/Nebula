/obj/item/chems/mould
	name = "mould"
	desc = "A roughly shaped mass of material intended to hold molten metal or other materials until they cool into shape."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/items/mould.dmi'
	material = /decl/material/solid/stone/pottery
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	max_health = 100
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 20 // updated in populate_reagents()
	var/product_type
	var/list/product_metadata
	var/work_skill = SKILL_CONSTRUCTION

/obj/item/chems/mould/Initialize()
	. = ..()
	var/datum/extension/labels/lext = get_or_create_extension(src, /datum/extension/labels)
	if(ispath(product_type, /obj))
		var/obj/product = product_type
		lext.AttachLabel(null, initial(product.name))
		update_icon()
	else
		lext.AttachLabel(null, "blank")
	max_health = material ? max(10, round(material.integrity * 0.5)) : 75 // pottery at time of commit has integrity 150
	current_health = get_max_health()

/obj/item/chems/mould/on_update_icon()
	..()
	icon_state = get_world_inventory_state()
	// todo: imprint of product somehow. Alpha mask?
	if(product_type)
		icon_state = "[icon_state]-imprinted"

/obj/item/chems/mould/Destroy()
	product_metadata = null
	return ..()

/obj/item/chems/mould/initialize_reagents()
	if(ispath(product_type, /obj))
		update_volume_from_product()
	..()

/obj/item/chems/mould/proc/update_volume_from_product()
	var/required_volume = 0
	var/list/matter_for_product = atom_info_repository.get_matter_for(product_type, /decl/material/placeholder, 1)
	for(var/mat in matter_for_product)
		required_volume += matter_for_product[mat]
	required_volume = ceil(required_volume * REAGENT_UNITS_PER_MATERIAL_UNIT)
	if(required_volume > 0)
		if(reagents)
			reagents.maximum_volume = required_volume
			reagents.update_total()
		else if(atom_flags & ATOM_FLAG_INITIALIZED)
			create_reagents(required_volume)
		else
			volume = required_volume
	else
		QDEL_NULL(reagents)

/obj/item/chems/mould/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	// This is kind of gross but getting /chems/attackby()
	// standard_pour_into() to cooperate is a bit beyond me
	// at the moment.
	if(istype(W, /obj/item/chems/crucible))

		if(material?.hardness <= MAT_VALUE_MALLEABLE)
			to_chat(user, SPAN_WARNING("\The [src] is currently too soft to be used as a mould."))
			return TRUE

		var/obj/item/chems/vessel = W
		if(vessel.standard_pour_into(user, src))
			return TRUE

	if(try_crack_mold(user, W))
		return TRUE

	if(try_take_impression(user, W))
		return TRUE

	return ..()

/obj/item/chems/mould/proc/try_crack_mold(mob/user, obj/item/hammer)

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

/obj/item/chems/mould/proc/crack_mold(mob/user, obj/item/hammer)

	var/decl/material/product_mat = reagents?.get_primary_reagent_decl()
	var/obj/product = ispath(product_type, /obj/item/stack) ? new product_type(get_turf(src), 1, product_mat?.type) : new product_type(get_turf(src), product_mat?.type)
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

	visible_message("\The [user] cracks \the [src] and retrieves \the [product].")
	if(loc == user)
		user.put_in_hands(product)

	if(material?.hardness <= MAT_VALUE_MALLEABLE)
		if(!squash_item())
			physically_destroyed(src)
	else
		// At skill 1/5, damage it 3x more. At skill 2/5, damage it 1.5x more.
		// At skill 3/5 deal base damage, at 4/5 deal 75% damage, and at max skill deal 60% damage.
		var/damage_modifier = clamp(1 + (user.get_skill_value(work_skill) - SKILL_ADEPT) / (SKILL_MAX - SKILL_BASIC), 0.1, 3)
		take_damage(rand(5, 10) / damage_modifier)

/obj/item/chems/mould/proc/try_take_impression(mob/user, obj/item/thing)

	if(material?.hardness > MAT_VALUE_MALLEABLE)
		to_chat(user, SPAN_WARNING("\The [src] is too hard to take another impression."))
		return TRUE

	var/mould_difficulty = thing.get_mould_difficulty()
	if(mould_difficulty >= SKILL_IMPOSSIBLE || !user.skill_check(work_skill, mould_difficulty))
		to_chat(user, SPAN_WARNING("\The [thing] is too complex for you to replicate with a mould."))
		return TRUE

	if(user.do_skilled(3 SECONDS, work_skill, src) && !QDELETED(thing) && (thing.loc == user || thing.Adjacent(user)))
		user.visible_message("\The [user] shapes [material.use_name] around \the [thing], imprinting it onto the mould.")
		var/datum/extension/labels/lext = get_or_create_extension(src, /datum/extension/labels)
		lext.RemoveAllLabels()
		lext.AttachLabel(null, initial(thing.name))
		product_type = thing.get_mould_product_type()
		product_metadata = thing.get_mould_metadata()
		update_volume_from_product()
		update_icon()

	return TRUE

// Some recipes are premade as you can't reasonably be expected to find them in the wild to take an impression.
/obj/item/chems/mould/crucible
	product_type = /obj/item/chems/crucible

// Forging TODO: roller for turning blooms into rods, bloom recipe
/obj/item/chems/mould/rod
	product_type = /obj/item/stack/material/rods

/obj/item/chems/mould/ingot
	product_type = /obj/item/stack/material/ingot
