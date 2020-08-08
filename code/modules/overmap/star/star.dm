/obj/effect/overmap/star
	name = "star" //temp name, we randomly pick a class and scale size and such accordingly on init.
	icon_state = "star"
	appearance_flags = PIXEL_SCALE

	var/decl/star_class/class //What class this star is.
	var/decl/star_type/startype //What type it is (supergiant etc)
	var/star_luminosity
	var/filter_offset

/obj/effect/overmap/star/Initialize()
	. = ..()
	var/list/classes = subtypesof(/decl/star_class)
	class = pick(classes) //Randomly grab a star type.
	class = decls_repository.get_decl(class)

	var/list/types = class.possible_types
	startype = pick(types)
	startype = decls_repository.get_decl(startype)

	name = "[GLOB.using_map.system_name], [startype.denomination] [class.star_class] [startype.name]"
	color = class.color
	star_luminosity = class.luminosity + startype.luminosity_bonus
	filters += filter(type="blur", size = 1)

/decl/star_class
	var/star_class //What class the star is - this is used for the name.
	var/color //What color the star is, this is used to color it's light source and the star itself.
	var/luminosity = 0 //We use this to adjust the amount of power solar panels generate, plus some other maths.
	var/list/possible_types = list() //Some classes of star can't be certain types, so we define what they can be in a list that's picked from.

/decl/star_class/K
	star_class = "K-Class"
	color = "#f5a700"
	luminosity = 0.5
	possible_types = list(/decl/star_type/III, /decl/star_type/V)

/decl/star_class/M
	star_class = "M-Class"
	color = "#f50000"
	luminosity = 0.4
	possible_types = list(/decl/star_type/III, /decl/star_type/Ia)

/decl/star_class/G
	star_class = "G-Class"
	color = "#f5c400"
	luminosity = 0.7
	possible_types = list(/decl/star_type/V, /decl/star_type/IV, /decl/star_type/Ib)

/decl/star_class/A
	star_class = "A-Class"
	color = "#bacff5"
	luminosity = 0.8
	possible_types = list(/decl/star_type/V, /decl/star_type/Ia, /decl/star_type/Ib)

/decl/star_class/B
	star_class = "B-Class"
	color = "#43a8fa"
	luminosity = 1.2
	possible_types = list(/decl/star_type/V, /decl/star_type/Ia, /decl/star_type/Ib)

/decl/star_class/O
	star_class = "O-Class"
	color = "#bfe2ff"
	luminosity = 1.5
	possible_types = list(/decl/star_type/V)

/decl/star_class/L
	star_class = "L-Class"
	color = "#a80707"
	luminosity = 0.2
	possible_types = list(/decl/star_type/V, /decl/star_type/IV)

/decl/star_class/Y
	star_class = "Y-Class"
	color = "#730045"
	luminosity = 0.1
	possible_types = list(/decl/star_type/Ia)

/decl/star_class/D
	star_class = "D-Class"
	color = "#ebf1f2"
	luminosity = 0.4
	possible_types = list(/decl/star_type/IV)

/decl/star_type
	var/name //Name of the type - refer to Yerkes Luminosity Classes
	var/denomination //the actual letter designation.
	var/scale_size //And the scale size.
	var/luminosity_bonus //Add a little bit to our luminosity depending on type.

/decl/star_type/Ia
	name = "luminous supergiant"
	denomination = "Type-Ia"
	luminosity_bonus = 1

/decl/star_type/Ib
	name = "less luminous supergiant"
	denomination = "Type-Ib"
	luminosity_bonus = 0.6

/decl/star_type/II
	name = "luminous giant"
	denomination = "Type-II"
	luminosity_bonus = 0.5

/decl/star_type/III
	name = "giant"
	denomination = "Type-III"

/decl/star_type/IV
	name = "subgiant"
	denomination = "Type-IV"

/decl/star_type/V
	name = "main sequence star"
	denomination = "Type-V"

/decl/star_type/Ia
	name = "dwarf"
	denomination = "Type-VI"



