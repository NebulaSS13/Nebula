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
	selector_icon_state = "attack_claws"
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = 1
	edge = 1
	name = "claws"
	usable_with_limbs = list(BP_L_HAND, BP_R_HAND)
	var/blocked_by_gloves = TRUE

/decl/natural_attack/claws/is_usable(var/mob/living/human/user, var/mob/living/human/target, var/zone)
	return (!user.get_equipped_item(slot_gloves_str) || !blocked_by_gloves)

/decl/natural_attack/claws/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(!affecting)
		return ..()

	var/decl/pronouns/user_gender = user.get_pronouns()
	attack_damage = clamp(attack_damage, 1, 5)
	if(target == user)
		user.visible_message(SPAN_DANGER("\The [user] [pick(attack_verb)] [user_gender.self] in the [affecting.name]!"))
		return 0

	var/decl/pronouns/target_gender = target.get_pronouns()
	var/attack_string
	switch(zone)
		if(BP_HEAD, BP_MOUTH, BP_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					attack_string = "scratches \the [target] across [target_gender.his] cheek"
				if(3 to 4)
					attack_string = pick(
						80; "[pick(attack_verb)] [target]'s [pick("face", "neck", affecting.name)]",
						20; "[pick(attack_verb)] \the [target] [pick("in the [affecting.name]", "across [target_gender.his] [pick("face", "neck", affecting.name)]")]",
					)
				if(5)
					attack_string = pick(
						"rakes [user_gender.his] [pick(attack_noun)] across [target]'s [pick("face", "neck", affecting.name)]",
						"tears [user_gender.his] [pick(attack_noun)] into [target]'s [pick("face", "neck", affecting.name)]",
					)
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)
					attack_string = "[pick("scratched", "grazed")] [target]'s [affecting.name]"
				if(3 to 4)
					attack_string = pick(
						80; "[pick(attack_verb)] [target]'s [affecting.name]",
						20; "[pick(attack_verb)] [pick("[target] in the [affecting.name]", "[target] across [target_gender.his] [affecting.name]")]",
					)
				if(5)
					attack_string = "tears [user_gender.his] [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]"
	if(attack_string)
		user.visible_message(SPAN_DANGER("\The [user] [attack_string]!"))

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
	name = "glomp"
	selector_icon_state = "attack_glomp"
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2
	usable_with_limbs = list(BP_CHEST, BP_GROIN)

/decl/natural_attack/slime_glomp/apply_effects(mob/living/user, mob/living/target, attack_damage, zone)
	. = ..()
	if(.)
		user.apply_stored_shock_to(target)

/decl/natural_attack/stomp/weak
	name = "weak stomp"
	attack_verb = list("jumped on")

/decl/natural_attack/stomp/weak/get_unarmed_damage(mob/living/user, mob/living/victim)
	return damage

/decl/natural_attack/stomp/weak/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(affecting)
		user.visible_message(SPAN_WARNING("\The [user] jumped up and down on \the [target]'s [affecting.name]!"))
	else
		user.visible_message(SPAN_WARNING("\The [user] jumped up and down on \the [target]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/decl/natural_attack/tail
	name = "tail swipe"
	selector_icon_state = "attack_tail"
	attack_verb = list ("bludgeoned", "lashed", "smacked", "whapped")
	attack_noun = list ("tail")
	usable_with_limbs = list(BP_GROIN)
	var/static/list/can_hit_zones = list(
		BP_L_LEG,
		BP_R_LEG,
		BP_L_FOOT,
		BP_R_FOOT,
		BP_GROIN
	)

/decl/natural_attack/tail/is_usable(var/mob/living/human/user, var/mob/living/human/target, var/zone) //ensures that you can't tail someone in the skull
	if(!(zone in can_hit_zones))
		return FALSE
	for(var/foot_tag in list(BP_L_FOOT, BP_R_FOOT))
		if(GET_EXTERNAL_ORGAN(user, foot_tag))
			return TRUE
	return FALSE

/decl/natural_attack/tail/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(!affecting)
		return ..()

	attack_damage = clamp(attack_damage, 1, 6)
	attack_damage = 3 + attack_damage - rand(1, 5)
	switch(attack_damage)

		if(1 to 5)	user.visible_message("<span class='danger'>[user] glanced [target] with their [pick(attack_noun)] in \the [affecting]!</span>")
		if(6 to 7)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \the [affecting] with their [pick(attack_noun)]!</span>")
		if(8)		user.visible_message("<span class='danger'>[user] landed a heavy blow with their [pick(attack_noun)] against [target]'s [affecting.name]!</span>")

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
