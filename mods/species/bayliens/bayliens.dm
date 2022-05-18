/decl/modpack/bayliens
	name = "Baystation 12 Aliens"

/mob/living/carbon/human/Process_Spacemove()
	. = ..()
	if(!. && inertia_dir)
		// This is horrible but short of spawning a jetpack inside the organ than locating
		// it, I don't really see another viable approach short of a total jetpack refactor.
		for(var/obj/item/organ/internal/powered/jets/jet in get_internal_organs())
			if(!jet.is_broken() && jet.active)
				inertia_dir = 0
				return 1
		// End 'eugh'

