/decl/mob_modifier/sifsap_salve
	name              = "Sifsap Salve"
	desc              = "Your wounds have been cleaned with drake spittle, which is beneficial to drakes - and not great for anyone else."
	hud_icon          = 'mods/species/drakes/icons/sifsap.dmi'
	hud_icon_state    = "sifsap_hud"
	mob_overlay_icon  = 'icons/effects/sparkles.dmi'
	mob_overlay_state = "cyan_sparkles"
	/// Defined here to allow overriding in fantasy modpack.
	var/descriptor    = "glowing sap"

/decl/mob_modifier/sifsap_salve/Initialize()
	on_add_message_1p = SPAN_NOTICE("The [descriptor] seethes and bubbles in your wounds, tingling and stinging.")
	on_end_message_1p = SPAN_NOTICE("The last of the [descriptor] in your wounds fizzles away.")
	. = ..()

/decl/mob_modifier/sifsap_salve/on_modifier_datum_mob_life(mob/living/owner, decl/mob_modifier/modifier)
	. = ..()
	if(!owner || owner.stat == DEAD || owner.isSynthetic())
		return
	if(!owner.has_trait(/decl/trait/sivian_biochemistry))
		owner.heal_damage(BRUTE, 1, do_update_health = FALSE)
		owner.heal_damage(BURN,  1, do_update_health = TRUE)
		return
	if(owner.current_health >= owner.get_max_health())
		return
	if(owner.current_posture?.prone)
		owner.heal_damage(BRUTE, 3, do_update_health = FALSE)
		owner.heal_damage(BURN,  3, do_update_health = FALSE)
		owner.heal_damage(TOX,   2, do_update_health = TRUE)
	else
		owner.heal_damage(BRUTE, 2, do_update_health = FALSE)
		owner.heal_damage(BURN,  2, do_update_health = FALSE)
		owner.heal_damage(TOX,   1, do_update_health = TRUE)
