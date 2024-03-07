/mob/living/simple_animal/hostile/aquatic/shark
	name = "shark"
	desc = "A ferocious fish with many, many teeth."
	icon = 'icons/mob/simple_animal/shark.dmi'
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/bite/shark
	break_stuff_probability = 15
	faction = "sharks"

	meat_type = /obj/item/chems/food/fish/shark
	meat_amount = 5
	bone_amount = 15
	skin_amount = 15
	bone_material = /decl/material/solid/organic/bone/cartilage
	skin_material = /decl/material/solid/organic/skin/shark

/obj/item/natural_weapon/bite/shark
	force = 20

/mob/living/simple_animal/hostile/aquatic/shark/huge
	name = "gigacretoxyrhina"
	desc = "That is a lot of shark."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	turns_per_move = 2
	move_to_delay = 2
	attack_same = 1
	speed = 0
	mob_size = MOB_SIZE_LARGE
	pixel_x = -16
	max_health = 400
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/giantshark
	break_stuff_probability = 35

	meat_amount = 10
	bone_amount = 30
	skin_amount = 30

/obj/item/natural_weapon/bite/giantshark
	force = 40