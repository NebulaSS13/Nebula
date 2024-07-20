/mob/living/simple_animal/hostile/revenant
	name = "revenant"
	desc = "A flickering humanoid shadow that exudes a palpable sense of mance."
	icon = 'icons/mob/simple_animal/revenant.dmi'
	response_help_1p = "You wave your hand through $TARGET$."
	response_help_3p = "$USER$ waves $USER_THEIR$ hand through $TARGET$."
	max_health = 80
	gene_damage = -1
	ai = /datum/mob_controller/aggressive/revenant

	harm_intent_damage = 10
	natural_weapon = /obj/item/natural_weapon/revenant

	min_gas = null
	max_gas = null
	minbodytemp = 0

	faction = "revenants"
	supernatural = 1

/datum/mob_controller/aggressive/revenant
	speak_chance     = 0
	turns_per_wander = 10

/datum/mob_controller/aggressive/revenant/find_target()
	. = ..()
	if(.)
		body.custom_emote(AUDIBLE_MESSAGE, "wails at [.]")

/obj/item/natural_weapon/revenant
	name = "shadow tendril"
	attack_verb = list("gripped")
	hitsound = 'sound/hallucinations/growl1.ogg'
	atom_damage_type =  BURN
	_base_attack_force = 15

/mob/living/simple_animal/hostile/revenant/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/revenant/apply_attack_effects(mob/living/target)
	. = ..()
	if(prob(12))
		SET_STATUS_MAX(target, STAT_WEAK, 3)
		target.visible_message(SPAN_DANGER("\The [src] knocks down \the [target]!"))

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "Spooky."
	gender = PLURAL
	icon = 'icons/obj/items/ectoplasm.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/liquid/drink/compote