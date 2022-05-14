/datum/progress_bar
	// Settings
	var/name
	/// The goal value to reach. When [/datum/progress_bar/proc/update] is called, a fraction is calculated with the goal.
	var/goal = 100
	/// The icon file to use for the visual element.
	var/icon
	/// The total height in pixels of the theme's progress bar.
	var/height
	/// The width in pixels of the theme's fill sprite.
	var/fill_width
	/// The total time that determines the speed for appear animation.
	var/animation_time_appear = 0.5 SECOND
	/// The total time that determines the speed for fade animation.
	var/animation_time_fade = 0.5 SECOND
	/// The total time that determines the speed for shift down animation.
	var/animation_time_shift = 0.5 SECOND

	// Variables
	/// The target to display the progress bar on.
	var/atom/target
	/// The main visual element holding everything up.
	var/image/holder
	/// The backdrop visual element. Contains the fill and mask as overlays.
	var/image/backdrop
	/// The fill visual element.
	var/image/fill
	/// The mob currently owning the progress bar, used to calculate the bar's vertical position.
	var/mob/user
	/// The client currently owning the progress bar for display.
	var/client/client
	/// The bar's index number within the owning mob's active progress bar list.
	var/list_index
	/// Whether the bar is stopping.
	var/stopping = FALSE
	/// Stored progress number for the goal fail effect.
	var/last_progress = 0

/datum/progress_bar/New(mob/param_user, param_goal, atom/param_target)
	. = ..()
	if(!istype(param_target))
		throw EXCEPTION("datum/progress_bar: Invalid param given - param_target")

	target = param_target
	user = param_user
	goal = param_goal
	init_images(target)

	if(user)
		client = user.client
		client?.images |= holder

		LAZYINITLIST(user.progress_bars)
		LAZYINITLIST(user.progress_bars[target])
		var/list/bars = user.progress_bars[target]
		bars += src
		list_index = length(bars)
		animate(holder, pixel_z = world.icon_size + (height * (list_index - 1)), alpha = 255, time = animation_time_appear, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
	else
		animate(holder, alpha = 255, time = animation_time_appear, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)

/datum/progress_bar/Destroy()
	cleanup()
	client?.images -= holder
	QDEL_NULL(holder)
	QDEL_NULL(backdrop)
	QDEL_NULL(fill)
	target = null
	user = null
	client = null
	return ..()

/**
  * Stops the progress bar and destoy it after a bit.
  */
/datum/progress_bar/proc/stop()
	set waitfor = FALSE

	shift_down_all()
	update(last_progress)
	animate(holder, alpha = 0, time = animation_time_fade, flags = ANIMATION_PARALLEL)
	sleep(animation_time_fade)
	qdel(src)

/**
  * Calls the shift animation on all attached bars.
  */
/datum/progress_bar/proc/shift_down_all()
	if(user?.progress_bars[target])
		var/list/bars = user.progress_bars[target]
		var/list_index = bars.Find(src)
		for(var/i = list_index, i <= length(bars), i++)
			var/datum/progress_bar/P = bars[i]
			P.shift()

/**
  * Cleanups before deletion.
  */
/datum/progress_bar/proc/cleanup()
	if(user?.progress_bars[target])
		var/list/bars = user.progress_bars[target]
		bars -= src
		if(!length(bars))
			LAZYREMOVE(user.progress_bars, target)

/**
  * Initializes the visual elements.
  *
  * Arguments:
  * * target - The atom to parent the images to.
  */
/datum/progress_bar/proc/init_images(target)
	holder = image('icons/effects/effects.dmi', target, "nothing", HUD_ABOVE_ITEM_LAYER)
	holder.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	holder.alpha = 0
	holder.plane = HUD_PLANE
	holder.appearance_flags = KEEP_TOGETHER | APPEARANCE_UI_IGNORE_ALPHA

	backdrop = image(icon, target, "backdrop")

	fill = image(icon, target, "fill")
	fill.filters = filter(type = "alpha", icon = icon(icon, "mask"), x = -fill_width)

	holder.overlays += backdrop
	holder.overlays += fill

/**
  * Call periodically to update the progress bar's progress.
  *
  * Arguments:
  * * progress - The new value, divided with the given goal on creation to calculate the fraction.
  */
/datum/progress_bar/proc/update(progress)
	if(QDELETED(target))
		qdel(src)
		return

	if(user?.client != client)
		client?.images -= holder
		if(!QDELETED(user) && user?.client)
			client = user.client
			client.images += holder

	. = clamp(progress / goal, 0, 1)
	last_progress = progress
	if(fill)
		holder.overlays -= fill
		update_fill(.)
		holder.overlays += fill

/**
  * Updates the fill. Do your visual changes here.
  *
  * Arguments:
  * * fraction - The new (value / goal) fraction.
  */
/datum/progress_bar/proc/update_fill(fraction)
	UNLINT(fill?.filters[1]?.x = -fill_width * (1 - fraction))

/**
  * Shifts the progress bar down.
  */
/datum/progress_bar/proc/shift()
	animate(holder,
		pixel_z = holder.pixel_z - height,
		time = animation_time_shift,
		easing = SINE_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL
	)

/datum/progress_bar/default
	name = "default"
	icon = 'icons/effects/progress_bar/default.dmi'
	fill_width = 22
	height = 7

/datum/progress_bar/default/update_fill(fraction)
	. = ..()
	if(!stopping)
		fill.color = gradient(0, "#cc0033", 0.25, "#cc6633", 0.5, "#d1cc33", 0.75, "#00cc33", fraction)
	else if(last_progress != goal)
		animate(fill, time = 0.5 SECOND, loop = -1, flags = ANIMATION_PARALLEL, alpha = 0, color = "#cc0033")
		animate(time = 0.5 SECOND, alpha = 255)
	else
		fill.color = COLOR_YELLOW

/datum/progress_bar/default/slim
	name = "default (slim)"
	icon = 'icons/effects/progress_bar/default_slim.dmi'
	height = 5

/**
  * An example progress bar that stays yellow then blinks red every now and then.
  */
/datum/progress_bar/warning
	name = "warning"
	icon = 'icons/effects/progress_bar/warning.dmi'
	fill_width = 22
	height = 7

/datum/progress_bar/warning/update_fill(fraction)
	. = ..()
	if(fraction <= 0.5)
		fill.color = COLOR_YELLOW
	else
		fill.color = gradient(0.5, COLOR_YELLOW, 0.5, COLOR_RED, "loop", fraction * 10)

/datum/progress_bar/warning/slim
	name = "warning (slim)"
	icon = 'icons/effects/progress_bar/warning_slim.dmi'
	height = 5

/**
  * Creates a new progress bar datum with the given theme.
  *
  * Arguments:
  * * user - The mob seeing the progress bar.
  * * goal - The goal number.
  * * target - The atom to display the bar on.
  * * theme - The progress bar's theme (type).
  */
/proc/create_progress_bar(mob/user, goal, atom/target, theme = /datum/progress_bar/default)
	return new theme(user, goal, target)
