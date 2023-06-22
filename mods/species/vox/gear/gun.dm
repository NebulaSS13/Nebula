/datum/extension/voxform
	base_type = /datum/extension/voxform

/datum/extension/voxform/proc/check_held_user(var/mob/living/carbon/human/user, var/atom/movable/thing)
	if(!istype(user))
		return FALSE
	if(user.get_bodytype_category() != BODYTYPE_VOX && user.try_unequip(thing))
		to_chat(user, SPAN_WARNING("\The [thing] hisses and wriggles out of your grasp!"))
		playsound(user, 'sound/voice/BugHiss.ogg', 50, 1)
		return FALSE
	return TRUE

/obj/item/gun/special_check(var/mob/living/carbon/human/user)
	. = ..()
	if(!QDELETED(src) && src.loc == user && has_extension(src, /datum/extension/voxform))
		var/datum/extension/voxform/voxform = get_extension(src, /datum/extension/voxform)
		. = voxform.check_held_user(user, src)

/*
 * Vox Darkmatter Cannon
 */
/obj/item/gun/energy/darkmatter
	name = "flux cannon"
	desc = "A vicious beam weapon that crushes targets with dark-matter gravity pulses. Parts of it twitch and writhe, as if alive."
	icon = 'mods/species/vox/icons/gear/darkcannon.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	projectile_type = /obj/item/projectile/beam/stun/darkmatter
	one_hand_penalty = 2 //a little bulky
	self_recharge = 1
	firemodes = list(
		list(mode_name="stunning", burst=1, fire_delay=null,burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/stun/darkmatter, charge_cost = 50),
		list(mode_name="focused", burst=1, fire_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/darkmatter, charge_cost = 75),
		list(mode_name="scatter burst", burst=8, fire_delay=null, burst_accuracy=list(0, 0, 0, 0, 0, 0, 0, 0), dispersion=list(0, 1, 2, 2, 3, 3, 3, 3, 3), projectile_type=/obj/item/projectile/energy/darkmatter, charge_cost = 10),
		)

/obj/item/gun/energy/darkmatter/Initialize()
	. = ..()
	set_extension(src, /datum/extension/voxform)

/*
 * Vox Sonic Cannon
 */
/obj/item/gun/energy/sonic
	name = "soundcannon"
	desc = "A vicious sonic weapon of alien manufacture. Parts of it quiver gelatinously, as though the insectile-looking thing is alive."
	icon = 'mods/species/vox/icons/gear/noise.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty = 1
	self_recharge = 1
	recharge_time = 10
	fire_delay = 15
	projectile_type=/obj/item/projectile/energy/plasmastun/sonic/weak
	firemodes = list(
		list(mode_name="normal", projectile_type=/obj/item/projectile/energy/plasmastun/sonic/weak, charge_cost = 50),
		list(mode_name="overcharge", projectile_type=/obj/item/projectile/energy/plasmastun/sonic/strong, charge_cost = 200),
		)

/obj/item/gun/energy/sonic/Initialize()
	. = ..()
	set_extension(src, /datum/extension/voxform)

/obj/item/gun/projectile/dartgun/vox
	name = "alien dart gun"
	desc = "A small gas-powered dartgun, fitted for nonhuman hands."

/obj/item/gun/projectile/dartgun/vox/medical
	starting_chems = list(
		/decl/material/liquid/burn_meds,
		/decl/material/liquid/brute_meds,
		/decl/material/liquid/antitoxins
	)

/obj/item/gun/projectile/dartgun/vox/raider
	starting_chems = list(
		/decl/material/liquid/hallucinogenics,
		/decl/material/liquid/sedatives,
		/decl/material/liquid/paralytics
	)

/spell/targeted/shapeshift/true_form
	name = "True Form"
	desc = "Pay respect to your heritage. Become what you once were."

	school = "racial"
	spell_flags = INCLUDEUSER
	invocation_type = SpI_EMOTE
	range = -1
	invocation = "begins to grow!"
	charge_max = 1200 //2 minutes
	duration = 300 //30 seconds

	smoke_amt = 5
	smoke_spread = 1

	possible_transformations = list(/mob/living/simple_animal/hostile/retaliate/parrot/space/lesser)

	hud_state = "wiz_vox"

	cast_sound = 'sound/voice/shriek1.ogg'
	revert_sound = 'sound/voice/shriek1.ogg'

	drop_items = 0
