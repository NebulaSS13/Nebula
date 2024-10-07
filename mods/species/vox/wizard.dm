// Wizard
#ifdef GAMEMODE_PACK_WIZARD
/*
/obj/item/magic_rock/Initialize(ml, material_key)
	LAZYSET(potentials, SPECIES_VOX, /spell/targeted/shapeshift/true_form)
	. = ..()

/spell/targeted/shapeshift/true_form
	name = "True Form"
	desc = "Pay respect to your heritage. Become what you once were."
	school = "racial"
	requires_wizard_garb = FALSE
	invocation_type = SpI_EMOTE
	range = -1
	invocation = "begins to grow!"
	charge_max = 1200 //2 minutes
	duration = 300 //30 seconds
	smoke_amt = 5
	smoke_spread = 1
	possible_transformations = list(/mob/living/simple_animal/hostile/parrot/space/lesser)
	ability_icon_state = "wiz_vox"
	cast_sound = 'sound/voice/shriek1.ogg'
	revert_sound = 'sound/voice/shriek1.ogg'
	drop_items = 0
*/
#endif