/datum/storage/mre
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'

/datum/storage/mre/open(mob/user)
	if(!opened)
		to_chat(user, "<span class='notice'>You tear open the bag, breaking the vacuum seal.</span>")
	. = ..()

/datum/storage/mrebag
	storage_slots = 1
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/bubbles.ogg'

/datum/storage/mrebag/open(mob/user)
	if(!opened)
		to_chat(user, "<span class='notice'>The pouch heats up as you break the vaccum seal.</span>")
	. = ..()

/datum/storage/mrebag/dessert
	open_sound = 'sound/effects/rip1.ogg'
