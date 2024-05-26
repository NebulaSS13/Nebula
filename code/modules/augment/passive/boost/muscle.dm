//This one must do special handling because you need 2, so other than vars it doesn't share tht much
/datum/skill_buff/augment/muscle

/obj/item/organ/internal/augment/boost/muscle
	buffs = list(SKILL_HAULING = 1)
	buffpath = /datum/skill_buff/augment/muscle
	name = "mechanical muscles"
	allowed_organs = list(BP_AUGMENT_R_LEG, BP_AUGMENT_L_LEG)
	icon_state = "muscule"
	desc = "Nanofiber tendons powered by an array of actuators to help the wearer mantain speed even while encumbered. You may want to install these in pairs to see a result."
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":4,"magnets":3,"biotech":3}'
	var/obj/item/organ/internal/augment/boost/muscle/other //we need two for these

/obj/item/organ/internal/augment/boost/muscle/on_add_effects()
	. = ..()
	if(!owner)
		return
	//1.st Determine where we are and who we should be asking for guidance
	//we must be second to activate buff
	if(organ_tag == BP_AUGMENT_L_LEG)
		other = GET_INTERNAL_ORGAN(owner, BP_AUGMENT_R_LEG)
	else if(organ_tag == BP_AUGMENT_R_LEG)
		other = GET_INTERNAL_ORGAN(owner, BP_AUGMENT_L_LEG)
	if(other && istype(other))
		var/succesful = TRUE
		if(owner.get_skill_value(SKILL_HAULING) < SKILL_PROF)
			succesful = FALSE
			var/datum/skill_buff/augment/muscle/A
			A = owner.buff_skill(buffs, 0, buffpath)
			if(A && istype(A))
				succesful = TRUE
				A.id = id

		if(succesful)
			other.other = src
			other.active = TRUE
			active = TRUE

/obj/item/organ/internal/augment/boost/muscle/on_remove_effects(mob/living/last_owner)
	. = ..()
	if(!active)
		return
	var/list/B = owner.fetch_buffs_of_type(buffpath, 0)
	for(var/datum/skill_buff/augment/muscle/D in B)
		if(D.id == id)
			D.remove()
			break
	if(other)
		other.active = FALSE
		other.other = null
		other = null
	active = FALSE

/obj/item/organ/internal/augment/boost/muscle/Destroy()
	. = ..()
	other = null //If somehow onRemove didn't handle it
