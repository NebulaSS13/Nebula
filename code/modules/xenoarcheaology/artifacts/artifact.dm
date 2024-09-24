/obj/structure/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	density = TRUE

	var/base_icon = "ano0"
	var/datum/artifact_effect/my_effect
	var/datum/artifact_effect/secondary_effect

/obj/structure/artifact/Initialize()
	. = ..()

	if(!ispath(my_effect))
		my_effect = pick(subtypesof(/datum/artifact_effect))
	my_effect = new my_effect(src)

	if(prob(75) && !ispath(secondary_effect))
		secondary_effect = pick(subtypesof(/datum/artifact_effect))
	if(ispath(secondary_effect))
		secondary_effect = new secondary_effect(src)
		if(prob(75))
			secondary_effect.ToggleActivate(0)

	START_PROCESSING(SSobj, src)

	var/list/styles = decls_repository.get_decls_of_type(/decl/artifact_appearance)
	var/decl/artifact_appearance/style = pick(styles)
	style = styles[style]
	style.apply_to(src)

/obj/structure/artifact/proc/is_active()
	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		if(effect.activated)
			return TRUE
	return FALSE

/obj/structure/artifact/on_update_icon()
	..()
	icon_state = "[base_icon][is_active()]"

/obj/structure/artifact/Destroy()
	QDEL_NULL(my_effect)
	QDEL_NULL(secondary_effect)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/artifact/proc/check_triggers(trigger_proc)
	. = FALSE
	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		var/triggered = call(effect.trigger, trigger_proc)(arglist(args.Copy(2)))
		if(effect.trigger.toggle)
			if(triggered)
				effect.ToggleActivate(1)
				. = TRUE
		else if(effect.activated != triggered)
			effect.ToggleActivate(1)
			. = TRUE

/obj/structure/artifact/Process()
	var/turf/T = loc
	if(!istype(T)) 	// We're inside a container or on null turf, either way stop processing effects
		return

	for(var/obj/item/grab/grab as anything in grabbed_by)
		if(isliving(grab.assailant))
			check_triggers(/datum/artifact_trigger/proc/on_touch, grab.assailant)
			touched(grab.assailant)

	var/datum/gas_mixture/enivonment = T.return_air()
	if(enivonment?.return_pressure() >= SOUND_MINIMUM_PRESSURE)
		check_triggers(/datum/artifact_trigger/proc/on_gas_exposure, enivonment)

	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		effect.process()

/obj/structure/artifact/attack_robot(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	visible_message(SPAN_NOTICE("[user] touches \the [src]."))
	check_triggers(/datum/artifact_trigger/proc/on_touch, user)
	touched(user)

/obj/structure/artifact/attack_hand(mob/user)
	. = ..()
	visible_message(SPAN_NOTICE("[user] touches \the [src]."))
	check_triggers(/datum/artifact_trigger/proc/on_touch, user)
	touched(user)

/obj/structure/artifact/attackby(obj/item/W, mob/user)
	. = ..()
	visible_message(SPAN_WARNING("[user] hits \the [src] with \the [W]."))
	check_triggers(/datum/artifact_trigger/proc/on_hit, W, user)

/obj/structure/artifact/Bumped(M)
	..()
	check_triggers(/datum/artifact_trigger/proc/on_bump, M)
	if(isliving(M))
		touched(M)

/obj/structure/artifact/bullet_act(var/obj/item/projectile/P)
	visible_message(SPAN_WARNING("\The [P] hits \the [src]!"))
	check_triggers(/datum/artifact_trigger/proc/on_hit, P)

/obj/structure/artifact/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(check_triggers(/datum/artifact_trigger/proc/on_explosion, severity))
		return
	if(severity == 1 || (severity == 2 && prob(50)))
		physically_destroyed()

/obj/structure/artifact/Move()
	..()
	if(my_effect)
		my_effect.UpdateMove()
	if(secondary_effect)
		secondary_effect.UpdateMove()

/obj/structure/artifact/proc/touched(mob/M)
	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		if(effect.activated)
			effect.DoEffectTouch(M)

/obj/structure/artifact/get_artifact_scan_data()
	var/out = "Anomalous alien device - composed of an unknown alloy.<br><br>"

	if(my_effect)
		out += my_effect.getDescription()

	if(secondary_effect && secondary_effect.activated)
		out += "<br><br>Internal scans indicate ongoing secondary activity operating independently from primary systems.<br><br>"
		out += secondary_effect.getDescription()

	return out

/obj/structure/artifact/fluid_act(datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume)
		check_triggers(/datum/artifact_trigger/proc/on_fluid_act, fluids)

// Premade subtypes for mapping or testing.
/obj/structure/artifact/dnascramble
	my_effect = /datum/artifact_effect/dnaswitch
