/mob/living/simple_animal/passive/deer
	name           = "deer"
	gender         = NEUTER
	icon           = 'icons/mob/simple_animal/doe.dmi'
	desc           = "A fleet-footed forest animal known for its grace, speed and timidity."
	speak_emote    = list("bleats")
	emote_hear     = list("bleats")
	emote_see      = list("shakes its head", "stamps a hoof", "looks around quickly")
	emote_speech   = list("Ough!", "Ourgh!", "Mroough!", "Broough?")
	speak_chance   = 0.5
	turns_per_wander = 5
	see_in_dark    = 6
	faction        = "deer"
	max_health     = 60
	butchery_data  = /decl/butchery_data/animal/ruminant/deer
	natural_weapon = /obj/item/natural_weapon/hooves
	mob_size       = MOB_SIZE_LARGE

/mob/living/simple_animal/passive/deer/doe
	name           = "doe"
	icon           = 'icons/mob/simple_animal/doe.dmi'
	butchery_data  = /decl/butchery_data/animal/ruminant/deer
	gender         = FEMALE
	speak_emote    = list("bleats")
	emote_hear     = list("bleats")

/mob/living/simple_animal/passive/deer/buck
	name           = "buck"
	icon           = 'icons/mob/simple_animal/buck.dmi'
	butchery_data  = /decl/butchery_data/animal/ruminant/deer/buck
	gender         = MALE
	speak_emote    = list("bellows")
	emote_hear     = list("bellows")

/mob/living/simple_animal/passive/deer/Initialize()

	if(gender == NEUTER)
		if(prob(10)) // Internet seems to think a 10:1 ratio of bucks to does isn't uncommon, adjust later if this is bollocks
			name = "buck"
			icon = 'icons/mob/simple_animal/buck.dmi'
			butchery_data = /decl/butchery_data/animal/ruminant/deer/buck
			gender = MALE
			speak_emote = list("bellows")
			emote_hear  = list("bellows")
		else
			name = "doe"
			icon = 'icons/mob/simple_animal/doe.dmi'
			butchery_data = /decl/butchery_data/animal/ruminant/deer
			gender = FEMALE

	return ..()
