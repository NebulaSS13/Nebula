
/obj/item/forensics/sample
	name = "forensic sample"
	icon = 'icons/obj/forensics.dmi'
	max_health = 1
	var/object
	var/list/possible_evidence_types = list(/datum/forensics/fibers)
	var/list/evidence

/obj/item/forensics/sample/Initialize(mapload, var/atom/supplied)
	. = ..(mapload)
	if(supplied)
		copy_evidence(supplied)
		name = "[initial(name)] (\the [supplied])"
		object = "[supplied], at [get_area_name(supplied)]"
	update_icon()

/obj/item/forensics/sample/Destroy()
	. = ..()
	QDEL_NULL_LIST(evidence)

/obj/item/forensics/sample/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && object)
		to_chat(user, "The label says: '[object]'.")

/obj/item/forensics/sample/proc/copy_evidence(var/atom/supplied)
	var/datum/extension/forensic_evidence/forensics = get_extension(supplied, /datum/extension/forensic_evidence)
	if(forensics)
		for(var/T in possible_evidence_types)
			var/datum/forensics/F = forensics.evidence[T]
			if(F)
				LAZYADD(evidence, F.Clone())
				if(F.remove_on_transfer)
					forensics.remove_data(T)

/obj/item/forensics/sample/proc/merge_evidence(var/obj/item/forensics/sample/supplied, var/mob/user)
	if(!LAZYLEN(supplied.evidence))
		return 0
	// no merging prints with fibers
	if(!same_entries(possible_evidence_types, supplied.possible_evidence_types))
		return
	merge_evidence_list(supplied.evidence)
	SetName("[initial(name)] (combined)")
	object = supplied.object + ", " + object
	to_chat(user, SPAN_NOTICE("You combine \the [supplied] into \the [src]."))
	return 1

/obj/item/forensics/sample/proc/merge_evidence_list(var/list/new_evidence)
	LAZYDISTINCTADD(evidence, new_evidence)

/obj/item/forensics/sample/attackby(var/obj/O, var/mob/user)
	if(O.type == src.type)
		if(user.try_unequip(O) && merge_evidence(O, user))
			qdel(O)
		return 1
	return ..()