#define isconstruct(A) istype(A, /mob/living/simple_animal/construct)

#define CULTINESS_PER_CULTIST 40
#define CULTINESS_PER_SACRIFICE 40
#define CULTINESS_PER_TURF 1

#define CULT_RUNES_1 200
#define CULT_RUNES_2 400
#define CULT_RUNES_3 1000

#define CULT_GHOSTS_1 400
#define CULT_GHOSTS_2 800
#define CULT_GHOSTS_3 1200

#define CULT_MAX_CULTINESS 1200 // When this value is reached, the game stops checking for updates so we don't recheck every time a tile is converted in endgame

/decl/modpack/cult
	name = "Cult Gamemode Content"

/decl/modpack/cult/post_initialize()
	. = ..()
	global.href_to_mob_type["Constructs"] = list(
		"Armoured" = /mob/living/simple_animal/construct/armoured,
		"Builder" =  /mob/living/simple_animal/construct/builder,
		"Wraith" =   /mob/living/simple_animal/construct/wraith,
		"Shade" =    /mob/living/simple_animal/shade
	)