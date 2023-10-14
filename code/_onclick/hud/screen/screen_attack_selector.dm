/obj/screen/default_attack_selector
	name       = "default attack selector"
	icon_state = "attack_none"
	screen_loc = ui_attack_selector
	var/mob/living/carbon/human/owner

/obj/screen/default_attack_selector/Click(location, control, params)
	if(!owner || usr != owner || owner.incapacitated())
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

/obj/screen/default_attack_selector/Destroy()
	if(owner)
		if(owner.attack_selector == src)
			owner.attack_selector = null
		owner = null
	. = ..()

/obj/screen/default_attack_selector/proc/set_owner(var/mob/living/carbon/human/_owner)
	owner = _owner
	if(!owner)
		qdel(src)
	else
		update_icon()

/obj/screen/default_attack_selector/on_update_icon()
	var/decl/natural_attack/attack = owner?.default_attack
	icon_state = attack?.selector_icon_state || "attack_none"
