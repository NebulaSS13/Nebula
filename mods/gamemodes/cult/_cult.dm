#define isconstruct(A) istype(A, /mob/living/simple_animal/construct)

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