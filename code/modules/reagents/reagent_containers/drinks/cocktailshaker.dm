/obj/item/chems/drinks/shaker
	name = "shaker"
	desc = "A three-piece Cobbler-style shaker. Used to mix, cool, and strain drinks."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60]" //Professional bartender should be able to transfer as much as needed
	chem_volume = 120
	center_of_mass = @'{"x":17,"y":10}'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

/obj/item/chems/drinks/shaker/attack_self(mob/user)
	if(user.skill_check(SKILL_COOKING, SKILL_PROF))
		user.visible_action_message("shake", "\the [src] briskly in one hand", dangerous = "rose", self_postfix = ".", other_postfix = ", with supreme confidence and competence.")
		mix()
		return
	if(user.skill_check(SKILL_COOKING, SKILL_ADEPT))
		user.visible_action_message("shake", "\the [src] briskly, with some skill.")
		mix()
		return
	else
		user.visible_action_message("shake", "\the [src] gingerly.")
		if(prob(15) && (reagents && REAGENT_TOTAL_VOLUME(reagents)))
			user.visible_action_message("spill", "the contents of \the [src] over $USER_SELF$!", dangerous = ACTION_DANGER_WARNING)
			reagents.splash(user, REAGENT_TOTAL_VOLUME(reagents))
		else
			mix()

/obj/item/chems/drinks/shaker/proc/mix()
	if(reagents && REAGENT_TOTAL_VOLUME(reagents))
		atom_flags &= ~ATOM_FLAG_NO_REACT
		HANDLE_REACTIONS(reagents)
		addtimer(CALLBACK(src, PROC_REF(stop_react)), SSmaterials.wait)

/obj/item/chems/drinks/shaker/proc/stop_react()
	atom_flags |= ATOM_FLAG_NO_REACT