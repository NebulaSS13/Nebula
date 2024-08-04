//Grown foods.
/obj/item/food/grown
	name = "produce"
	icon = 'icons/obj/hydroponics/hydroponics_products.dmi'
	icon_state = "blank"
	randpixel = 5
	desc = "Nutritious! Probably."
	slot_flags = SLOT_HOLSTER
	material = /decl/material/solid/organic/plantmatter
	is_spawnable_type = FALSE // Use the Spawn-Fruit verb instead.
	drying_wetness = 45
	dried_type = /obj/item/food/grown/dry
	ingredient_flags = INGREDIENT_FLAG_VEGETABLE
	var/work_skill = SKILL_BOTANY
	var/seeds_extracted = FALSE
	var/datum/seed/seed

/obj/item/food/grown/examine(mob/user, distance)
	. = ..()
	if(user && distance <= 1 && seed && user.skill_check(work_skill, SKILL_BASIC))
		if(seed.grown_is_seed)
			to_chat(user, SPAN_NOTICE("\The [src] can be planted directly, without having to extract any seeds."))
		else if(!seeds_extracted && seed.min_seed_extracted)
			to_chat(user, SPAN_NOTICE("With a knife, you could extract at least [seed.min_seed_extracted] seed\s."))

/obj/item/food/grown/Initialize(mapload, material_key, _seed)

	if(isnull(seed) && _seed)
		seed = _seed

	if(istext(seed))
		seed = SSplants.seeds[seed]

	if(!istype(seed))
		PRINT_STACK_TRACE("Grown initializing with null or invalid seed type '[seed || "NULL"]'")
		return INITIALIZE_HINT_QDEL

	filling_color = seed.get_trait(TRAIT_PRODUCT_COLOUR) || seed.get_trait(TRAIT_FLESH_COLOUR)
	slice_path    = seed.slice_product
	slice_num     = seed.slice_amount

	if(!seed.chems && !(dry && seed.dried_chems) && !(backyard_grilling_count > 0 && seed.roasted_chems))
		return INITIALIZE_HINT_QDEL // No reagent contents, no froot

	if(seed.scannable_result)
		set_extension(src, /datum/extension/scannable, seed.scannable_result)

	var/descriptor = list()
	if(dry)
		descriptor += "dried"
	if(backyard_grilling_count > 0)
		descriptor += "roasted"
	if(length(descriptor))
		SetName("[english_list(descriptor)] [seed.product_name]")
	else
		SetName("[seed.product_name]")
	if(seed.product_material)
		material = seed.product_material

	trash                          = seed.get_trash_type()
	backyard_grilling_product      = seed.backyard_grilling_product
	backyard_grilling_rawness      = seed.backyard_grilling_rawness
	backyard_grilling_announcement = seed.backyard_grilling_announcement

	if(!dried_type)
		dried_type = type

	. = ..(mapload) //Init reagents

/obj/item/food/grown/initialize_reagents(populate)
	if(reagents)
		reagents.clear_reagents()
	if(!seed?.chems)
		return

	. = ..() //create_reagent and populate_reagents

	update_desc()
	if(reagents.total_volume > 0)
		bitesize = 1 + round(reagents.total_volume / 2, 1)

	update_icon()

/obj/item/food/grown/populate_reagents()
	. = ..()
	// Fill the object up with the appropriate reagents.
	var/list/chems_to_fill
	if(backyard_grilling_count > 0)
		chems_to_fill ||= seed?.roasted_chems
	if(dry)
		chems_to_fill ||= seed?.dried_chems
	chems_to_fill ||= seed?.chems
	for(var/rid in chems_to_fill)
		var/list/reagent_amounts = chems_to_fill[rid]
		if(LAZYLEN(reagent_amounts))
			var/rtotal = reagent_amounts[1]
			var/list/data = null
			var/potency = seed.get_trait(TRAIT_POTENCY)
			if(LAZYACCESS(reagent_amounts,2) && potency > 0)
				rtotal += round(potency/reagent_amounts[2])
			var/decl/material/reagent = GET_DECL(rid)
			if(!reagent.taste_description)
				LAZYSET(data, "taste", list(seed.product_name = max(1,rtotal) * reagent.taste_mult))
			add_to_reagents(rid,max(1,rtotal),data)

/obj/item/food/grown/proc/update_desc()
	set waitfor = FALSE
	if(!seed)
		return
	if(!SSplants)
		sleep(250) // ugly hack, should mean roundstart plants are fine.
	if(!SSplants)
		log_error("<span class='danger'>Plant controller does not exist and [src] requires it. Aborting.</span>")
		qdel(src)
		return

	if(SSplants.product_descs["[seed.uid]"])
		desc = SSplants.product_descs["[seed.uid]"]
	else

		var/list/descriptors = list()

		for(var/rtype in reagents.reagent_volumes)
			var/decl/material/chem = GET_DECL(rtype)
			if(chem.fruit_descriptor)
				descriptors |= chem.fruit_descriptor
			if(chem.reflectiveness >= MAT_VALUE_SHINY)
				descriptors |= "shiny"
			if(chem.slipperiness >= 10)
				descriptors |= "slippery"
			if(chem.toxicity >= 3)
				descriptors |= "poisonous"
			if(chem.radioactivity)
				descriptors |= "radioactive"
			if(chem.solvent_power >= MAT_SOLVENT_STRONG)
				descriptors |= "acidic"

		if(seed.get_trait(TRAIT_JUICY))
			descriptors |= "juicy"
		if(seed.get_trait(TRAIT_STINGS))
			descriptors |= "stinging"
		if(seed.get_trait(TRAIT_TELEPORTING))
			descriptors |= "glowing"
		if(seed.get_trait(TRAIT_EXPLOSIVE))
			descriptors |= "bulbous"

		var/descriptor_num = rand(2,4)
		var/descriptor_count = descriptor_num
		desc = "A"
		while(descriptors.len && descriptor_num > 0)
			var/chosen = pick(descriptors)
			descriptors -= chosen
			desc += "[(descriptor_count>1 && descriptor_count!=descriptor_num) ? "," : "" ] [chosen]"
			descriptor_num--
		if(seed.seed_noun == SEED_NOUN_SPORES)
			desc += " mushroom"
		else
			desc += " fruit"
		SSplants.product_descs["[seed.uid]"] = desc
	desc += ". Delicious! Probably."

/obj/item/food/grown/on_update_icon()
	. = ..()
	if(!seed)
		return
	icon_state = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-product"
	if(!dry && !backyard_grilling_count)
		color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
	if("[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf" in icon_states('icons/obj/hydroponics/hydroponics_products.dmi'))
		var/image/fruit_leaves = image('icons/obj/hydroponics/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf")
		if(!dry && !backyard_grilling_count)
			fruit_leaves.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		add_overlay(fruit_leaves)

/obj/item/food/grown/Crossed(atom/movable/AM)
	if(!isliving(AM) || !seed || seed.get_trait(TRAIT_JUICY) != 2)
		return

	var/mob/living/M = AM
	if(M.buckled || MOVING_DELIBERATELY(M))
		return

	var/obj/item/shoes = M.get_equipped_item(slot_shoes_str)
	if(shoes && shoes.item_flags & ITEM_FLAG_NOSLIP)
		return

	to_chat(M, SPAN_DANGER("You slipped on \the [src]!"))
	playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	SET_STATUS_MAX(M, STAT_STUN, 8)
	SET_STATUS_MAX(M, STAT_WEAK, 5)
	seed.thrown_at(src,M)
	QDEL_IN(src, 0)

/obj/item/food/grown/throw_impact(atom/hit_atom)
	..()
	if(seed)
		seed.thrown_at(src,hit_atom)

var/global/list/_wood_materials = list(
	/decl/material/solid/organic/wood,
	/decl/material/solid/organic/wood/mahogany,
	/decl/material/solid/organic/wood/maple,
	/decl/material/solid/organic/wood/ebony,
	/decl/material/solid/organic/wood/walnut,
	/decl/material/solid/organic/wood/bamboo,
	/decl/material/solid/organic/wood/yew
)

/obj/item/food/grown/show_slice_message(mob/user, obj/item/tool)
	if(!seed?.show_slice_message(user, tool, src))
		..()

/obj/item/food/grown/show_slice_message_poor(mob/user, obj/item/tool)
	if(!seed?.show_slice_message_poor(user, tool, src))
		..()

/obj/item/food/grown/attackby(var/obj/item/W, var/mob/user)

	if(!seed || user.a_intent == I_HURT)
		return ..()

	if(seed.get_trait(TRAIT_PRODUCES_POWER) && IS_COIL(W))
		var/obj/item/stack/cable_coil/C = W
		if(C.use(5))
			//TODO: generalize this.
			to_chat(user, SPAN_NOTICE("You add some cable to \the [src] and slide it inside the battery casing."))
			var/obj/item/cell/potato/pocell = new /obj/item/cell/potato(get_turf(user))
			qdel(src)
			user.put_in_hands(pocell)
			pocell.maxcharge =  seed.get_trait(TRAIT_POTENCY) * 10
			pocell.charge = pocell.maxcharge
		return TRUE

	if(IS_KNIFE(W) && !seeds_extracted && !seed.grown_is_seed && seed.min_seed_extracted && user.skill_check(work_skill, SKILL_BASIC))
		var/seed_result = max(1, rand(seed.min_seed_extracted, seed.max_seed_extracted))
		visible_message(SPAN_NOTICE("\The [user] uses \the [W] to lever [seed_result] seed\s out of \the [src]."))
		for(var/i = 1 to seed_result)
			new /obj/item/seeds/extracted(get_turf(user), material?.type, seed)
		seeds_extracted = TRUE
		return TRUE

	if(IS_HATCHET(W) && seed.chems)
		for(var/wood_mat in global._wood_materials)
			if(!isnull(seed.chems[wood_mat]))
				user.visible_message(SPAN_NOTICE("\The [user] makes planks out of \the [src]."))
				for(var/obj/item/stack/material/stack in SSmaterials.create_object(wood_mat, user.loc, rand(1,2)))
					stack.add_to_stacks(user, TRUE)
				qdel(src)
				return TRUE

	var/static/list/rollable_types = list(
		/obj/item/paper/cig,
		/obj/item/paper,
		/obj/item/teleportation_scroll
	)

	if(is_type_in_list(W, rollable_types))

		if(!dry)
			to_chat(user, SPAN_WARNING("You need to dry \the [src] first!"))
			return TRUE

		if(!user.try_unequip(W))
			return TRUE

		var/obj/item/clothing/mask/smokable/cigarette/rolled/R = new(get_turf(src))
		R.chem_volume = max(R.reagents?.maximum_volume, reagents?.total_volume)
		if(R.reagents)
			R.reagents.maximum_volume = R.chem_volume
			R.reagents.update_total()
		else
			R.create_reagents(R.chem_volume)

		R.brand = "[src] handrolled in \the [W]."
		reagents.trans_to_holder(R.reagents, R.chem_volume)
		to_chat(user, SPAN_NOTICE("You roll \the [src] into \the [W]."))
		user.put_in_active_hand(R)
		qdel(W)
		qdel(src)
		return TRUE

	. = ..()

/obj/item/food/grown/get_grown_tag()
	if(!seed?.grown_tag)
		return
	. = dry ? "dried [seed.grown_tag]" : seed.grown_tag

/obj/item/food/grown/create_slice()
	return new slice_path(loc, material?.type, seed)

/obj/item/food/grown/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()

	if(seed && seed.get_trait(TRAIT_STINGS))
		if(!reagents || reagents.total_volume <= 0)
			return
		remove_any_reagents(rand(1,3))
		seed.thrown_at(src, target)
		sleep(-1)
		if(!src)
			return
		if(prob(35))
			if(user)
				to_chat(user, "<span class='danger'>\The [src] has fallen to bits.</span>")
			qdel(src)

/obj/item/food/grown/attack_self(mob/user)

	if(seed)
		if(user.a_intent == I_HURT)
			user.visible_message(SPAN_DANGER("\The [user] squashes \the [src]!"))
			seed.thrown_at(src,user)
			sleep(-1)
			if(src) qdel(src)
			return TRUE

		var/turf/user_loc = user.loc
		if(isturf(user_loc) && !user_loc.is_open() && seed.get_trait(TRAIT_SPREAD) > 0)
			to_chat(user, SPAN_NOTICE("You plant \the [src]."))
			new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
			qdel(src)
			return TRUE

	return ..()

/obj/item/food/grown/on_picked_up(mob/user)
	..()
	if(!seed)
		return
	if(seed.get_trait(TRAIT_STINGS))
		var/mob/living/human/H = user
		if(istype(H) && H.get_equipped_item(slot_gloves_str))
			return
		if(!reagents || reagents.total_volume <= 0)
			return
		remove_any_reagents(rand(1,3)) //Todo, make it actually remove the reagents the seed uses.
		var/affected = pick(BP_R_HAND,BP_L_HAND)
		seed.do_thorns(H,src,affected)
		seed.do_sting(H,src,affected)

/obj/item/food/grown/dry
	dry = TRUE
	drying_wetness = null
	dried_type = null
	color = COLOR_BEIGE

/obj/item/food/grown/get_dried_product()
	if(ispath(dried_type, /obj/item/food/grown))
		return new dried_type(loc, null, seed.name)
	return ..()

/obj/item/food/grown/get_drying_state(var/obj/rack)
	return seed?.drying_state || ..()

/obj/item/food/grown/grilled
	backyard_grilling_count = 1 // will get overwritten when actually made
	color = COLOR_BROWN_ORANGE

/obj/item/food/grown/get_grilled_product()
	if(ispath(backyard_grilling_product, /obj/item/food/grown))
		return new backyard_grilling_product(loc, null, seed.name)
	return ..()

/obj/item/food/grown/afterattack(atom/target, mob/user, flag)
	if(!flag && isliving(user))
		var/mob/living/M = user
		M.aim_at(target, src)
		return
	. = ..()

/obj/item/food/grown/handle_reflexive_fire(var/mob/user, var/atom/aiming_at)
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] reflexively hurls \the [src] at \the [aiming_at]!"))
		user.mob_throw_item(get_turf(aiming_at), src)
		user.trigger_aiming(TARGET_CAN_CLICK)

/obj/item/food/grown/has_textile_fibers()
	for(var/mat in get_contained_matter())
		var/decl/material/check_mat = GET_DECL(mat)
		if(check_mat.has_textile_fibers)
			return TRUE
	return FALSE

// Predefined types for placing on the map.
/obj/item/food/grown/libertycap
	seed = "libertycap"

/obj/item/food/grown/ambrosiavulgaris
	seed = "ambrosiavulgaris"
