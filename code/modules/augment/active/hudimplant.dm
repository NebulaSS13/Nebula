/obj/item/organ/internal/augment/active/hud
	name = "integrated HUD"
	desc = "A small implantable heads-up display."
	icon_state = "booster"

	action_button_name = "Toggle integrated HUD"
	allowed_organs = list(BP_AUGMENT_HEAD)

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT
	)

	origin_tech = "{'magnets':2}"

	var/active = FALSE

/obj/item/organ/internal/augment/active/hud/Process()
	..()
	if (owner && active)
		if (allowed(owner))
			callback_hud_to_process(owner, 1)

/obj/item/organ/internal/augment/active/hud/proc/callback_hud_to_process(mob/user, local_scanner)
	return

/obj/item/organ/internal/augment/active/hud/emp_act(severity)
	if(owner)
		to_chat(owner, SPAN_DANGER("Your [name] malfunctions, blinding you!"))
		owner.set_status(STAT_BLIND, 4)
		owner.set_status(STAT_BLURRY, 8)
		take_general_damage(rand(5, 15))
		active = FALSE

/obj/item/organ/internal/augment/active/hud/activate()
	if (!can_activate())
		return

	active = !active
	to_chat(owner, SPAN_NOTICE("You [active ? "enable" : "disable"] \the [src]."))

/obj/item/organ/internal/augment/active/hud/health
	name = "integrated health HUD"
	desc = "A implantable HUD, designed to interface directly with the user's optic nerve and display information about patient vitals."

	origin_tech = "{'magnets':2,'biotech':2}"
	req_access = list(access_medical)

/obj/item/organ/internal/augment/active/hud/health/callback_hud_to_process(mob/user, local_scanner)
	return process_med_hud(user, local_scanner)

/obj/item/organ/internal/augment/active/hud/security
	name = "integrated security HUD"
	desc = "A implantable HUD, designed to interface directly with the user's optic nerve and local databases to display security information."

	origin_tech = "{'magnets':2,'combat':2}"
	req_access = list(access_security)

/obj/item/organ/internal/augment/active/hud/security/callback_hud_to_process(mob/user, local_scanner)
	return process_sec_hud(user, local_scanner)
