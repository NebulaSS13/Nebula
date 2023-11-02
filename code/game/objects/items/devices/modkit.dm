#define MODKIT_HELMET 1
#define MODKIT_SUIT 2
#define MODKIT_FULL 3

/obj/item/modkit
	name = "hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user."
	icon = 'icons/obj/items/modkit.dmi'
	icon_state = "modkit"
	material = /decl/material/solid/organic/plastic
	var/parts = MODKIT_FULL
	var/target_bodytype = BODYTYPE_HUMANOID

	var/list/permitted_types = list(
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void
		)

/obj/item/modkit/Initialize(ml, material_key)
	if(!target_bodytype)
		var/decl/species/species = GET_DECL(global.using_map.default_species)
		target_bodytype = species.default_bodytype.bodytype_flag
	. = ..()

/obj/item/modkit/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return

	if (!target_bodytype)
		return	//it shouldn't be null, okay?

	if(!parts)
		to_chat(user, "<span class='warning'>This kit has no parts for this modification left.</span>")
		qdel(src)
		return

	var/allowed = 0
	for (var/permitted_type in permitted_types)
		if(istype(O, permitted_type))
			allowed = 1

	var/obj/item/clothing/I = O
	if (!istype(I) || !allowed)
		to_chat(user, "<span class='notice'>[src] is unable to modify that.</span>")
		return

	if(!isturf(O.loc))
		to_chat(user, "<span class='warning'>[O] must be safely placed on the ground for modification.</span>")
		return

	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	user.visible_message("<span class='notice'>\The [user] opens \the [src] and modifies \the [O].</span>","<span class='notice'>You open \the [src] and modify \the [O].</span>")

	I.refit_for_bodytype(target_bodytype)

	if (istype(I, /obj/item/clothing/head/helmet))
		parts &= ~MODKIT_HELMET
	if (istype(I, /obj/item/clothing/suit))
		parts &= ~MODKIT_SUIT

	if(!parts)
		qdel(src)

/obj/item/modkit/examine(mob/user)
	. = ..(user)
	to_chat(user, "It looks as though it modifies hardsuits to fit [target_bodytype] users.")
