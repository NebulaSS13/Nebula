//the fountain of youth/unyouth

/obj/structure/fountain
	name = "strange fountain"
	desc = "The water from the spout is still as if frozen in time, yet the water in the base ripples perpetually."
	icon = 'icons/obj/fountain.dmi'
	icon_state = "fountain"
	density = 1
	anchored = 1
	unacidable = 1
	pixel_x = -16
	var/used = FALSE
	var/increase_age_prob = (100 / 6)

/obj/structure/fountain/Initialize()
	. = ..()
	light_color = get_random_colour(lower = 190)
	set_light(5, 0.5, light_color)

/obj/structure/fountain/attack_hand(var/mob/user)
	if(user.incapacitated())
		return
	if(!CanPhysicallyInteract(user))
		return
	if(used)
		to_chat(user,  SPAN_WARNING("\The [src] is still and lifeless..."))
		return

	var/mob/living/carbon/human/H = user
	var/decl/species/species = user.get_species()
	var/datum/appearance_descriptor/age/age = species && LAZYACCESS(species.appearance_descriptors, "age")
	if(!ishuman(H) || H.isSynthetic() || !species || !age)
		to_chat(user, SPAN_WARNING("A feeling of foreboding stills your hand. The fountain is not for your kind."))
		return

	if(alert("As you reach out to touch the fountain, a feeling of doubt overcomes you. Steel yourself and proceed?",,"Yes", "No") == "Yes")
		visible_message("\The [user] touches \the [src].")
		time_dilation(user)
	else
		visible_message("\The [user] retracts their hand suddenly.")

/obj/structure/fountain/proc/time_dilation(var/mob/living/carbon/human/user)

	for(var/mob/living/L in oviewers(7, src))
		L.flash_eyes(3)
		SET_STATUS_MAX(L, STAT_BLURRY, 9)

	visible_message("<span class='warning'>\The [src] erupts in a bright flash of light!</span>")
	playsound(src,'sound/items/time.ogg',100)

	var/old_age = user.get_age()
	var/new_age = old_age
	if(prob(increase_age_prob))
		new_age += rand(5,15)
	else
		new_age -= rand(5,15)

	var/decl/species/species = user.get_species()
	var/datum/appearance_descriptor/age/age = LAZYACCESS(species.appearance_descriptors, "age")
	// Let's avoid reverting people to children since that has a lot of baggage attached.
	var/min_age = age.standalone_value_descriptors[age.standalone_value_descriptors[age.chargen_min_index]]
	new_age = max(new_age, min_age) // This will clamp to the max defined age already so only need to min()

	if(new_age == old_age)
		to_chat(user, "<span class='cultannounce'>You touch the fountain, and feel your memories sifted through by a great presence. Then, it withdraws, leaving you unchanged.</span>")
	else
		user.set_age(new_age)
		if(new_age < old_age)
			to_chat(user, "<span class='cultannounce'>You touch the fountain. Everything stops - then reverses. You relive in an instant the events of your life. The fountain, yesterday's lunch, your first love, your first kiss. It all feels as though it just happened moments ago. Then it feels like it never happened at all. Time reverses back into normality and continues its advance. You feel great, but why are you here?</span>")
			user.became_younger = TRUE
		else
			to_chat(user, "<span class='cultannounce'>You touch the fountain. All the memories of your life seem to fade into the distant past as seconds drag like years. You feel the inexplicable sensation of your skin tightening and thinning across your entire body as your muscles degrade and your joints weaken. Time returns to its 'normal' pace. You can only just barely remember touching the fountain.</span>")
			user.became_older = TRUE
			user.change_hair_color(80, 80, 80)
			var/max_age = age.standalone_value_descriptors[age.standalone_value_descriptors[length(age.standalone_value_descriptors)]]
			if(new_age >= max_age)
				to_chat(user, "<span class='cultannounce'><b>The burden of the years is too much, and you are reduced to dust.</b></span>")
				user.dust()

	used = TRUE
	desc = "The water flows beautifully from the spout, but the water in the pool does not ripple."

/obj/structure/fountain/mundane
	name = "fountain"
	desc = "A beautifully constructed fountain."
	icon_state = "fountain_g"
	used = TRUE

/obj/structure/fountain/mundane/attack_hand()
	return