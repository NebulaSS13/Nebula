/mob
	var/bloody_hands = null
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/feet_blood_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

/obj/item/chems/glass/rag
	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = @"[5]"
	volume = 10
	can_be_placed_into = null
	item_flags = ITEM_FLAG_NO_BLUDGEON
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = 0

	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes

/obj/item/chems/glass/rag/Initialize()
	. = ..()
	update_name()

/obj/item/chems/glass/rag/Destroy()
	var/obj/item/chems/food/drinks/bottle/bottle = loc
	if(istype(bottle) && bottle.rag == src)
		bottle.rag = null
		bottle.update_icon()
	STOP_PROCESSING(SSobj, src) //so we don't continue turning to ash while gc'd
	. = ..()

/obj/item/chems/glass/rag/attack_self(mob/user)
	if(on_fire && user.unEquip(src))
		user.visible_message(SPAN_NOTICE("\The [user] stamps out [src]."), SPAN_NOTICE("You stamp out [src]."))
		extinguish()
	else
		remove_contents(user)

/obj/item/chems/glass/rag/attackby(obj/item/W, mob/user)
	if(isflamesource(W))
		if(on_fire)
			to_chat(user, SPAN_WARNING("\The [src] is already blazing merrily!"))
			return
		ignite()
		if(on_fire)
			visible_message(SPAN_DANGER("\The [user] lights \the [src] with \the [W]."))
		else
			to_chat(user, SPAN_WARNING("You attempt to light \the [src] with \the [W], but it doesn't seem to be flammable."))
		update_name()
		return
	. = ..()

/obj/item/chems/glass/rag/proc/update_name()
	if(on_fire)
		SetName("burning [initial(name)]")
	else if(reagents && reagents.total_volume)
		SetName("damp [initial(name)]")
	else
		SetName("dry [initial(name)]")

/obj/item/chems/glass/rag/on_update_icon()
	if(on_fire)
		icon_state = "raglit"
	else
		icon_state = "rag"

	var/obj/item/chems/food/drinks/bottle/B = loc
	if(istype(B))
		B.update_icon()

/obj/item/chems/glass/rag/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the [trans_dest]" : "\the [user.loc]"
		user.visible_message("<span class='danger'>\The [user] begins to wring out [src] over [target_text].</span>", "<span class='notice'>You begin to wring out [src] over [target_text].</span>")

		if(do_after(user, reagents.total_volume*5, progress = 0)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message("<span class='danger'>\The [user] wrings out [src] over [target_text].</span>", "<span class='notice'>You finish to wringing out [src].</span>")
			update_name()

/obj/item/chems/glass/rag/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>The [initial(name)] is dry!</span>")
	else
		user.visible_message("\The [user] starts to wipe down [A] with [src]!")
		reagents.splash(A, 1) //get a small amount of liquid on the thing we're wiping.
		update_name()
		if(do_after(user,30, progress = 1))
			user.visible_message("\The [user] finishes wiping off the [A]!")
			if(isturf(A))
				var/turf/T = A
				T.clean(src, user)
			else
				A.clean_blood()

/obj/item/chems/glass/rag/attack(atom/target, mob/user , flag)
	if(isliving(target))
		var/mob/living/M = target
		if(on_fire)
			user.visible_message("<span class='danger'>\The [user] hits [target] with [src]!</span>",)
			user.do_attack_animation(src)
			M.IgniteMob()
		else if(reagents.total_volume)
			if(user.zone_sel.selecting == BP_MOUTH)
				user.do_attack_animation(src)
				user.visible_message(
					"<span class='danger'>\The [user] smothers [target] with [src]!</span>",
					"<span class='warning'>You smother [target] with [src]!</span>",
					"You hear some struggling and muffled cries of surprise"
					)

				//it's inhaled, so... maybe CHEM_INJECT doesn't make a whole lot of sense but it's the best we can do for now
				reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INJECT)
				update_name()
			else
				wipe_down(target, user)
		return

	return ..()

/obj/item/chems/glass/rag/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/structure/reagent_dispensers))
		if(!reagents.get_free_space())
			to_chat(user, "<span class='warning'>\The [src] is already soaked.</span>")
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			user.visible_message("<span class='notice'>\The [user] soaks [src] using [A].</span>", "<span class='notice'>You soak [src] using [A].</span>")
			update_name()
		return

	if(!on_fire && istype(A) && (src in user))
		if(ATOM_IS_OPEN_CONTAINER(A) && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

/obj/item/chems/glass/rag/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 50 + T0C)
		ignite()
	if(exposed_temperature >= 900 + T0C)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)

//rag must have a minimum of 2 units welder fuel and at least 80% of the reagents must be welder fuel.
//maybe generalize flammable reagents someday
/obj/item/chems/glass/rag/proc/can_ignite()
	var/total_fuel = 0
	var/total_volume = 0
	if(reagents)
		total_volume += reagents.total_volume
		for(var/datum/reagent/R in reagents.reagent_list)
			total_fuel = R.volume * R.fuel_value
	. = (total_fuel >= 2 && total_fuel >= total_volume*0.5)

/obj/item/chems/glass/rag/proc/ignite()
	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from matches
	if(reagents.get_reagent_amount(/datum/reagent/toxin/phoron)) // the phoron explodes when exposed to fire
		visible_message(SPAN_DANGER("\The [src] explodes!"))
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/phoron) / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return

	START_PROCESSING(SSobj, src)
	set_light(0.5, 0.1, 2, 2, "#e38f46")
	on_fire = 1
	update_name()
	update_icon()

/obj/item/chems/glass/rag/proc/extinguish()
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	on_fire = 0

	//rags sitting around with 1 second of burn time left is dumb.
	//ensures players always have a few seconds of burn time left when they light their rag
	if(burn_time <= 5)
		visible_message("<span class='warning'>\The [src] falls apart!</span>")
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)
	update_name()
	update_icon()

/obj/item/chems/glass/rag/Process()
	if(!can_ignite())
		visible_message("<span class='warning'>\The [src] burns out.</span>")
		extinguish()

	//copied from matches
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(burn_time <= 0)
		STOP_PROCESSING(SSobj, src)
		new /obj/effect/decal/cleanable/ash(location)
		qdel(src)
		return

	reagents.remove_reagent(/datum/reagent/fuel, reagents.maximum_volume/25)
	update_name()
	burn_time--
