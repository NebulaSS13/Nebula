/obj/item/curtain
	name = "rolled curtain"
	desc = "A rolled-up curtain."
	icon = 'icons/obj/structures/curtain.dmi'
	icon_state = "curtain_rolled"
	_base_attack_force = 3 //just plastic
	w_class = ITEM_SIZE_HUGE //curtains, yeap
	var/curtain_kind_path = /decl/curtain_kind //path to decl containing the curtain's details

/obj/item/curtain/Initialize(ml, material_key)
	. = ..()
	if(curtain_kind_path)
		set_curtain_kind(GET_DECL(curtain_kind_path))

/obj/item/curtain/proc/set_curtain_kind(var/decl/curtain_kind/kind)

	if(!istype(kind))
		CRASH("Invalid curtain kind supplied to set_curtain_kind on [type]: [kind || "NULL"]")

	curtain_kind_path = kind.type
	SetName("rolled [kind.name]")
	set_material(kind.material_key) //set health and etc
	matter = atom_info_repository.get_matter_for(/obj/structure/curtain, kind.material_key)
	update_icon()

/obj/item/curtain/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		if(!curtain_kind_path)
			return

		if(!isturf(loc))
			to_chat(user, SPAN_DANGER("You cannot install \the [src] from your hands."))
			return

		if(isspaceturf(loc))
			to_chat(user, SPAN_DANGER("You cannot install \the [src] in space."))
			return

		user.visible_message(
			SPAN_NOTICE("\The [user] begins installing \the [src]."),
			SPAN_NOTICE("You begin installing \the [src]."))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)

		if(!do_after(user, 4 SECONDS, src))
			return

		if(QDELETED(src))
			return

		var/decl/curtain_kind/kind = GET_DECL(curtain_kind_path)
		var/obj/structure/curtain/C = kind.make_structure(loc, dir)
		transfer_fingerprints_to(C)
		qdel(src)
	else
		..()

/obj/item/curtain/on_update_icon()
	. = ..()
	if(curtain_kind_path)
		var/decl/curtain_kind/kind = GET_DECL(curtain_kind_path)
		alpha = kind.alpha
		color = kind.color

//
// Curtain Structure
//
/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/structures/curtain.dmi'
	icon_state = "closed"
	layer = ABOVE_WINDOW_LAYER
	opacity = TRUE
	density = FALSE
	anchored = TRUE
	var/curtain_kind_path = /decl/curtain_kind

/obj/structure/curtain/open
	icon_state = "open"
	layer = ABOVE_HUMAN_LAYER
	opacity = FALSE

/obj/structure/curtain/Initialize(ml, _mat, _reinf_mat)
	. = ..(ml)
	set_extension(src, /datum/extension/turf_hand)
	if(curtain_kind_path)
		set_curtain_kind(GET_DECL(curtain_kind_path))

/obj/structure/curtain/proc/set_curtain_kind(var/decl/curtain_kind/kind)

	if(!istype(kind))
		CRASH("Invalid curtain kind supplied to set_curtain_kind on [type]: [kind || "NULL"]")

	SetName(kind.name)
	curtain_kind_path = kind.type
	material = GET_DECL(kind.material_key)
	create_matter()
	update_icon()

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message(SPAN_WARNING("[P] tears \the [src] down!"))
		qdel(src)
	else
		..(P, def_zone)

/obj/structure/curtain/attack_hand(mob/user)
	if(user.check_dexterity(DEXTERITY_HOLD_ITEM))
		toggle()
		return TRUE
	return ..()

/obj/structure/curtain/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		if(!curtain_kind_path)
			return

		user.visible_message(
			SPAN_NOTICE("\The [user] begins uninstalling \the [src]."),
			SPAN_NOTICE("You begin uninstalling \the [src]."))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)

		if(!do_after(user, 4 SECONDS, src))
			return

		if(QDELETED(src))
			return

		var/decl/curtain_kind/kind = GET_DECL(curtain_kind_path)
		var/obj/item/curtain/C = kind.make_item(loc)
		transfer_fingerprints_to(C)
		qdel(src)
	else
		..()

/obj/structure/curtain/proc/toggle()
	playsound(src, 'sound/effects/curtain.ogg', 15, 1, -5)
	set_opacity(!opacity)

/obj/structure/curtain/set_opacity()
	. = ..()
	if(.)
		update_icon()

/obj/structure/curtain/on_update_icon()
	..()
	icon_state = opacity ? "closed" : "open"
	layer = opacity ? ABOVE_HUMAN_LAYER : ABOVE_WINDOW_LAYER
	if(curtain_kind_path)
		var/decl/curtain_kind/kind = GET_DECL(curtain_kind_path)
		alpha = kind.alpha
		set_color(kind.color)

// Subtypes for mapping/spawning below:
// - Item subtypes
/obj/item/curtain/bed
	curtain_kind_path = /decl/curtain_kind/cloth/bed
/obj/item/curtain/black
	curtain_kind_path = /decl/curtain_kind/cloth/black
/obj/item/curtain/bar
	curtain_kind_path = /decl/curtain_kind/cloth/bar
/obj/item/curtain/medical
	curtain_kind_path = /decl/curtain_kind/plastic/medical
/obj/item/curtain/privacy
	curtain_kind_path = /decl/curtain_kind/plastic/privacy
/obj/item/curtain/shower
	curtain_kind_path = /decl/curtain_kind/plastic/shower
/obj/item/curtain/shower/engineering
	curtain_kind_path = /decl/curtain_kind/plastic/shower/engineering
/obj/item/curtain/shower/security
	curtain_kind_path = /decl/curtain_kind/plastic/shower/security
/obj/item/curtain/canteen
	curtain_kind_path = /decl/curtain_kind/plastic/canteen

// - Closed subtypes
/obj/structure/curtain/bed
	curtain_kind_path = /decl/curtain_kind/cloth/bed
	color = /decl/curtain_kind/cloth/bed::color
/obj/structure/curtain/black
	curtain_kind_path = /decl/curtain_kind/cloth/black
	color = /decl/curtain_kind/cloth/black::color
/obj/structure/curtain/bar
	curtain_kind_path = /decl/curtain_kind/cloth/bar
	color = /decl/curtain_kind/cloth/bar::color
/obj/structure/curtain/medical
	curtain_kind_path = /decl/curtain_kind/plastic/medical
	color = /decl/curtain_kind/plastic/medical::color
	alpha = /decl/curtain_kind/plastic/medical::alpha
/obj/structure/curtain/privacy
	curtain_kind_path = /decl/curtain_kind/plastic/privacy
	color = /decl/curtain_kind/plastic/privacy::color
/obj/structure/curtain/shower
	curtain_kind_path = /decl/curtain_kind/plastic/shower
	color = /decl/curtain_kind/plastic/shower::color
	alpha = /decl/curtain_kind/plastic/shower::alpha
/obj/structure/curtain/canteen
	curtain_kind_path = /decl/curtain_kind/plastic/canteen
	color = /decl/curtain_kind/plastic/canteen::color

// - Open subtypes
/obj/structure/curtain/open/bed
	curtain_kind_path = /decl/curtain_kind/cloth/bed
	color = /decl/curtain_kind/cloth/bed::color
/obj/structure/curtain/open/black
	curtain_kind_path = /decl/curtain_kind/cloth/black
	color = /decl/curtain_kind/cloth/black::color
/obj/structure/curtain/open/medical
	curtain_kind_path = /decl/curtain_kind/plastic/medical
	color = /decl/curtain_kind/plastic/medical::color
	alpha = /decl/curtain_kind/plastic/medical::alpha
/obj/structure/curtain/open/bar
	curtain_kind_path = /decl/curtain_kind/cloth/bar
	color = /decl/curtain_kind/cloth/bar::color
/obj/structure/curtain/open/privacy
	curtain_kind_path = /decl/curtain_kind/plastic/privacy
	color = /decl/curtain_kind/plastic/privacy::color
/obj/structure/curtain/open/shower
	curtain_kind_path = /decl/curtain_kind/plastic/shower
	color = /decl/curtain_kind/plastic/shower::color
	alpha = /decl/curtain_kind/plastic/shower::alpha
/obj/structure/curtain/open/canteen
	curtain_kind_path = /decl/curtain_kind/plastic/canteen
	color = /decl/curtain_kind/plastic/canteen::color
/obj/structure/curtain/open/shower/engineering
	curtain_kind_path = /decl/curtain_kind/plastic/shower/engineering
	color = /decl/curtain_kind/plastic/shower/engineering::color
/obj/structure/curtain/open/shower/security
	curtain_kind_path = /decl/curtain_kind/plastic/shower/security
	color = /decl/curtain_kind/plastic/shower/security::color
