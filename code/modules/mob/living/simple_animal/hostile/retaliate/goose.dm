/mob/living/simple_animal/hostile/goose
	name = "goose"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked."
	icon = 'icons/mob/simple_animal/goose.dmi'
	speak_emote  = list("honks")
	natural_weapon = /obj/item/natural_weapon/goosefeet
	max_health = 45
	pass_flags = PASS_FLAG_TABLE
	faction = "geese"
	butchery_data = /decl/butchery_data/animal/small/fowl/goose
	ai = /datum/mob_controller/aggressive/goose

	var/enrage_potency = 3
	var/enrage_potency_loose = 4
	var/loose_threshold = 15
	var/max_damage = 25
	var/loose = FALSE //goose loose status

/datum/mob_controller/aggressive/goose
	break_stuff_probability = 5
	emote_speech = list("Honk!")
	emote_hear   = list("honks","flaps its wings","clacks")
	emote_see    = list("flaps its wings", "scratches the ground")
	only_attack_enemies = TRUE

/datum/mob_controller/aggressive/goose/retaliate(atom/source)
	. = ..()
	if(body?.stat == CONSCIOUS && istype(body, /mob/living/simple_animal/hostile/goose))
		var/mob/living/simple_animal/hostile/goose/goose = body
		goose.enrage(goose.enrage_potency)

/obj/item/natural_weapon/goosefeet
	name = "goose feet"
	gender = PLURAL
	attack_verb = list("smacked around")
	_base_attack_force = 0
	atom_damage_type =  BRUTE
	canremove = FALSE

/mob/living/simple_animal/hostile/goose/get_door_pry_time()
	return 8 SECONDS

/mob/living/simple_animal/hostile/goose/on_update_icon()
	..()
	if(stat != DEAD && loose)
		icon_state += "-loose"

/mob/living/simple_animal/hostile/goose/death(gibbed)
	. = ..()
	if(. && !gibbed)
		update_icon()

/mob/living/simple_animal/hostile/goose/proc/enrage(var/potency)
	var/obj/item/attacking_with = get_natural_weapon()
	if(attacking_with)
		attacking_with.set_base_attack_force(min((attacking_with.get_initial_base_attack_force() + potency), max_damage))
	if(!loose && prob(25) && (attacking_with && attacking_with.get_attack_force(src) >= loose_threshold)) //second wind
		loose = TRUE
		set_max_health(initial(max_health) * 1.5)
		set_damage(BRUTE, 0)
		set_damage(BURN, 0)
		enrage_potency = enrage_potency_loose
		desc += " The [name] is loose! Oh no!"
		update_icon()

/mob/living/simple_animal/hostile/goose/dire
	name = "dire goose"
	desc = "A large bird. It radiates destructive energy."
	icon = 'icons/mob/simple_animal/goose_dire.dmi'
	max_health = 250
	enrage_potency = 3
	loose_threshold = 20
	max_damage = 35
	butchery_data = /decl/butchery_data/animal/small/fowl/goose/dire
