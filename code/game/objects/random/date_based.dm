/*****************
* Implementation *
*****************/

/obj/random/date_based
	name = "random object (date based)"
	icon_state = "yup"
	spawn_method = PROC_REF(check_date)
	abstract_type = /obj/random/date_based
	var/datum/is_date/date_check

/obj/random/date_based/Destroy()
	QDEL_NULL(date_check)
	return ..()

/obj/random/date_based/proc/check_date()
	if(date_check?.IsValid())
		return spawn_item()

/datum/is_date/proc/IsValid()
	return FALSE

/datum/is_date/proc/CurrentMonthAndDay()
	return current_month_and_day()

var/global/list/days_of_month
/datum/is_date/proc/ValidateMonthAndDay(month, day)
	. = FALSE
	if(!month || month < 1 || month > 12)
		CRASH("Invalid month: [month]")
	if(!global.days_of_month)
		global.days_of_month = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
		if(isLeap(text2num(time2text(world.realtime, "YYYY"))))
			global.days_of_month[2] = 29
	if(!day || day < 1 || day > global.days_of_month[month])
		CRASH("Invalid day: [day]")
	return TRUE

/datum/is_date/day
	var/month
	var/day

/datum/is_date/day/New(month, day)
	if(ValidateMonthAndDay(month, day))
		src.month = month
		src.day = day

/datum/is_date/day/IsValid()
	var/month_and_day = CurrentMonthAndDay()
	return month == month_and_day[1] && day == month_and_day[2]


/datum/is_date/range
	var/start_month
	var/start_day

	var/end_month
	var/end_day

/datum/is_date/range/New(start_month, start_day, end_month, end_day)
	if(ValidateMonthAndDay(start_month, start_day) && ValidateMonthAndDay(end_month, end_day))
		src.start_month = start_month
		src.start_day = start_day
		src.end_month = end_month
		src.end_day = end_day

/datum/is_date/range/IsValid()
	var/month_and_day = CurrentMonthAndDay()

	var/end_date_before_start_date = FALSE
	if(end_month < start_month)
		end_date_before_start_date = TRUE
	if(end_month == start_month && end_day < start_day)
		end_date_before_start_date = TRUE

	if(end_date_before_start_date)
		if(month_and_day[1] < end_month)
			return TRUE
		if(month_and_day[1] == end_month && month_and_day[2] <= end_day)
			return TRUE
		if(month_and_day[1] > start_month)
			return TRUE
		if(month_and_day[1] == start_month && month_and_day[2] >= start_day)
			return TRUE
		return FALSE

	if(month_and_day[1] < start_month)
		return FALSE
	if(month_and_day[1] == start_month && month_and_day[2] < start_day)
		return FALSE
	if(month_and_day[1] > end_month)
		return FALSE
	if(month_and_day[1] == end_month && month_and_day[2] > end_day)
		return FALSE
	return TRUE

/*********************
* Practical Subtypes *
*********************/
/obj/random/date_based/christmas
	// I have decided that Christmas lasts from Advent first until St. Knut's Day on January 13
	// However, because I'm lazy I've also decided that space future Advent first always occurs on December 1 rather than the 4th Sunday before Christmas
	date_check = new/datum/is_date/range(12, 1, 1, 13)

/**********************
* Date Based Spawners *
**********************/
/obj/random/date_based/christmas/tree
	name = "Christmas Tree"

/obj/random/date_based/christmas/tree/spawn_choices()
	var/static/list/spawnable_choices = list(/obj/structure/flora/tree/pine/xmas)
	return spawnable_choices
