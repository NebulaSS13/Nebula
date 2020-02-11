GLOBAL_LIST_INIT(station_bookcases, new)
/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = 1
	density = 1
	opacity = 1
	obj_flags = OBJ_FLAG_ANCHORABLE
	material = MAT_WOOD
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR

/obj/structure/bookcase/Initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/book))
			I.forceMove(src)
	if(z in GLOB.using_map.station_levels)
		GLOB.station_bookcases += src
	. = ..()

/obj/structure/bookcase/Destroy()
	GLOB.station_bookcases -= src
	. = ..()

/obj/structure/bookcase/create_dismantled_products(var/turf/T)
	for(var/obj/item/book/b in contents)
		b.dropInto(T)
	. = ..()

/obj/structure/bookcase/attackby(obj/O, mob/user)
	. = ..()
	if(!.)
		if(istype(O, /obj/item/book) && user.unEquip(O, src))
			update_icon()
		else if(istype(O, /obj/item/pen))
			var/newname = sanitizeSafe(input("What would you like to title this bookshelf?"), MAX_NAME_LEN)
			if(!newname)
				return
			else
				SetName("bookcase ([newname])")

/obj/structure/bookcase/attack_hand(var/mob/user)
	if(contents.len)
		var/obj/item/book/choice = input("Which book would you like to remove from the shelf?") as null|obj in contents
		if(choice)
			if(!CanPhysicallyInteract(user))
				return
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(choice)
			else
				choice.dropInto(loc)
			update_icon()

/obj/structure/bookcase/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/item/book/b in contents)
				qdel(b)
			qdel(src)
			return
		if(2.0)
			for(var/obj/item/book/b in contents)
				if (prob(50)) b.dropInto(loc)
				else qdel(b)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				for(var/obj/item/book/b in contents)
					b.dropInto(loc)
				qdel(src)
			return
		else
	return

/obj/structure/bookcase/on_update_icon()
	if(contents.len < 5)
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

/obj/structure/bookcase/manuals/research_and_development
	name = "R&D Manuals bookcase"

/obj/structure/bookcase/manuals/research_and_development/Initialize()
	. = ..()
	new /obj/item/book/manual/research_and_development(src)
	update_icon()
