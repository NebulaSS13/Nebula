/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 10

/obj/item/organ/internal/kidneys/robotize(var/company = /decl/prosthetics_manufacturer, var/skip_prosthetics, var/keep_organs, var/apply_material = /decl/material/solid/metal/steel)
	. = ..()
	icon_state = "kidneys-prosthetic"

/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	if(REAGENT_VOLUME(owner.reagents, /decl/material/liquid/drink/coffee))
		if(is_bruised())
			owner.adjustToxLoss(0.1)
		else if(is_broken())
			owner.adjustToxLoss(0.3)

	if(is_bruised())
		if(prob(5) && REAGENT_VOLUME(reagents, /decl/material/solid/potassium) < 5)
			reagents.add_reagent(/decl/material/solid/potassium, REM*5)
	if(is_broken())
		if(REAGENT_VOLUME(owner.reagents, /decl/material/solid/potassium) < 15)
			owner.reagents.add_reagent(/decl/material/solid/potassium, REM*2)

	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!LAZYACCESS(owner.chem_effects, CE_ANTITOX))
		if(prob(33))
			if(is_broken())
				owner.adjustToxLoss(0.5)
			if(status & ORGAN_DEAD)
				owner.adjustToxLoss(1)


