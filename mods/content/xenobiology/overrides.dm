/obj/structure/plasticflaps/Initialize()
	. = ..()
	mobs_can_pass |= /mob/living/slime

/obj/item/projectile/change/apply_transformation(var/mob/M, var/choice)
	if(choice == "slime")
		var/mob/living/slime/S = new(get_turf(M))
		S.universal_speak = TRUE
		return S
	. = ..()

/obj/item/projectile/change/get_random_transformation_options(var/mob/M)
	. = ..() || list()
	if(!isslime(M))
		. |= "slime"

/obj/item/scanner/xenobio/Initialize(ml, material_key)
	. = ..()
	valid_targets |= /mob/living/slime

/obj/machinery/auto_cloner/get_passive_mob_types()
	. = ..() || list()
	. |= /mob/living/simple_animal/slime

/obj/machinery/smartfridge/secure/extract
	name = "\improper Slime Extract Storage"
	desc = "A refrigerated storage unit for slime extracts."
	icon_contents = "slime"
	initial_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O)
	return istype(O,/obj/item/slime_extract)

/obj/item/gripper/research/Initialize(ml, material_key)
	. = ..()
	can_hold |= /obj/item/slime_extract

/obj/item/gripper/cultivator/Initialize(ml, material_key)
	. = ..()
	can_hold |= /obj/item/slime_extract
