/decl/natural_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1
	name = "sharp bite"

/decl/natural_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = 1
	edge = 1
	name = "claws"
	usable_with_limbs = list(BP_L_HAND, BP_R_HAND)
	var/blocked_by_gloves = TRUE

/decl/natural_attack/claws/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	return (!user.gloves || !blocked_by_gloves)

/decl/natural_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(!affecting)
		return ..()

	attack_damage = Clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [affecting.name]!</span>")
		return 0

	switch(zone)
		if(BP_HEAD, BP_MOUTH, BP_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2) user.visible_message("<span class='danger'>[user] scratched [target] across \his cheek!</span>")
				if(3 to 4)
					user.visible_message(pick(
						80; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [pick("face", "neck", affecting.name)]!</span>"),
						20; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("[target] in the [affecting.name]", "[target] across \his [pick("face", "neck", affecting.name)]")]!</span>"),
						))
				if(5)
					user.visible_message(pick(
						"<span class='danger'>[user] rakes \his [pick(attack_noun)] across [target]'s [pick("face", "neck", affecting.name)]!</span>",
						"<span class='danger'>[user] tears \his [pick(attack_noun)] into [target]'s [pick("face", "neck", affecting.name)]!</span>",
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] [pick("scratched", "grazed")] [target]'s [affecting.name]!</span>")
				if(3 to 4)
					user.visible_message(pick(
						80; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [affecting.name]!</span>"),
						20; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("[target] in the [affecting.name]", "[target] across \his [affecting.name]")]!</span>"),
						))
				if(5)		user.visible_message("<span class='danger'>[user] tears \his [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!</span>")

/decl/natural_attack/claws/strong
	attack_verb = list("slashed")
	damage = 5
	shredding = 1
	name = "strong claws"

/decl/natural_attack/claws/strong/gloves
	blocked_by_gloves = FALSE

/decl/natural_attack/bite/strong
	attack_verb = list("mauled")
	damage = 8
	shredding = 1
	name = "strong bite"

/decl/natural_attack/slime_glomp
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2
	name = "glomp"
	usable_with_limbs = list(BP_CHEST, BP_GROIN)

/decl/natural_attack/slime_glomp/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	user.apply_stored_shock_to(target)

/decl/natural_attack/stomp/weak
	attack_verb = list("jumped on")
	name = "weak stomp"

/decl/natural_attack/stomp/weak/get_unarmed_damage()
	return damage

/decl/natural_attack/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(affecting)
		user.visible_message(SPAN_WARNING("\The [user] jumped up and down on \the [target]'s [affecting.name]!"))
	else
		user.visible_message(SPAN_WARNING("\The [user] jumped up and down on \the [target]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/decl/natural_attack/tail
	attack_verb = list ("bludgeoned", "lashed", "smacked", "whapped")
	attack_noun = list ("tail")
	name = "tail swipe"
	usable_with_limbs = list(BP_GROIN)

/decl/natural_attack/tail/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone) //ensures that you can't tail someone in the skull

	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))

		return 0

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]

	if(E && !E.is_stump())

		return 1


	E = user.organs_by_name[BP_R_FOOT]

	if(E && !E.is_stump())

		return 1

	return 0

/decl/natural_attack/tail/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(!affecting)
		return ..()

	var/organ = affecting.name
	attack_damage = Clamp(attack_damage, 1, 6)
	attack_damage = 3 + attack_damage - rand(1, 5)
	switch(attack_damage)

		if(1 to 5)	user.visible_message("<span class='danger'>[user] glanced [target] with their [pick(attack_noun)] in the [organ]!</span>")

		if(6 to 7)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ] with their [pick(attack_noun)]!</span>")

		if(8)		user.visible_message("<span class='danger'>[user] landed a heavy blow with their [pick(attack_noun)] against [target]'s [organ]!</span>")

/decl/natural_attack/punch/weak
	attack_verb = list("swiped", "smacked", "smecked")
	name = "smek"

/decl/natural_attack/punch/starborn
	attack_verb = list("scorched", "burned", "fried")
	shredding = 1
	name = "starborn strike"

/decl/natural_attack/punch/starborn/get_damage_type()
	return BURN

/decl/natural_attack/bite/venom
	attack_verb = list("bit", "sank their fangs into")
	attack_sound = 'sound/weapons/bite.ogg'
	damage = 5
	delay = 120
	name = "venomous bite"

/decl/natural_attack/bite/venom/get_damage_type()
	return TOX
