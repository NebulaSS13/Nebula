/decl/species/monkey
	name = SPECIES_MONKEY
	name_plural = "Monkeys"
	description = "Ook."
	codex_description = "Monkeys and other similar creatures tend to be found on science stations and vessels as \
	cheap and disposable test subjects. This, naturally, infuriates animal rights groups."
	hidden_from_codex = FALSE

	available_bodytypes = list(/decl/bodytype/monkey)
	holder_icon = 'icons/mob/human_races/species/monkey/holder.dmi'

	show_ssd = null

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	death_message = "lets out a faint chimper as it collapses and stops moving..."

	unarmed_attacks = list(/decl/natural_attack/bite, /decl/natural_attack/claws, /decl/natural_attack/punch)
	inherent_verbs = list(/mob/living/proc/ventcrawl)
	species_hud = /datum/hud_data/monkey
	butchery_data = /decl/butchery_data/humanoid/monkey

	rarity_value = 0.1
	total_health = 150

	spawn_flags = SPECIES_IS_RESTRICTED

	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = PASS_FLAG_TABLE
	holder_type = /obj/item/holder

	force_background_info = list(
		/decl/background_category/heritage =   /decl/background_detail/heritage/hidden/monkey,
		/decl/background_category/homeworld = /decl/background_detail/location/stateless,
		/decl/background_category/faction =   /decl/background_detail/faction/other
	)

	ai = /datum/mob_controller/monkey
