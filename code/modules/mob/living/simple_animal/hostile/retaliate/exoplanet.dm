
/mob/living/simple_animal/hostile/retaliate/beast
	var/hunger = 0
	var/list/prey = list()

/mob/living/simple_animal/hostile/retaliate/beast/ListTargets(var/dist = 7)
	. = ..()
	if(!length(.))
		if(length(prey))
			. = list()
			for(var/weakref/W in prey)
				var/mob/M = W.resolve()
				if(M)
					. |= M
		else if(hunger > 500) //time to look for some food
			for(var/mob/living/L in view(src, dist))
				if(!attack_same && L.faction != faction)
					prey |= weakref(L)

/mob/living/simple_animal/hostile/retaliate/beast/Life()
	. = ..()
	if(!.)
		return FALSE
	hunger++
	if(hunger < 100) //stop hunting when satiated
		prey.Cut()
	else if(stat == CONSCIOUS)
		for(var/mob/living/simple_animal/S in range(src,1))
			if(S == src)
				continue
			if(S.stat != DEAD)
				continue
			visible_message(SPAN_DANGER("\The [src] consumes the body of \the [S]!"))
			var/turf/T = get_turf(S)
			var/obj/item/remains/xeno/X = new(T)
			X.desc += "These look like they belong to \a [S.name]."
			hunger = max(0, hunger - 5*S.maxHealth)
			if(prob(5))
				S.gib()
			else
				qdel(S)
			return

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

/mob/living/simple_animal/hostile/retaliate/beast/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon = 'icons/mob/simple_animal/samak.dmi'
	move_to_delay = 2
	maxHealth = 125
	health = 125
	speed = 2
	natural_weapon = /obj/item/natural_weapon/claws
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/retaliate/beast/samak/alt
	desc = "A fast, armoured predator accustomed to hiding and ambushing."
	icon = 'icons/mob/simple_animal/samak_alt.dmi'

/mob/living/simple_animal/hostile/retaliate/beast/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	faction = "diyaab"
	icon = 'icons/mob/simple_animal/diyaab.dmi'
	move_to_delay = 1
	maxHealth = 25
	health = 25
	speed = 1
	natural_weapon = /obj/item/natural_weapon/claws/weak
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/hostile/retaliate/beast/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon = 'icons/mob/simple_animal/shantak.dmi'
	move_to_delay = 1
	maxHealth = 75
	health = 75
	speed = 1
	natural_weapon = /obj/item/natural_weapon/claws
	cold_damage_per_tick = 0
	speak_chance = 2
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out its mane","tinkles gently")

/mob/living/simple_animal/hostile/retaliate/beast/shantak/alt
	desc = "A piglike creature with a long and graceful mane. Don't be fooled by its beauty."
	icon = 'icons/mob/simple_animal/shantak_alt.dmi'
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
	speak_chance = 1
	emote_hear = list("scratches the ground","chitters")
	mob_size = MOB_SIZE_MINISCULE

/mob/living/simple_animal/hostile/retaliate/royalcrab
	name = "cragenoy"
	desc = "It looks like a crustacean with an exceedingly hard carapace. Watch the pinchers!"
	faction = "crab"
	icon = 'icons/mob/simple_animal/royalcrab.dmi'
	move_to_delay = 3
	maxHealth = 150
	health = 150
	speed = 1
	natural_weapon = /obj/item/natural_weapon/pincers
	speak_chance = 1
	emote_see = list("skitters","oozes liquid from its mouth", "scratches at the ground", "clicks its claws")
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT
		)

/mob/living/simple_animal/hostile/retaliate/beast/charbaby
	name = "charbaby"
	desc = "A huge grubby creature."
	icon = 'icons/mob/simple_animal/char.dmi'
	mob_size = MOB_SIZE_LARGE
	health = 45
	maxHealth = 45
	natural_weapon = /obj/item/natural_weapon/charbaby
	speed = 2
	return_damage_min = 2
	return_damage_max = 3
	harm_intent_damage = 1
	blood_color = COLOR_NT_RED
	natural_armor = list(
		ARMOR_LASER = ARMOR_LASER_HANDGUNS
		)

/obj/item/natural_weapon/charbaby
	name = "scalding hide"
	damtype = BURN
	force = 5
	attack_verb = list("singed")

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/default_hurt_interaction(mob/user)
	. = ..()
	if(. && ishuman(user))
		reflect_unarmed_damage(user, BURN, "amorphous mass")

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/AttackingTarget()
	. = ..()
	if(isliving(target_mob) && prob(25))
		var/mob/living/L = target_mob
		if(prob(10))
			L.adjust_fire_stacks(1)
			L.IgniteMob()

/mob/living/simple_animal/hostile/retaliate/beast/shantak/lava
	desc = "A vaguely canine looking beast. It looks as though its fur is made of stone wool."
	icon = 'icons/mob/simple_animal/lavadog.dmi'
	speak = list("Karuph","Karump")