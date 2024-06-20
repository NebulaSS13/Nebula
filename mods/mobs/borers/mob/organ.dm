//CORTICAL BORER ORGANS.
/obj/item/organ/internal/borer
	name = "cortical borer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borer"
	organ_tag = BP_BRAIN
	desc = "A disgusting space slug."
	parent_organ = BP_HEAD
	var/list/chemical_types

/obj/item/organ/internal/borer/Process()
	SHOULD_CALL_PARENT(FALSE)
	// Borer husks regenerate health, feel no pain, and are resistant to stuns and brainloss.
	for(var/chem_name in chemical_types)
		var/chem = chemical_types[chem_name]
		if(REAGENT_VOLUME(owner.reagents, chem) < 3)
			owner.add_to_reagents(chem, 5)

	// They're also super gross and ooze ichor.
	if(prob(5))
		var/mob/living/human/H = owner
		if(!istype(H))
			return

		blood_splatter(H, null, 1)
		var/obj/effect/decal/cleanable/blood/splatter/goo = locate() in get_turf(owner)
		if(goo)
			goo.SetName("husk ichor")
			goo.desc = "A thick goo that reeks of decay."
			goo.basecolor = "#412464"
			goo.update_icon()

/obj/item/organ/internal/borer/on_remove_effects(mob/living/last_owner)
	..()

	var/mob/living/simple_animal/borer/B = last_owner.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = last_owner.ckey

	spawn(0)
		qdel(src)
