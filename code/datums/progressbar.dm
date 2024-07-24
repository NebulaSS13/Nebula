#define PROGRESSBAR_HEIGHT 6
#define PROGRESSBAR_ANIMATION_TIME 5

/datum/progressbar
	var/goal = 1
	var/last_progress = 0
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/listindex
	var/anchor_offset_x = 0
	var/anchor_offset_y = 0

/datum/progressbar/New(mob/user, goal_number, atom/target)
	. = ..()
	if(!target) target = user
	if (!istype(target))
		EXCEPTION("Invalid target given")
	if (goal_number)
		goal = goal_number
	bar = image('icons/effects/progressbar.dmi', target, "prog_bar_0")
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	bar.blend_mode = BLEND_OVERLAY
	bar.plane = HUD_PLANE
	bar.layer = HUD_ABOVE_ITEM_LAYER

	// This is used to center the do_after() bar on nonstandard icons.
	var/icon/icon_icon = icon(target.icon) // /atom/icon isn't an /icon. Noting for posterity that we're going off the idea
	var/icon_width = icon_icon.Width()     // that icon() doesn't add to the RSC so doens't involve network overhead.
	if(icon_width != world.icon_size)
		anchor_offset_x = round((icon_width/2)-(world.icon_size/2))
	var/icon_height = icon_icon.Height()
	if(icon_height != world.icon_size)
		anchor_offset_y = round((icon_height/2)-(world.icon_size/2))
	bar.pixel_x = anchor_offset_x
	bar.pixel_y = anchor_offset_y

	src.user = user
	if(user)
		client = user.client

	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	bars.Add(src)
	listindex = bars.len

	bar.alpha = 0
	animate(bar, pixel_y = anchor_offset_y + 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/proc/update(progress)
	if (!user || !user.client)
		shown = FALSE
		return
	if (user.client != client)
		client.images.Remove(bar)
		shown = FALSE
	client = user.client

	progress = clamp(progress, 0, goal)
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if (!shown && user.get_preference_value(/datum/client_preference/show_progress_bar) == PREF_SHOW)
		user.client.images.Add(bar)
		shown = TRUE

/datum/progressbar/proc/shiftDown()
	--listindex
	bar.pixel_y = anchor_offset_y + 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))
	var/dist_to_travel = anchor_offset_y + 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)) - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = dist_to_travel, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/Destroy()
	if(last_progress != goal)
		bar.icon_state = "[bar.icon_state]_fail"
	for(var/I in user.progressbars[bar.loc])
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = user.progressbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)

	animate(bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	addtimer(CALLBACK(src, PROC_REF(remove_from_client)), PROGRESSBAR_ANIMATION_TIME, TIMER_CLIENT_TIME)
	QDEL_IN(bar, PROGRESSBAR_ANIMATION_TIME * 2) //for garbage collection safety
	. = ..()

/datum/progressbar/proc/remove_from_client()
	if(client)
		client.images.Remove(bar)
		client = null

#undef PROGRESSBAR_ANIMATION_TIME
#undef PROGRESSBAR_HEIGHT