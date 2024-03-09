//added by cael from old bs12
//not sure if there's an immediate place for secure wall lockers, but i'm sure the players will think of something

/obj/structure/closet/walllocker
	desc = "A wall mounted storage locker."
	name = "Wall Locker"
	icon = 'icons/obj/closets/bases/wall.dmi'
	closet_appearance = /decl/closet_appearance/wall
	density = FALSE
	anchored = TRUE
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":-32}, "WEST":{"x":32}}'

/obj/structure/closet/walllocker/Initialize()
	. = ..()
	tool_interaction_flags &= ~TOOL_INTERACTION_ANCHOR

/obj/structure/closet/walllocker/suit
	name = "wall suit storage"
	desc = "A nook in the wall storing a couple of space suits."
	closet_appearance = /decl/closet_appearance/wall/suit

/obj/structure/closet/walllocker/suit/WillContain()
	return list(
		/obj/item/clothing/head/helmet/space = 2,
		/obj/item/clothing/suit/space = 2,
		/obj/item/tank/oxygen = 2
	)
