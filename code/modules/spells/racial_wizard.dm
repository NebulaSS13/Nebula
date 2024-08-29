//this file is full of all the racial spells/artifacts/etc that each species has.

/obj/item/magic_rock
	name = "magical rock"
	desc = "Legends say that this rock will unlock the true potential of anyone who touches it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "magic rock"
	w_class = ITEM_SIZE_SMALL
	throw_speed = 1
	throw_range = 3
	material = /decl/material/solid/stone/basalt
	var/list/potentials = list(
		SPECIES_HUMAN = /obj/item/bag/cash/infinite
	)

/obj/item/magic_rock/attack_self(mob/user)
	if(!ishuman(user))
		to_chat(user, "\The [src] can do nothing for such a simple being.")
		return
	var/mob/living/human/H = user
	var/reward = potentials[H.species.get_root_species_name(H)] //we get body type because that lets us ignore subspecies.
	if(!reward)
		to_chat(user, "\The [src] does not know what to make of you.")
		return
	for(var/spell/S in user.mind.learned_spells)
		if(istype(S,reward))
			to_chat(user, "\The [src] can do no more for you.")
			return
	var/a = new reward()
	if(ispath(reward,/spell))
		H.add_spell(a)
	else if(ispath(reward,/obj))
		H.put_in_hands(a)
	to_chat(user, "\The [src] crumbles in your hands.")
	qdel(src)

/obj/item/bag/cash/infinite
	storage = /datum/storage/bag/cash/infinite

/obj/item/bag/cash/infinite/WillContain()
	return list(/obj/item/cash/c1000)

/spell/messa_shroud/choose_targets()
	return list(get_turf(holder))

/spell/messa_shroud/cast(var/list/targets, mob/user)
	var/turf/T = targets[1]

	if(!istype(T))
		return

	var/obj/O = new /obj(T)
	O.set_light(range, -10, "#ffffff")

	spawn(duration)
		qdel(O)

/mob/observer/eye/freelook/wizard_eye
	name_sufix = "Wizard Eye"

/mob/observer/eye/freelook/wizard_eye/Initialize()
	. = ..() //we dont use the Ai one because it has AI specific procs imbedded in it.
	visualnet = cameranet

/mob/living/proc/release_eye()
	set name = "Release Vision"
	set desc = "Return your sight to your body."
	set category = "Abilities"

	verbs -= /mob/living/proc/release_eye //regardless of if we have an eye or not we want to get rid of this verb.

	if(!eyeobj)
		return
	eyeobj.release(src)

/mob/observer/eye/freelook/wizard_eye/Destroy()
	if(isliving(eyeobj.owner))
		var/mob/living/L = eyeobj.owner
		L.release_eye()
	qdel(eyeobj)
	return ..()