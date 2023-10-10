/obj/item/chems/chem_disp_cartridge/foaming_agent/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/foaming_agent, reagents.maximum_volume)

/obj/item/chems/chem_disp_cartridge/polyacid/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/acid/polyacid, reagents.maximum_volume)

/obj/structure/sealant_injector
	name = "sealant tank injector"
	icon = 'icons/obj/structures/sealant_props.dmi'
	icon_state = "injector"
	density = TRUE
	anchored = TRUE

	var/list/cartridges
	var/obj/item/sealant_tank/loaded_tank
	var/max_cartridges = 3

/obj/structure/sealant_injector/Destroy()
	QDEL_NULL_LIST(cartridges)
	QDEL_NULL(loaded_tank)
	. = ..()

/obj/structure/sealant_injector/on_update_icon()
	..()
	if(loaded_tank)
		add_overlay("tank")
	if(length(cartridges))
		add_overlay("carts[length(cartridges)]")

/obj/structure/sealant_injector/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	cartridges = list(
		new /obj/item/chems/chem_disp_cartridge/aluminium(src) = 3,
		new /obj/item/chems/chem_disp_cartridge/foaming_agent(src) = 1,
		new /obj/item/chems/chem_disp_cartridge/polyacid(src) = 1
	)

/obj/structure/sealant_injector/attackby(obj/item/O, mob/user)

	if(istype(O, /obj/item/sealant_tank))
		if(loaded_tank)
			to_chat(user, SPAN_WARNING("\The [src] already has a sealant tank inserted."))
			return TRUE
		if(user.try_unequip(O, src))
			loaded_tank = O
			update_icon()
			return TRUE

	if(istype(O, /obj/item/chems/chem_disp_cartridge))
		if(length(cartridges) >= max_cartridges)
			to_chat(user, SPAN_WARNING("\The [src] is loaded to capacity with cartridges."))
			return TRUE
		if(user.try_unequip(O, src))
			LAZYSET(cartridges, O, 1)
			update_icon()
			return TRUE

	. = ..()

/obj/structure/sealant_injector/proc/try_inject(mob/user)

	if(!loaded_tank)
		to_chat(user, SPAN_WARNING("There is no tank loaded."))
		return TRUE

	var/fill_space = FLOOR(loaded_tank.max_foam_charges - loaded_tank.foam_charges) / 5
	if(fill_space <= 0)
		to_chat(user, SPAN_WARNING("\The [loaded_tank] is full."))
		return TRUE

	var/injected = FALSE
	for(var/obj/item/chems/chem_disp_cartridge/cart in cartridges)
		if(cart.reagents?.total_volume <= cartridges[cart])
			visible_message("\The [src] flashes a red 'empty' light above \the [cart].")
			continue
		injected = TRUE
		cart.reagents.trans_to_holder(loaded_tank.reagents, min(cart.reagents.total_volume, cartridges[cart] * fill_space))
	if(injected)
		playsound(loc, 'sound/effects/refill.ogg', 50, 1)

/obj/structure/sealant_injector/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	if(loaded_tank)
		loaded_tank.dropInto(get_turf(src))
		user.put_in_hands(loaded_tank)
		loaded_tank = null
		update_icon()
		return TRUE
	if(length(cartridges))
		var/obj/cartridge = pick(cartridges)
		cartridges -= cartridge
		cartridge.dropInto(get_turf(user))
		user.put_in_hands(cartridge)
		update_icon()
		return TRUE
	return ..()

/obj/structure/sealant_injector/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/sealant_try_inject)

/decl/interaction_handler/sealant_try_inject
	name = "Inject Sealant"
	expected_target_type = /obj/structure/sealant_injector

/decl/interaction_handler/sealant_try_inject/invoked(var/atom/target, var/mob/user)
	var/obj/structure/sealant_injector/SI = target
	SI.try_inject(user)
