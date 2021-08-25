/mob/living/simple_animal/hostile/retaliate/goose
	name = "goose"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked."
	icon = 'icons/mob/simple_animal/goose.dmi'
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	speak = list("Honk!")
	speak_emote = list("honks")
	emote_hear = list("honks","flaps its wings","clacks")
	emote_see = list("flaps its wings", "scratches the ground")
	natural_weapon = /obj/item/natural_weapon/goosefeet
	health = 45
	maxHealth = 45
	pass_flags = PASS_FLAG_TABLE
	faction = "geese"
	pry_time = 8 SECONDS
	break_stuff_probability = 5

	meat_type = /obj/item/chems/food/meat/chicken/game
	meat_amount = 6
	bone_amount = 8
	skin_amount = 8
	skin_material = /decl/material/solid/skin/feathers

	var/enrage_potency = 3
	var/enrage_potency_loose = 4
	var/loose_threshold = 15
	var/max_damage = 25
	var/loose = FALSE //goose loose status

/obj/item/natural_weapon/goosefeet
	name = "goose feet"
	gender = PLURAL
	attack_verb = list("smacked around")
	force = 0
	damtype = BRUTE
	canremove = FALSE

/mob/living/simple_animal/hostile/retaliate/goose/Retaliate()
	..()
	if(stat == CONSCIOUS)
		enrage(enrage_potency)

/mob/living/simple_animal/hostile/retaliate/goose/on_update_icon()
	..()
	if(stat == DEAD)
		icon_state = icon_dead
	else if(loose)
		icon_state = "goose_loose"
		icon_living = "goose_loose"

/mob/living/simple_animal/hostile/retaliate/goose/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/proc/enrage(var/potency)
	var/obj/item/W = get_natural_weapon()
	if(W)
		W.force = min((W.force + potency), max_damage)
	if(!loose && prob(25) && (W && W.force >= loose_threshold)) //second wind
		loose = TRUE
		health = (initial(health) * 1.5)
		maxHealth = (initial(maxHealth) * 1.5)
		enrage_potency = enrage_potency_loose
		desc += " The [name] is loose! Oh no!"
		update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/dire
	name = "dire goose"
	desc = "A large bird. It radiates destructive energy."
	icon_state = "dire"
	icon_living = "dire"
	icon_dead = "dire_dead"
	health = 250
	maxHealth = 250
	enrage_potency = 3
	loose_threshold = 20
	max_damage = 35
	skull_type = /obj/item/pen/fancy/quill