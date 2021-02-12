// Used for an brain or posibrain being installed into a human.
/obj/item/organ/internal/brain_holder
	name = "brain interface"
	icon_state = "mmi-empty"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	var/obj/item/brain_interface/stored_brain
	var/datum/mind/persistantMind //Mind that the organ will hold on to after being removed, used for transfer_and_delete
	var/ownerckey // used in the event the owner is out of body

/obj/item/organ/internal/brain_holder/Destroy()
	stored_brain = null
	return ..()

/obj/item/organ/internal/brain_holder/Initialize(mapload, var/internal)
	. = ..()
	if(!stored_brain)
		stored_brain = new /obj/item/brain_interface/organic(src)
	update_from_brain()
	persistantMind = owner.mind
	ownerckey = owner.ckey

/obj/item/organ/internal/brain_holder/proc/update_from_brain()
	if(!owner) 
		return
	stored_brain.update_icon()
	name = stored_brain.name
	desc = stored_brain.desc
	icon = stored_brain.icon
	icon_state = stored_brain.icon_state

	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.switch_from_dead_to_living_mob_list()
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/brain_holder/cut_away(var/mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		removed(user, 0)
		parent.implants += transfer_and_delete()

/obj/item/organ/internal/brain_holder/removed()
	if(owner && owner.mind)
		persistantMind = owner.mind
		if(owner.ckey)
			ownerckey = owner.ckey
	..()

/obj/item/organ/internal/brain_holder/proc/transfer_and_delete()
	if(stored_brain)
		. = stored_brain
		stored_brain.forceMove(src.loc)
		if(persistantMind)
			persistantMind.transfer_to(stored_brain.holding_brain.brainmob)
		else
			var/response = input(find_dead_player(ownerckey, 1), "Your [initial(stored_brain.name)] has been removed from your body. Do you wish to return to life?", "Robotic Rebirth") as anything in list("Yes", "No")
			if(response == "Yes")
				persistantMind.transfer_to(stored_brain.holding_brain.brainmob)
	qdel(src)
