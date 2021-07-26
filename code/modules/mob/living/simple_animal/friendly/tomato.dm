/mob/living/simple_animal/tomato
	name = "tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"
	speak_chance = 0
	turns_per_move = 5
	maxHealth = 15
	health = 15
	response_help_3p = "$USER$ pokes $TARGET$."
	response_help_1p = "You poke $TARGET$."
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/chems/food/tomatomeat
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   null
