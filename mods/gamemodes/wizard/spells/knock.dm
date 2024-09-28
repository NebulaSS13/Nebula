/decl/ability/wizard/knock
	name = "Knock"
	desc = "This spell opens nearby doors and does not require wizard garb."
	feedback = "KN"
	// school = "transmutation"
	cooldown_time = 10 SECONDS
	requires_wizard_garb = FALSE
	invocation_string = "Aulie Oxin Fiera."
	invocation_type = SpI_WHISPER
	var/base_knock_range = 3
	base_max_upgrades = 4
	base_max_upgrade_levels = list((Sp_SPEED) = 4, (Sp_POWER) = 1)
	target_selector = /decl/ability_targeting/spell/knock
	// cooldown_min = 20 //20 deciseconds reduction per rank

	ability_icon_state = "wiz_knock"
	use_sound = 'sound/magic/knock.ogg'

/decl/ability_targeting/spell/knock
	target_turf = FALSE // targets doors

/decl/ability_targeting/spell/knock/get_effect_radius(mob/user, atom/hit_target, list/metadata)
	return metadata["knock_range"]

/decl/ability_targeting/spell/knock/get_affected_atoms(atom/center, new_effect_radius)
	. = list()
	for(var/obj/machinery/door/door in range(center, new_effect_radius))
		. += door
	for(var/obj/structure/door/door in range(center, new_effect_radius))
		. += door

/decl/ability/wizard/knock/apply_effect_to(mob/user, atom/target, list/metadata)
	. = ..()
	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/door = target
		if(istype(door, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/airlock = door //casting is important
			airlock.unlock()
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/machinery/door, open))
	else if(istype(target, /obj/structure/door))
		var/obj/structure/door/door = target
		if(door.lock?.isLocked())
			door.lock.unlock(door.lock.lock_data, user) // open sesame!
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/door, open))

/decl/ability/wizard/knock/get_default_metadata()
	. = ..()
	.["knock_range"] = base_knock_range

/decl/ability/wizard/knock/can_improve(upgrade_type, list/metadata)
	. = ..()
	if(. && upgrade_type == Sp_POWER)
		return base_knock_range >= metadata["knock_range"] // check if we've boosted our range yet

/decl/ability/wizard/knock/empower_spell(mob/user, list/metadata)
	. = ..()
	if(!.)
		return
	metadata["knock_range"] = base_knock_range * 2
	return "You've doubled the range of [src]."

/decl/ability/wizard/knock/slow
	cooldown_time = 20 SECONDS
	hidden_from_codex = TRUE
