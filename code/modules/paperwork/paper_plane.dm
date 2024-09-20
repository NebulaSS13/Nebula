///////////////////////////////////////////////////
// Paper Plane
///////////////////////////////////////////////////
/obj/item/paper_plane
	name            = "paper plane"
	desc            = "A sheet of paper folded into a plane."
	icon            = 'icons/obj/items/paperwork/paper_plane.dmi'
	icon_state      = ICON_STATE_WORLD
	layer           = ABOVE_OBJ_LAYER
	does_spin       = FALSE
	throw_range     = 20
	throw_speed     = 1
	w_class         = ITEM_SIZE_TINY
	item_flags      = ITEM_FLAG_CAN_TAPE
	attack_verb     = list("stabbed", "pricked")
	material        = /decl/material/solid/organic/paper
	var/obj/item/paper/my_paper //The sheet of paper this paper_plane is made of

/obj/item/paper_plane/proc/set_paper(var/obj/item/paper/_paper)
	if(my_paper)
		return FALSE
	_paper.forceMove(src)
	my_paper = _paper
	if(my_paper.material)
		set_material(my_paper.material.type)
	color = my_paper.color
	update_icon()
	return TRUE

/obj/item/paper_plane/proc/unfold(var/mob/user)
	if(user)
		if(!user.try_unequip(src))
			return
		user.visible_message(SPAN_NOTICE("\The [user] unfolds \the [src]."), SPAN_NOTICE("You unfold \the [src]."))
		if(my_paper)
			user.put_in_active_hand(my_paper)
	else if(my_paper)
		my_paper.dropInto(loc)
	my_paper = null
	qdel(src)
	return TRUE

/obj/item/paper_plane/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		//Only hurt if received right into the eyes
		if(TT.target_zone == BP_EYES && !(BP_EYES in M.get_covered_body_parts()))
			M.apply_damage(1, BRUTE, BP_EYES, 0, src, 0)
			M.apply_effects(2, 0, 0, 0, 1, 0, 15)
	take_damage(TT.speed * w_class)

/obj/item/paper_plane/attack_self(mob/user)
	if(user.a_intent == I_HURT)
		return crumple(user)
	return unfold(user)

/obj/item/paper_plane/proc/crumple(var/mob/user)
	if(user)
		user.visible_message(SPAN_WARNING("\The [user] crumples \the [src]."))

	if(my_paper)
		my_paper.crumple()
		unfold(user)
	else
		//If no paper, just make one
		if(user)
			user.try_unequip(src)
		var/obj/item/paper/P = new(loc)
		P.crumple()
		qdel(src)
	return TRUE

///////////////////////////////////////////////////
// Alt Interactions
///////////////////////////////////////////////////
/decl/interaction_handler/make_paper_plane
	name = "Fold Into Paper Plane"
	expected_target_type = /obj/item/paper

/decl/interaction_handler/make_paper_plane/is_possible(obj/item/paper/target, mob/user, obj/item/prop)
	return ..() && !target.is_crumpled

/decl/interaction_handler/make_paper_plane/invoked(atom/target, mob/user, obj/item/prop)
	user.visible_message(SPAN_NOTICE("\The [user] folds \the [target] into a plane."), SPAN_NOTICE("You fold \the [target] into a plane."))
	var/obj/item/paper_plane/PP = new
	user.try_unequip(target, PP)
	PP.set_paper(target)
	user.put_in_hands(PP)
	return TRUE

/obj/item/paper/get_alt_interactions(mob/user)
	. = ..()
	LAZYDISTINCTADD(., /decl/interaction_handler/make_paper_plane)