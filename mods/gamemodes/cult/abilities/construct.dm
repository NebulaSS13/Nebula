//////////////////////////////Construct Spells/////////////////////////
/decl/ability/cult/construct
	name                    = "Artificer"
	desc                    = "This spell conjures a construct which may be controlled by shades."
	target_selector         = /decl/ability_targeting/clear_turf
	overlay_icon            = 'mods/gamemodes/cult/icons/effects.dmi'
	overlay_icon_state      = "sparkles"
	target_selector         = /decl/ability_targeting/clear_turf/construct
	var/summon_type         = /obj/structure/constructshell

/decl/ability_targeting/clear_turf/construct/validate_target(mob/user, atom/target, list/metadata, decl/ability/ability)
	var/decl/ability/cult/construct/cult_ability = ability
	if(!istype(cult_ability))
		return FALSE
	return ..() && !istype(target, cult_ability.summon_type) && !(locate(cult_ability.summon_type) in target)

/decl/ability/cult/construct/apply_effect(mob/user, atom/hit_target, list/metadata, obj/item/projectile/ability/projectile)
	. = ..()
	var/turf/target_turf = get_turf(hit_target)
	if(istype(target_turf))
		if(ispath(summon_type, /turf))
			target_turf = target_turf.ChangeTurf(summon_type, TRUE, FALSE, TRUE, TRUE, FALSE)
			if(target_turf) // We reapply effects as target no longer exists.
				apply_effect_to(user, target_turf, metadata)
		else if(ispath(summon_type, /atom))
			new summon_type(target_turf)

/decl/ability/cult/construct/lesser
	ability_cooldown_time   = 2 MINUTES
	summon_type             = /obj/structure/constructshell/cult
	ability_icon_state      = "const_shell"

/decl/ability/cult/construct/floor
	name                    = "Floor Construction"
	desc                    = "This spell constructs a cult floor"
	ability_cooldown_time   = 2 SECONDS
	summon_type             = /turf/floor/cult
	ability_icon_state      = "const_floor"
	overlay_icon_state      = "cultfloor"

/decl/ability/cult/construct/wall
	name                    = "Lesser Construction"
	desc                    = "This spell constructs a cult wall"
	ability_cooldown_time   = 10 SECONDS
	summon_type             = /turf/wall/cult
	ability_icon_state      = "const_wall"
	overlay_icon_state      = "cultwall"

/decl/ability/cult/construct/wall/reinforced
	name                    = "Greater Construction"
	desc                    = "This spell constructs a reinforced metal wall"
	ability_cooldown_time   = 30 SECONDS
	summon_type             = /turf/wall/r_wall

/decl/ability/cult/construct/soulstone
	name                    = "Summon Soulstone"
	desc                    = "This spell reaches into Nar-Sie's realm, summoning one of the legendary fragments across time and space."
	ability_cooldown_time   = 5 MINUTES
	summon_type             = /obj/item/soulstone
	ability_icon_state      = "const_stone"

/decl/ability/cult/construct/pylon
	name                    = "Red Pylon"
	desc                    = "This spell conjures a fragile crystal from Nar-Sie's realm. Makes for a convenient light source."
	ability_cooldown_time   = 20 SECONDS
	summon_type             = /obj/structure/cult/pylon
	ability_icon_state      = "const_pylon"
	target_selector         = /decl/ability_targeting/pylon
	is_melee_invocation     = TRUE
	prep_cast               = TRUE

/decl/ability_targeting/pylon/validate_target(mob/user, atom/target, list/metadata, decl/ability/ability)
	. = ..()
	if(!.)
		return
	if(istype(target, /obj/structure/cult/pylon))
		return TRUE
	if(isturf(target))
		var/turf/target_turf = target
		// We can repair pylons, so let us target turfs containing broken pylons.
		if(target_turf.contains_dense_objects(user))
			for(var/obj/structure/cult/pylon/pylon in target_turf)
				if(pylon.isbroken)
					return TRUE
			return FALSE
		// We can summon pylons in empty turfs.
		return TRUE
	return FALSE

/decl/ability/cult/construct/pylon/apply_effect(mob/user, atom/hit_target, list/metadata, obj/item/projectile/ability/projectile)
	for(var/obj/structure/cult/pylon/P in get_turf(hit_target))
		if(P.isbroken)
			P.repair(user)
			return TRUE
	. = ..()

/decl/ability/cult/construct/forcewall/lesser
	name                    = "Force Shield"
	desc                    = "Allows you to pull up a shield to protect yourself and allies from incoming threats"
	summon_type             = /obj/effect/cult_force_wall
	ability_cooldown_time   = 30 SECONDS
	ability_use_channel     = 20 SECONDS
	ability_icon_state      = "const_juggwall"
	prepare_message_3p_str  = "$USER$ begins to twist and warp space around $TARGET$, building a wall of force."
	prepare_message_1p_str  = "You begin the lengthy process of warping local space to form a wall of force."
	cast_message_3p_str     = "$USER$ completes a wall of force!"
	cast_message_1p_str     = "You complete a wall of force!"
	fail_cast_1p_str        = "The screaming fabric of spacetime escapes your grip, and the wall of force vanishes."

//Code for the Juggernaut construct's forcefield, that seemed like a good place to put it.
/obj/effect/cult_force_wall
	desc                    = "This eerie-looking obstacle seems to have been pulled from another dimension through sheer force."
	name                    = "wall of force"
	icon                    = 'mods/gamemodes/cult/icons/effects.dmi'
	icon_state              = "m_shield_cult"
	light_color             = "#b40000"
	light_range             = 2
	anchored                = TRUE
	opacity                 = FALSE
	density                 = TRUE

/obj/effect/cult_force_wall/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(vanish)), 30 SECONDS)

/obj/effect/cult_force_wall/proc/vanish()
	density    = FALSE
	icon_state = "m_shield_cult_vanish"
	sleep(12)
	if(!QDELETED(src))
		qdel(src)
