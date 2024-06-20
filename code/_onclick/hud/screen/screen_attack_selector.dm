/obj/screen/default_attack_selector
	name       = "default attack selector"
	icon_state = "attack_none"
	screen_loc = ui_attack_selector

/obj/screen/default_attack_selector/Destroy()
	var/mob/living/human/owner = owner_ref?.resolve()
	if(istype(owner) && owner.attack_selector == src)
		owner.attack_selector = null
	. = ..()

/obj/screen/default_attack_selector/handle_click(mob/user, params)

	var/mob/living/human/owner = owner_ref?.resolve()
	if(user != owner)
		return FALSE

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		to_chat(owner, SPAN_NOTICE("Your current default attack is <b>[owner.default_attack?.name || "unset"]</b>."))
		if(owner.default_attack)
			var/summary = owner.default_attack.summarize()
			if(summary)
				to_chat(owner, SPAN_NOTICE(summary))
		return

	owner.set_default_unarmed_attack(src)
	return TRUE

/obj/screen/default_attack_selector/on_update_icon()
	var/mob/living/human/owner = owner_ref?.resolve()
	var/decl/natural_attack/attack = istype(owner) && owner.default_attack
	icon_state = attack?.selector_icon_state || "attack_none"
