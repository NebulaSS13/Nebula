var/global/list/station_bookcases = list()
/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/structures/bookcase.dmi'
	icon_state = "book-0"
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	material = /decl/material/solid/wood
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR

/obj/structure/bookcase/Initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.forceMove(src)
	if(isStationLevel(z))
		global.station_bookcases += src
	get_or_create_extension(src, /datum/extension/labels/single)
	. = ..()

/obj/structure/bookcase/Destroy()
	global.station_bookcases -= src
	. = ..()

/obj/structure/bookcase/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/book) && user.try_unequip(O, src))
		update_icon()
		return TRUE
	return ..()

/obj/structure/bookcase/attack_hand(var/mob/user)
	if(!length(contents) || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
	if(choice && (choice in contents) && CanPhysicallyInteract(user))
		user.put_in_hands(choice)
		update_icon()
	return TRUE

/obj/structure/bookcase/on_update_icon()
	..()
	if(length(contents) < 5)
		icon_state = "book-[contents.len]"
	else
		icon_state = "book-5"

/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

/obj/structure/bookcase/manuals/medical/Initialize()
	. = ..()
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/chemistry_recipes(src)
	update_icon()

/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

/obj/structure/bookcase/manuals/engineering/Initialize()
	. = ..()
	new /obj/item/book/manual/engineering_construction(src)
	new /obj/item/book/manual/engineering_particle_accelerator(src)
	new /obj/item/book/manual/engineering_hacking(src)
	new /obj/item/book/manual/engineering_guide(src)
	new /obj/item/book/manual/atmospipes(src)
	new /obj/item/book/manual/engineering_singularity_safety(src)
	new /obj/item/book/manual/evaguide(src)
	new /obj/item/book/manual/rust_engine(src)
	update_icon()

/obj/structure/bookcase/cart
	name = "book cart"
	anchored = FALSE
	opacity = FALSE
	desc = "A mobile cart for carrying books around."
	movable_flags = MOVABLE_FLAG_WHEELED
	icon = 'icons/obj/structures/book_cart.dmi'
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	obj_flags = 0
