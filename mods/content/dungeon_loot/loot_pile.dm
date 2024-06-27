/obj/structure/loot_pile
	abstract_type = /obj/structure/loot_pile
	name = "base loot pile"
	desc = "If you can read me, this is bugged."
	icon = 'mods/content/dungeon_loot/icons/loot_piles.dmi'
	icon_state = "randompile"
	density = FALSE
	anchored = TRUE

	/// Keys that have searched this loot pile, with values of searched time.
	var/list/searched_by
	/// If true, the same person can loot multiple times.  Mostly for debugging.
	var/allow_multiple_looting = FALSE
	/// Used so you can't spamclick to loot.
	var/busy = FALSE
	/// Unlucky people might need to loot multiple spots to find things.
	var/chance_nothing = 0
	/// Probability of pulling from the uncommon_loot list.
	var/chance_uncommon = 10
	/// Ditto, but for rare_loot list.
	var/chance_rare = 1
	/// If true, loot piles can be 'depleted' after a certain number of searches by different players, where no more loot can be obtained.
	var/loot_depletion = FALSE
	/// When this reaches zero, and loot_depleted is true, you can't obtain anymore loot.
	var/loot_left = 0
	/// If true, and if the loot gets depleted as above, the pile is deleted.
	var/delete_on_depletion = FALSE

/obj/structure/loot_pile/Initialize()
	var/list/icon_states_to_use = get_icon_states_to_use()
	if(icon_states_to_use && icon_states_to_use.len)
		icon_state = pick(icon_states_to_use)
	. = ..()

/obj/structure/loot_pile/attack_ai(var/mob/user)
	if(isrobot(user) && Adjacent(user))
		return attack_hand(user)
	return ..()

/obj/structure/loot_pile/attack_hand(mob/user)

	if(!isliving(user))
		return ..()

	var/mob/living/L = user
	if(busy)
		to_chat(L, SPAN_WARNING("\The [src] is already being searched."))
		return TRUE

	L.visible_message("\The [user] searches through \the [src].", SPAN_NOTICE("You search through \the [src]."), SPAN_NOTICE("You hear some rustling."))

	//Do the searching
	busy = TRUE
	if(!do_after(user,rand(4 SECONDS,6 SECONDS),src))
		busy = FALSE
		return TRUE
	busy = FALSE

	// The loot's all gone.
	if(loot_depletion && loot_left <= 0)
		to_chat(L, SPAN_WARNING("\The [src] has been picked clean."))
		return TRUE

	//You already searched this one
	if(!allow_multiple_looting && LAZYISIN(user.ckey, searched_by))
		to_chat(L, SPAN_WARNING("You can't find anything else vaguely useful in \the [src]. Another set of eyes might, however."))
		return TRUE

	// You got unlucky.
	if(chance_nothing && prob(chance_nothing))
		to_chat(L, SPAN_WARNING("Nothing in this pile really catches your eye this time."))
		return TRUE

	// You found something!
	LAZYDISTINCTADD(searched_by, user.ckey)
	var/obj/item/loot = null
	var/span = "notice" // Blue

	if(prob(chance_rare) && length(get_rare_loot())) // You won THE GRAND PRIZE!
		loot = produce_rare_item()
		span = "cult" // Purple and bold.
	else if(prob(chance_uncommon) && length(get_uncommon_loot())) // Otherwise you might still get something good.
		loot = produce_uncommon_item()
		span = "alium" // Green
	else if(length(get_common_loot())) // Welp.
		loot = produce_common_item()

	if(loot)
		loot.forceMove(get_turf(src))
		to_chat(L, SPAN_CLASS(span, "You found \a [loot]!"))
		if(loot_depletion)
			loot_left--
			if(loot_left <= 0)
				to_chat(L, SPAN_WARNING("You seem to have gotten the last of the spoils inside \the [src]."))
				if(delete_on_depletion)
					qdel(src)
	return TRUE

/obj/structure/loot_pile/proc/produce_common_item()
	var/list/common_loot = get_common_loot()
	if(length(common_loot))
		var/path = pick(common_loot)
		return new path(src)

/obj/structure/loot_pile/proc/produce_uncommon_item()
	var/list/uncommon_loot = get_uncommon_loot()
	if(length(uncommon_loot))
		var/path = pick(uncommon_loot)
		return new path(src)

/obj/structure/loot_pile/proc/produce_rare_item()
	var/list/rare_loot = get_rare_loot()
	if(length(rare_loot))
		var/path = pick(rare_loot)
		return new path(src)

/// Returns a list of generally less-than-useful junk and filler, at least for maint loot piles.
/obj/structure/loot_pile/proc/get_common_loot()
	return

/// Returns a list of some maybe actually useful items, usually the reason someone bothers looking inside.
/obj/structure/loot_pile/proc/get_uncommon_loot()
	return

/// Returns a list of really powerful, or at least unique items.
/obj/structure/loot_pile/proc/get_rare_loot()
	return

/// Returns a list of icon states the pile can choose from on initialization. If empty or null, it will stay the initial icon_state.
/obj/structure/loot_pile/proc/get_icon_states_to_use()
	return
