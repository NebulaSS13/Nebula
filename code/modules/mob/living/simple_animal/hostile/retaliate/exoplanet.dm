/mob/living/simple_animal/hostile/beast
	ai = /datum/mob_controller/aggressive/beast
	abstract_type = /mob/living/simple_animal/hostile/beast
	nutrition = 300

/mob/living/simple_animal/hostile/beast/get_nutrition()
	return nutrition

/mob/living/simple_animal/hostile/beast/get_satiated_nutrition()
	return 250

/mob/living/simple_animal/hostile/beast/get_max_nutrition()
	return 300

/mob/living/simple_animal/proc/name_species()
	set name = "Name Alien Species"
	set category = "IC"
	set src in view()

	if(!global.overmaps_by_name[OVERMAP_ID_SPACE])
		return
	if(!CanInteract(usr, global.conscious_topic_state))
		return
	for(var/planet_id in SSmapping.planetoid_data_by_id)
		var/datum/planetoid_data/E = SSmapping.planetoid_data_by_id[planet_id]
		if(istype(E) && (src in E.fauna.live_fauna))
			var/newname = input("What do you want to name this species?", "Species naming", E.get_random_species_name()) as text|null
			newname = sanitize_name(newname, allow_numbers = TRUE, force_first_letter_uppercase = FALSE)
			if(newname && CanInteract(usr, global.conscious_topic_state))
				if(E.rename_species(type, newname))
					to_chat(usr, SPAN_NOTICE("This species will be known from now on as '[newname]'."))
				else
					to_chat(usr, SPAN_WARNING("This species has already been named!"))
			return

/mob/living/simple_animal/hostile/beast/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon = 'icons/mob/simple_animal/samak.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal_fast,
		/decl/move_intent/run/animal_fast
	)
	max_health = 125
	natural_weapon = /obj/item/natural_weapon/claws
	cold_damage_per_tick = 0
	ai = /datum/mob_controller/aggressive/beast/samak
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
	)
	base_movement_delay = 2

/datum/mob_controller/aggressive/beast/samak
	speak_chance = 1.25
	emote_speech = list("Hruuugh!","Hrunnph")
	emote_see    = list("paws the ground","shakes its mane","stomps")
	emote_hear   = list("snuffles")

/mob/living/simple_animal/hostile/beast/samak/alt
	desc = "A fast, armoured predator accustomed to hiding and ambushing."
	icon = 'icons/mob/simple_animal/samak_alt.dmi'

/mob/living/simple_animal/hostile/beast/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	faction = "diyaab"
	icon = 'icons/mob/simple_animal/diyaab.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)
	max_health = 25
	natural_weapon = /obj/item/natural_weapon/claws/weak
	cold_damage_per_tick = 0
	mob_size = MOB_SIZE_SMALL
	ai = /datum/mob_controller/aggressive/beast/diyaab
	base_movement_delay = 1

/datum/mob_controller/aggressive/beast/diyaab
	speak_chance = 1.25
	emote_speech = list("Awrr?","Aowrl!","Worrl")
	emote_see    = list("sniffs the air cautiously","looks around")
	emote_hear   = list("snuffles")

/mob/living/simple_animal/hostile/beast/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon = 'icons/mob/simple_animal/shantak.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)
	max_health = 75
	natural_weapon = /obj/item/natural_weapon/claws
	cold_damage_per_tick = 0
	ai = /datum/mob_controller/aggressive/beast/shantak

/datum/mob_controller/aggressive/beast/shantak
	speak_chance = 0.5
	emote_speech = list("Shuhn","Shrunnph?","Shunpf")
	emote_see    = list("scratches the ground","shakes out its mane","tinkles gently")

/mob/living/simple_animal/hostile/beast/shantak/alt
	desc = "A piglike creature with a long and graceful mane. Don't be fooled by its beauty."
	icon = 'icons/mob/simple_animal/shantak_alt.dmi'
	ai = /datum/mob_controller/aggressive/beast/shantak/alt

/datum/mob_controller/aggressive/beast/shantak/alt
	emote_see = list("scratches the ground","shakes out it's mane","rustles softly")

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	icon = 'icons/mob/simple_animal/yithian.dmi'
	mob_size = MOB_SIZE_TINY

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon = 'icons/mob/simple_animal/tindalos.dmi'
	mob_size = MOB_SIZE_TINY

/mob/living/simple_animal/thinbug
	name = "taki"
	desc = "It looks like a bunch of legs."
	icon = 'icons/mob/simple_animal/bug.dmi'
	ai = /datum/mob_controller/thinbug
	mob_size = MOB_SIZE_MINISCULE

/datum/mob_controller/thinbug
	speak_chance = 0.25
	emote_hear = list("scratches the ground","chitters")

/mob/living/simple_animal/hostile/royalcrab
	name = "cragenoy"
	desc = "It looks like a crustacean with an exceedingly hard carapace. Watch the pinchers!"
	faction = "crab"
	icon = 'icons/mob/simple_animal/royalcrab.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/pincers
	ai = /datum/mob_controller/aggressive/thinbug
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT
	)
	base_movement_delay = 1

/datum/mob_controller/aggressive/thinbug
	speak_chance = 0.25
	emote_see = list("skitters","oozes liquid from its mouth", "scratches at the ground", "clicks its claws")
	only_attack_enemies = TRUE

/mob/living/simple_animal/hostile/beast/charbaby
	name = "charbaby"
	desc = "A huge grubby creature."
	icon = 'icons/mob/simple_animal/char.dmi'
	mob_size = MOB_SIZE_LARGE
	max_health = 45
	natural_weapon = /obj/item/natural_weapon/charbaby
	return_damage_min = 2
	return_damage_max = 3
	harm_intent_damage = 1
	blood_color = COLOR_NT_RED
	natural_armor = list(
		ARMOR_LASER = ARMOR_LASER_HANDGUNS
	)
	base_movement_delay = 2

/obj/item/natural_weapon/charbaby
	name = "scalding hide"
	atom_damage_type =  BURN
	attack_verb = list("singed")

/mob/living/simple_animal/hostile/beast/charbaby/default_hurt_interaction(mob/user)
	. = ..()
	if(. && ishuman(user))
		reflect_unarmed_damage(user, BURN, "amorphous mass")

/mob/living/simple_animal/hostile/beast/charbaby/apply_attack_effects(mob/living/target)
	. = ..()
	if(prob(10))
		target.adjust_fire_stacks(1)
		target.IgniteMob()

/mob/living/simple_animal/hostile/beast/shantak/lava
	desc = "A vaguely canine looking beast. It looks as though its fur is made of stone wool."
	icon = 'icons/mob/simple_animal/lavadog.dmi'
	ai = /datum/mob_controller/aggressive/beast/shantak/lava

/datum/mob_controller/aggressive/beast/shantak/lava
	emote_speech = list("Karuph","Karump")