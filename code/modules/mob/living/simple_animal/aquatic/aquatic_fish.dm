/mob/living/simple_animal/aquatic/fish
	name = "small fish"
	desc = "Glub glub."
	icon_state = "content"
	icon_living = "content"
	icon_dead = "content_dead"
	faction = "fishes"
	maxHealth = 10
	health = 10
	mob_size = MOB_SIZE_TINY

	can_pull_size = 0
	can_pull_mobs = 0

	mob_bump_flag = 0
	mob_swap_flags = 0
	mob_push_flags = 0
	mob_always_swap = 1

	meat_amount = 1
	bone_amount = 3
	skin_amount = 3

/mob/living/simple_animal/aquatic/fish/grump
	icon_state = "grump"
	icon_living = "grump"
	icon_dead = "grump_dead"

/mob/living/simple_animal/aquatic/fish/judge
	icon_state = "judge"
	icon_living = "judge"
	icon_dead = "judge_dead"
	meat_amount = 2
