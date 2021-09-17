/mob/living/simple_animal/familiar
	name = "familiar"
	desc = "No wizard is complete without a mystical sidekick."
	supernatural = 1
	universal_speak = FALSE
	universal_understand = TRUE

	min_gas = list(/decl/material/gas/oxygen = 1)
	max_gas = null
	unsuitable_atmos_damage = 1
	gene_damage = -1

	var/list/wizardy_spells = list()

/mob/living/simple_animal/familiar/Initialize()
	. = ..()
	add_language(/decl/language/human/common)
	for(var/spell in wizardy_spells)
		src.add_spell(new spell, "const_spell_ready")

/mob/living/simple_animal/familiar/carcinus
	name = "carcinus"
	desc = "A small crab said to be made of stone and starlight."
	icon = 'icons/mob/simple_animal/evilcrab.dmi'

	speak_emote = list("chitters","clicks")


	health = 200
	maxHealth = 200
	natural_weapon = /obj/item/natural_weapon/pincers/strong
	resistance = 9
	can_escape = TRUE //snip snip

/obj/item/natural_weapon/pincers/strong
	force = 15

/*familiar version of the Pike w/o all the other hostile/carp stuff getting in the way (namely life)
*/

/mob/living/simple_animal/familiar/pike
	name = "space pike"
	desc = "A bigger, more magical cousin of the space carp."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	pixel_x = -16

	speak_emote = list("gnashes")

	health = 100
	maxHealth = 100
	natural_weapon = /obj/item/natural_weapon/bite
	can_escape = TRUE

	min_gas = null

	wizardy_spells = list(/spell/aoe_turf/conjure/forcewall)

/mob/living/simple_animal/familiar/pike/Process_Spacemove()
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/familiar/horror
	name = "horror"
	desc = "Looking at it fills you with dread."
	icon = 'icons/mob/simple_animal/horror.dmi'
	speak_emote = list("moans", "groans")

	response_help_1p = "You think better of touching $TARGET$."
	response_help_3p = "$USER$ thinks better of touching $TARGET$."

	health = 150
	maxHealth = 150
	natural_weapon = /obj/item/natural_weapon/horror

	wizardy_spells = list(/spell/targeted/torment)

/obj/item/natural_weapon/horror
	name = "foul touch"
	force = 10
	damtype = BURN
	attack_verb = list("touched")

/mob/living/simple_animal/familiar/horror/death(gibbed, deathmessage, show_dead_message)
	..(null,"rapidly deteriorates","The bonds tying you to this mortal plane have been severed.")

	ghostize()
	gibs(src.loc)
	qdel(src)


/mob/living/simple_animal/familiar/minor_amaros
	name = "minor amaros"
	desc = "A small fluffy alien creature."
	icon = 'icons/mob/simple_animal/amaros.dmi'
	speak_emote = list("entones")
	mob_size = MOB_SIZE_SMALL
	health = 25
	maxHealth = 25
	wizardy_spells = list(
		/spell/targeted/heal_target,
		/spell/targeted/heal_target/area
	)

/mob/living/simple_animal/familiar/pet/mouse
	name = "elderly mouse"
	desc = "A small rodent. It looks very old."
	icon = 'icons/mob/simple_animal/mouse_gray.dmi'

	speak_emote = list("squeeks")
	holder_type = /obj/item/holder/mouse
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_MINISCULE

	response_harm = "stamps on"

	health = 15
	maxHealth = 15
	natural_weapon = /obj/item/natural_weapon/bite/mouse
	can_escape = TRUE

	wizardy_spells = list(/spell/aoe_turf/smoke)

/mob/living/simple_animal/familiar/pet/mouse/Initialize()
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/familiar/pet/cat
	name = "black cat"
	desc = "A pitch black cat. Said to be especially unlucky."
	icon = 'icons/mob/simple_animal/cat_black.dmi'
	speak_emote = list("meows", "purrs")
	holder_type = /obj/item/holder
	mob_size = MOB_SIZE_SMALL
	health = 25
	maxHealth = 25
	natural_weapon = /obj/item/natural_weapon/claws/weak
	wizardy_spells = list(/spell/targeted/subjugation)
