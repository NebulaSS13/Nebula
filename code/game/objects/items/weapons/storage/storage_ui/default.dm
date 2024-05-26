/datum/storage_ui/default
	var/list/is_seeing = new/list() //List of mobs which are currently seeing the contents of this item's storage
	var/obj/screen/storage/boxes/boxes
	var/obj/screen/storage/close/closer
	var/obj/screen/storage/start/storage_start //storage UI
	var/obj/screen/storage/cont/storage_continue
	var/obj/screen/storage/end/storage_end
	var/obj/screen/stored/start/stored_start
	var/obj/screen/stored/cont/stored_continue
	var/obj/screen/stored/end/stored_end

/datum/storage_ui/default/New(var/storage)
	..()
	boxes            = new(null, null, null, null, null, null, storage)
	storage_start    = new(null, null, null, null, null, null, storage)
	storage_continue = new(null, null, null, null, null, null, storage)
	storage_end      = new(null, null, null, null, null, null, storage)
	closer           = new(null, null, null, null, null, null, storage)
	stored_start     = new
	stored_continue  = new
	stored_end       = new

/datum/storage_ui/default/Destroy()
	close_all()
	QDEL_NULL(boxes)
	QDEL_NULL(storage_start)
	QDEL_NULL(storage_continue)
	QDEL_NULL(storage_end)
	QDEL_NULL(stored_start)
	QDEL_NULL(stored_continue)
	QDEL_NULL(stored_end)
	QDEL_NULL(closer)
	. = ..()

/datum/storage_ui/default/on_open(var/mob/user)
	if (user.active_storage)
		user.active_storage.close(user)

/datum/storage_ui/default/after_close(var/mob/user)
	user.active_storage = null

/datum/storage_ui/default/on_insertion(var/mob/user)
	if(user.active_storage)
		user.active_storage.show_to(user)

/datum/storage_ui/default/on_pre_remove(var/mob/user, var/obj/item/W)
	for(var/mob/M in range(1, storage.loc))
		if (M.active_storage == storage)
			if (M.client)
				M.client.screen -= W

/datum/storage_ui/default/on_post_remove(var/mob/user)
	if(user && user.active_storage) // Using ?. here causes a runtime ('Cannot read 0.active_storage'), it shouldn't but it does.
		user.active_storage.show_to(user)

/datum/storage_ui/default/on_hand_attack(var/mob/user)
	for(var/mob/M in range(1))
		if (M.active_storage == storage)
			storage.close(M)

/datum/storage_ui/default/show_to(var/mob/user)
	if(user.active_storage != storage)
		for(var/obj/item/I in storage)
			if(I.on_found(user))
				return
	if(user.active_storage)
		user.active_storage.hide_from(user)
	user.client.screen -= boxes
	user.client.screen -= storage_start
	user.client.screen -= storage_continue
	user.client.screen -= storage_end
	user.client.screen -= closer
	user.client.screen -= storage.contents
	user.client.screen += closer
	user.client.screen += storage.contents
	if(storage.storage_slots)
		user.client.screen += boxes
	else
		user.client.screen += storage_start
		user.client.screen += storage_continue
		user.client.screen += storage_end
	is_seeing |= user
	user.active_storage = storage

/datum/storage_ui/default/hide_from(var/mob/user)
	is_seeing -= user
	if(!user.client)
		return
	user.client.screen -= boxes
	user.client.screen -= storage_start
	user.client.screen -= storage_continue
	user.client.screen -= storage_end
	user.client.screen -= closer
	user.client.screen -= storage.contents
	if(user.active_storage == storage)
		user.active_storage = null

//Creates the storage UI
/datum/storage_ui/default/prepare_ui()
	//if storage slots is null then use the storage space UI, otherwise use the slots UI
	if(storage.storage_slots == null)
		space_orient_objs()
	else
		slot_orient_objs()

/datum/storage_ui/default/close_all()
	for(var/mob/M in can_see_contents())
		storage.close(M)
		. = 1

/datum/storage_ui/default/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_seeing)
		if(M.active_storage == storage && M.client)
			cansee |= M
		else
			is_seeing -= M
	return cansee

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/datum/storage_ui/default/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	boxes.screen_loc = "LEFT+[tx],BOTTOM+[ty] to LEFT+[mx],BOTTOM+[my]"
	for(var/obj/O in storage.contents)
		O.screen_loc = "LEFT+[cx],BOTTOM+[cy]"
		O.hud_layerise()
		cx++
		if (cx > mx)
			cx = tx
			cy--
	closer.screen_loc = "LEFT+[mx+1],BOTTOM+[my]"
	return

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/datum/storage_ui/default/proc/slot_orient_objs()
	var/adjusted_contents = storage.contents.len
	var/row_num = 0
	var/col_count = min(7,storage.storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	arrange_item_slots(row_num, col_count)

#define SCREEN_LOC_MOD_FIRST   3
#define SCREEN_LOC_MOD_SECOND  1.7
#define SCREEN_LOC_MOD_DIVIDED (0.5 * world.icon_size)

//This proc draws out the inventory and places the items on it. It uses the standard position.
/datum/storage_ui/default/proc/arrange_item_slots(rows, cols)
	var/cx = SCREEN_LOC_MOD_FIRST
	var/cy = SCREEN_LOC_MOD_SECOND + rows
	boxes.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST]:[SCREEN_LOC_MOD_DIVIDED],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED] to LEFT+[SCREEN_LOC_MOD_FIRST + cols]:[SCREEN_LOC_MOD_DIVIDED],BOTTOM+[SCREEN_LOC_MOD_SECOND + rows]:[SCREEN_LOC_MOD_DIVIDED]"

	for(var/obj/O in storage.contents)
		O.screen_loc = "LEFT+[cx]:[SCREEN_LOC_MOD_DIVIDED],BOTTOM+[cy]:[SCREEN_LOC_MOD_DIVIDED]"
		O.maptext = ""
		O.hud_layerise()
		cx++
		if (cx > (SCREEN_LOC_MOD_FIRST + cols))
			cx = SCREEN_LOC_MOD_FIRST
			cy--

	closer.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST + cols + 1]:[SCREEN_LOC_MOD_DIVIDED],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED]"

/datum/storage_ui/default/proc/space_orient_objs()

	var/baseline_max_storage_space = DEFAULT_BOX_STORAGE //storage size corresponding to 224 pixels
	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min( round( 224 * storage.max_storage_space/baseline_max_storage_space ,1) ,284) //length of sprite for the box representing total storage space

	storage_start.overlays.Cut()

	var/matrix/M = matrix()
	M.Scale((storage_width-storage_cap_width*2+3)/32,1)
	storage_continue.transform = M

	storage_start.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST]:[SCREEN_LOC_MOD_DIVIDED],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED]"
	storage_continue.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST]:[storage_cap_width+(storage_width-storage_cap_width*2)/2+2],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED]"
	storage_end.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST]:[19+storage_width-storage_cap_width],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED]"

	var/startpoint = 0
	var/endpoint = 1

	for(var/obj/item/O in storage.contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_storage_cost()/storage.max_storage_space

		var/matrix/M_start = matrix()
		var/matrix/M_continue = matrix()
		var/matrix/M_end = matrix()
		M_start.Translate(startpoint,0)
		M_continue.Scale((endpoint-startpoint-stored_cap_width*2)/32,1)
		M_continue.Translate(startpoint+stored_cap_width+(endpoint-startpoint-stored_cap_width*2)/2 - 16,0)
		M_end.Translate(endpoint-stored_cap_width,0)
		stored_start.transform = M_start
		stored_continue.transform = M_continue
		stored_end.transform = M_end
		storage_start.overlays += stored_start
		storage_start.overlays += stored_continue
		storage_start.overlays += stored_end

		O.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST]:[round((startpoint+endpoint)/2)+2],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED]"
		O.maptext = ""
		O.hud_layerise()

	closer.screen_loc = "LEFT+[SCREEN_LOC_MOD_FIRST]:[storage_width+19],BOTTOM+[SCREEN_LOC_MOD_SECOND]:[SCREEN_LOC_MOD_DIVIDED]"

// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
/datum/storage_ui/default/sheetsnatcher/prepare_ui(var/mob/user)
	var/adjusted_contents = storage.contents.len

	var/row_num = 0
	var/col_count = min(7,storage.storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	arrange_item_slots(row_num, col_count)
	if(user && user.active_storage)
		user.active_storage.show_to(user)

#undef SCREEN_LOC_MOD_FIRST
#undef SCREEN_LOC_MOD_SECOND
#undef SCREEN_LOC_MOD_DIVIDED
