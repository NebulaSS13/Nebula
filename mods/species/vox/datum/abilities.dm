/obj/screen/ability/category/vox
	name = "Toggle Vox Abilities"
	icon = 'mods/species/vox/icons/abilities.dmi'

/obj/screen/ability/button/vox
	icon = 'mods/species/vox/icons/abilities.dmi'

/datum/ability_handler/vox
	category_toggle_type = /obj/screen/ability/category/vox

/decl/ability/vox
	abstract_type           = /decl/ability/vox
	ability_icon            = 'mods/species/vox/icons/abilities.dmi'
	associated_handler_type = /datum/ability_handler/vox
	ui_element_type         = /obj/screen/ability/button/vox

/decl/mob_modifier/sealed_carapace
	name              = "Sealed Carapace"
	desc              = "Your carapace is sealed to form a vacuum suit."
	hud_icon          = 'mods/species/vox/icons/modifiers.dmi'
	hud_icon_state    = "sealed"
	on_add_message_1p = SPAN_NOTICE("You flatten your scaling and inflate internal bladders, protecting yourself against low pressure at the cost of dexterity.")
	on_add_message_3p = SPAN_NOTICE("$USER$'s scaling flattens and smooths out.")
	on_end_message_1p = SPAN_NOTICE("You bristle your scaling and deflate your internal bladders, restoring mobility but leaving yourself vulnerable to low pressure.")
	on_end_message_3p = SPAN_NOTICE("$USER$'s scaling bristles roughly.")

/decl/ability/vox/seal_carapace
	name                      = "Toggle Vox Pressure Seal"
	desc                      = "Toggle whether or not you are immune to vacuum, at the cost of speed."
	ability_icon_state        = "toggle_seal"
	ability_cooldown_time     = 5 SECONDS
	ability_use_channel       = 2 SECONDS
	target_selector           = /decl/ability_targeting/target_self
	check_incapacitated       = INCAPACITATION_KNOCKOUT
	cast_failed_incapacitated = "You are in no state to do that."
	prepare_message_3p_str    = "$USER$ begins flexing and realigning $USER_THEIR$ scaling..."
	fail_cast_1p_str          = "You must remain still to seal or unseal your scaling."
	fail_cast_3p_str          = "$USER$ ceases adjusting $USER_THEIR$ scaling."
	cast_style                = "notice"

/decl/ability/vox/seal_carapace/apply_ability_effect_to(mob/living/user, atom/target, list/metadata)
	. = ..()
	if(user.has_mob_modifier(/decl/mob_modifier/sealed_carapace, source = user))
		user.remove_mob_modifier(/decl/mob_modifier/sealed_carapace, source = user)
	else
		user.add_mob_modifier(/decl/mob_modifier/sealed_carapace, source = user)
