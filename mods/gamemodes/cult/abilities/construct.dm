//////////////////////////////Construct Spells/////////////////////////
/decl/ability/cult/construct
	name                    = "Artificer"
	desc                    = "This spell conjures a construct which may be controlled by Shades."
	var/summon_type         = /obj/structure/constructshell

/decl/ability/cult/construct/lesser
	cooldown_time           = 2 MINUTES
	summon_type             = /obj/structure/constructshell/cult
	ability_icon_state      = "const_shell"

/decl/ability/cult/construct/floor
	name                    = "Floor Construction"
	desc                    = "This spell constructs a cult floor"
	cooldown_time           = 2 SECONDS
	summon_type             = /turf/floor/cult
	ability_icon_state      = "const_floor"

/decl/ability/cult/construct/wall
	name                    = "Lesser Construction"
	desc                    = "This spell constructs a cult wall"
	cooldown_time           = 10 SECONDS
	summon_type             = /turf/wall/cult
	ability_icon_state      = "const_wall"

/decl/ability/cult/construct/wall/reinforced
	name                    = "Greater Construction"
	desc                    = "This spell constructs a reinforced metal wall"
	cooldown_time           = 30 SECONDS
	cooldown_time           = 5 SECONDS
	summon_type             = /turf/wall/r_wall

/decl/ability/cult/construct/soulstone
	name                    = "Summon Soulstone"
	desc                    = "This spell reaches into Nar-Sie's realm, summoning one of the legendary fragments across time and space"
	cooldown_time           = 5 MINUTES
	summon_type             = /obj/item/soulstone
	ability_icon_state      = "const_stone"

/decl/ability/cult/construct/pylon
	name                    = "Red Pylon"
	desc                    = "This spell conjures a fragile crystal from Nar-Sie's realm. Makes for a convenient light source."
	cooldown_time           = 20 SECONDS
	summon_type             = /obj/structure/cult/pylon
	ability_icon_state      = "const_pylon"

/*
/decl/ability/cult/construct/pylon/cast(list/targets)
	..()
	var/turf/spawn_place = pick(targets)
	for(var/obj/structure/cult/pylon/P in spawn_place.contents)
		if(P.isbroken)
			P.repair(usr)
*/

/decl/ability/cult/construct/forcewall/lesser
	name                    = "Force Shield"
	desc                    = "Allows you to pull up a shield to protect yourself and allies from incoming threats"
	cooldown_time           = 30 SECONDS
	summon_type             = /obj/effect/forcefield/cult
	ability_use_channel     = 20 SECONDS
	ability_icon_state      = "const_juggwall"

//Code for the Juggernaut construct's forcefield, that seemed like a good place to put it.
/obj/effect/forcefield/cult
	desc                    = "This eerie-looking obstacle seems to have been pulled from another dimension through sheer force."
	name                    = "Juggerwall"
	icon                    = 'icons/effects/effects.dmi'
	icon_state              = "m_shield_cult"
	light_color             = "#b40000"
	light_range             = 2
