//Grown foods.
/obj/item/chems/food/grown
	name = "fruit"
	icon = 'icons/obj/hydroponics/hydroponics_products.dmi'
	icon_state = "blank"
	randpixel = 5
	desc = "Nutritious! Probably."
	slot_flags = SLOT_HOLSTER
	material = /decl/material/solid/plantmatter

	var/plantname
	var/datum/seed/seed
	var/potency = -1

/obj/item/chems/food/grown/Initialize(mapload, planttype)
	. = ..(mapload)
	if(planttype)
		plantname = planttype
	seed = SSplants.seeds[plantname]
	if(!seed)
		return INITIALIZE_HINT_QDEL

	SetName("[seed.seed_name]")
	trash = seed.get_trash_type()
	if(!dried_type)
		dried_type = type

	fill_reagents()
	update_icon()


/obj/item/chems/food/grown/proc/fill_reagents()
	if(!seed)
		return

	if(!seed.chems)
		return

	potency = seed.get_trait(TRAIT_POTENCY)
	if(!reagents)
		create_reagents(volume)
	reagents.clear_reagents()
	// Fill the object up with the appropriate reagents.
	for(var/rid in seed.chems)
		var/list/reagent_data = seed.chems[rid]
		if(reagent_data && reagent_data.len)
			var/rtotal = reagent_data[1]
			var/list/data = list()
			if(reagent_data.len > 1 && potency > 0)
				rtotal += round(potency/reagent_data[2])
			if(rid == /decl/material/liquid/nutriment)
				data[seed.seed_name] = max(1,rtotal)
			reagents.add_reagent(rid,max(1,rtotal),data)
	update_desc()
	if(reagents.total_volume > 0)
		bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/chems/food/grown/proc/update_desc()
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

/obj/item/chems/food/grown/on_update_icon()
	if(!seed)
		return
	overlays.Cut()
	icon_state = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-product"
	color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
	if("[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf" in icon_states('icons/obj/hydroponics/hydroponics_products.dmi'))
		var/image/fruit_leaves = image('icons/obj/hydroponics/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf")
		fruit_leaves.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		overlays |= fruit_leaves

/obj/item/chems/food/grown/Crossed(var/mob/living/M)
	set waitfor = FALSE
	if(seed && seed.get_trait(TRAIT_JUICY) == 2)
		if(istype(M))

			if(M.buckled)
				return

			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.shoes && H.shoes.item_flags & ITEM_FLAG_NOSLIP)
					return

			to_chat(M, "<span class='notice'>You slipped on the [name]!</span>")
			playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			SET_STATUS_MAX(M, STAT_STUN, 8)
			SET_STATUS_MAX(M, STAT_WEAK, 5)
			seed.thrown_at(src,M)
			QDEL_IN(src, 0)

/obj/item/chems/food/grown/throw_impact(atom/hit_atom)
	..()
	if(seed)
		seed.thrown_at(src,hit_atom)

var/global/list/_wood_materials = list(
	/decl/material/solid/wood,
	/decl/material/solid/wood/mahogany,
	/decl/material/solid/wood/maple,
	/decl/material/solid/wood/ebony,
	/decl/material/solid/wood/walnut,
	/decl/material/solid/wood/bamboo,
	/decl/material/solid/wood/yew
)

/obj/item/chems/food/grown/attackby(var/obj/item/W, var/mob/user)

	if(seed)
		if(seed.get_trait(TRAIT_PRODUCES_POWER) && isCoil(W))
			var/obj/item/stack/cable_coil/C = W
			if(C.use(5))
				//TODO: generalize this.
				to_chat(user, SPAN_NOTICE("You add some cable to \the [src] and slide it inside the battery casing."))
				var/obj/item/cell/potato/pocell = new /obj/item/cell/potato(get_turf(user))
				qdel(src)
				user.put_in_hands(pocell)
				pocell.maxcharge = src.potency * 10
				pocell.charge = pocell.maxcharge
				return TRUE

		if(W.sharp)
			if(seed.kitchen_tag == "pumpkin") // Ugggh these checks are awful.
				user.show_message(SPAN_NOTICE("You carve a face into \the [src]!"), 1)
				new /obj/item/clothing/head/pumpkinhead (user.loc)
				qdel(src)
				return TRUE

			if(seed.chems)
				if(isHatchet(W))
					for(var/wood_mat in global._wood_materials)
						if(!isnull(seed.chems[wood_mat]))
							user.visible_message("<span class='notice'>\The [user] makes planks out of \the [src].</span>")
							var/obj/item/stack/material/stack = SSmaterials.create_object(wood_mat, user.loc, rand(1,2))
							stack.add_to_stacks(user, TRUE)
							qdel(src)
							return TRUE


				if(!isnull(seed.chems[/decl/material/liquid/drink/juice/potato]))
					to_chat(user, SPAN_NOTICE("You slice \the [src] into sticks."))
					new /obj/item/chems/food/rawsticks(get_turf(src))
					qdel(src)
					return TRUE

				if(!isnull(seed.chems[/decl/material/liquid/drink/juice/carrot]))
					to_chat(user, SPAN_NOTICE("You slice \the [src] into sticks."))
					new /obj/item/chems/food/carrotfries(get_turf(src))
					qdel(src)
					return TRUE

				if(!isnull(seed.chems[/decl/material/liquid/drink/milk/soymilk]))
					to_chat(user, SPAN_NOTICE("You roughly chop up \the [src]."))
					new /obj/item/chems/food/soydope(get_turf(src))
					qdel(src)
					return TRUE

				if(seed.get_trait(TRAIT_FLESH_COLOUR))
					to_chat(user, SPAN_NOTICE("You slice up \the [src]."))
					var/slices = rand(3,5)
					var/reagents_to_transfer = round(reagents.total_volume/slices)
					for(var/i in 1 to slices)
						var/obj/item/chems/food/fruit_slice/F = new(get_turf(src),seed)
						if(reagents_to_transfer) reagents.trans_to_obj(F,reagents_to_transfer)
					qdel(src)
					return TRUE

	if(is_type_in_list(W, list(/obj/item/paper/cig/, /obj/item/paper, /obj/item/teleportation_scroll)))

		if(!dry)
			to_chat(user, SPAN_WARNING("You need to dry \the [src] first!"))
			return TRUE

		if(user.unEquip(W))
			var/obj/item/clothing/mask/smokable/cigarette/rolled/R = new(get_turf(src))
			R.chem_volume = reagents.total_volume
			R.brand = "[src] handrolled in \the [W]."
			reagents.trans_to_holder(R.reagents, R.chem_volume)
			to_chat(user, SPAN_NOTICE("You roll \the [src] into \the [W]."))
			user.put_in_active_hand(R)
			qdel(W)
			qdel(src)
			return TRUE

	. = ..()

/obj/item/chems/food/grown/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()

	if(seed && seed.get_trait(TRAIT_STINGS))
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3))
		seed.thrown_at(src, target)
		sleep(-1)
		if(!src)
			return
		if(prob(35))
			if(user)
				to_chat(user, "<span class='danger'>\The [src] has fallen to bits.</span>")
			qdel(src)

/obj/item/chems/food/grown/attack_self(mob/user)

	if(!seed)
		return

	if(isspaceturf(user.loc))
		return

	if(user.a_intent == I_HURT)
		user.visible_message("<span class='danger'>\The [user] squashes \the [src]!</span>")
		seed.thrown_at(src,user)
		sleep(-1)
		if(src) qdel(src)
		return

	if(seed.kitchen_tag == "grass")
		user.show_message("<span class='notice'>You make a grass tile out of \the [src]!</span>", 1)
		var/flesh_colour = seed.get_trait(TRAIT_FLESH_COLOUR)
		if(!flesh_colour) flesh_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/tile/grass/G = new (user.loc)
			if(flesh_colour) G.color = flesh_colour
			for (var/obj/item/stack/tile/grass/NG in user.loc)
				if(G==NG)
					continue
				if(NG.amount>=NG.max_amount)
					continue
				NG.attackby(G, user)
			to_chat(user, "You add the newly-formed grass to the stack. It now contains [G.amount] tiles.")
		qdel(src)
		return

	if(seed.get_trait(TRAIT_SPREAD) > 0)
		to_chat(user, "<span class='notice'>You plant the [src.name].</span>")
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
		qdel(src)
		return

/obj/item/chems/food/grown/pickup(mob/user)
	..()
	if(!seed)
		return
	if(seed.get_trait(TRAIT_STINGS))
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.gloves)
			return
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3)) //Todo, make it actually remove the reagents the seed uses.
		var/affected = pick(BP_R_HAND,BP_L_HAND)
		seed.do_thorns(H,src,affected)
		seed.do_sting(H,src,affected)

// Predefined types for placing on the map.

/obj/item/chems/food/grown/mushroom/libertycap
	plantname = "libertycap"


/obj/item/chems/food/grown/ambrosiavulgaris
	plantname = "biteleaf"

/obj/item/chems/food/fruit_slice
	name = "fruit slice"
	desc = "A slice of some tasty fruit."
	icon = 'icons/obj/hydroponics/hydroponics_misc.dmi'
	icon_state = ""
	dried_type = /obj/item/chems/food/fruit_slice
	var/datum/seed/seed

var/global/list/fruit_icon_cache = list()

/obj/item/chems/food/fruit_slice/Initialize(mapload, var/datum/seed/S)
	. = ..(mapload)
	// Need to go through and make a general image caching controller. Todo.
	if(!istype(S))
		return INITIALIZE_HINT_QDEL

	name = "[S.seed_name] slice"
	desc = "A slice of \a [S.seed_name]. Tasty, probably."
	seed = S

	var/rind_colour = S.get_trait(TRAIT_PRODUCT_COLOUR)
	var/flesh_colour = S.get_trait(TRAIT_FLESH_COLOUR)
	if(!flesh_colour) flesh_colour = rind_colour
	if(!fruit_icon_cache["rind-[rind_colour]"])
		var/image/I = image(icon,"fruit_rind")
		I.color = rind_colour
		fruit_icon_cache["rind-[rind_colour]"] = I
	overlays |= fruit_icon_cache["rind-[rind_colour]"]
	if(!fruit_icon_cache["slice-[rind_colour]"])
		var/image/I = image(icon,"fruit_slice")
		I.color = flesh_colour
		fruit_icon_cache["slice-[rind_colour]"] = I
	overlays |= fruit_icon_cache["slice-[rind_colour]"]

/obj/item/chems/food/grown/afterattack(atom/target, mob/user, flag)
	if(!flag && isliving(user))
		var/mob/living/M = user
		M.aim_at(target, src)
		return
	. = ..()

/obj/item/chems/food/grown/handle_reflexive_fire(var/mob/user, var/atom/aiming_at)
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] reflexively hurls \the [src] at \the [aiming_at]!"))
		user.throw_item(get_turf(aiming_at), src)
		user.trigger_aiming(TARGET_CAN_CLICK)
