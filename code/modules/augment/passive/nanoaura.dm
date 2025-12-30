/obj/item/organ/internal/augment/active/nanounit
	name = "nanite MCU"
	allowed_organs = list(BP_AUGMENT_CHEST_ACTIVE)
	icon_state = "armor-chest"
	desc = "Nanomachines, son."
	action_button_name = "Toggle Nanomachines"
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":4,"magnets":4,"engineering":5,"biotech":3}'
	var/active = FALSE
	var/modifier_archetype = /decl/mob_modifier/nanoswarm
	var/charges = 4

/obj/item/organ/internal/augment/active/nanounit/reset_matter()
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/organ/internal/augment/active/nanounit/on_add_effects()
	. = ..()
	if(owner && modifier_archetype)
		owner.add_mob_modifier(modifier_archetype, source = src)

/obj/item/organ/internal/augment/active/nanounit/on_remove_effects(mob/living/last_owner)
	if(istype(last_owner) && modifier_archetype)
		last_owner.remove_mob_modifier(modifier_archetype, source = src)
	. = ..()

/obj/item/organ/internal/augment/active/nanounit/proc/catastrophic_failure()
	playsound(owner,'sound/mecha/internaldmgalarm.ogg',25,1)
	charges = -1
	active = FALSE
	owner.visible_message(SPAN_WARNING("The nanites attempt to harden. But they seem... brittle."))
	for(var/obj/item/organ/external/E in owner.get_external_organs())
		if(prob(25))
			E.status |= ORGAN_BRITTLE //Some nanites are not responding and you're out of luck
			to_chat(owner, SPAN_DANGER("Your [E.name] feels cold and rigid."))
	owner.remove_mob_modifier(modifier_archetype, source = src)

/obj/item/organ/internal/augment/active/nanounit/activate()
	if(!owner || !modifier_archetype || !can_activate())
		return
	if(owner.has_mob_modifier(modifier_archetype, source = src))
		active = FALSE
		to_chat(owner,SPAN_NOTICE("Nanites entering sleep mode."))
		owner.remove_mob_modifier(modifier_archetype, source = src)
	else if(charges > 0)
		to_chat(owner,SPAN_NOTICE("Activation sequence in progress."))
		active = TRUE
		owner.add_mob_modifier(modifier_archetype, source = src)
	playsound(owner,'sound/weapons/flash.ogg',35,1)

/obj/item/organ/internal/augment/active/nanounit/Destroy()
	if(owner && modifier_archetype)
		owner.remove_mob_modifier(modifier_archetype, source = src)
	. = ..()
