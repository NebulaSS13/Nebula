/****************************
* Category Collection Setup *
****************************/
// TODO: replace underwear category stuff with decls or something? unlike player_setup_collection they're all singletons
// i hate to say it but the way this works may actually be perfect for /decl/hierarchy
var/global/datum/category_collection/underwear/underwear = new()
/datum/category_collection/underwear
	category_group_type = /datum/category_group/underwear

/*************
* Categories *
*************/
// Lower sort order is applied as icons first
/datum/category_group/underwear
	abstract_type = /datum/category_group/underwear

/datum/category_group/underwear/top
	name = "Underwear, top"
	sort_order = 1
	category_item_type = /datum/category_item/underwear/top

/datum/category_group/underwear/bottom
	name = "Underwear, bottom"
	sort_order = 2
	category_item_type = /datum/category_item/underwear/bottom

/datum/category_group/underwear/socks
	name = "Socks"
	sort_order = 3
	category_item_type = /datum/category_item/underwear/socks

/datum/category_group/underwear/undershirt
	name = "Undershirt"
	sort_order = 4 // Undershirts currently have the highest sort order because they may cover both underwear and socks.
	category_item_type = /datum/category_item/underwear/undershirt

/*******************
* Category entries *
*******************/
/datum/category_item/underwear
	var/always_last = FALSE          // Should this entry be sorte last?
	var/is_default = FALSE           // Should this entry be considered the default for its type?
	var/icon = 'icons/mob/human.dmi' // Which icon to get the underwear from.
	var/icon_state                   // And the particular item state.
	var/list/tweaks = list()         // Underwear customizations.
	var/has_color = FALSE

	var/underwear_name               // The name of the resulting underwear
	var/underwear_gender = NEUTER    // Singular or plural form?
	var/underwear_type               // The kind of underwear item this datum will create.

/datum/category_item/underwear/New()
	if(has_color)
		tweaks += gear_tweak_free_color_choice()

/datum/category_item/underwear/dd_SortValue()
	if(always_last)
		return "~"+name
	return name

/datum/category_item/underwear/proc/is_default(var/gender)
	return is_default

/datum/category_item/underwear/proc/create_underwear(var/mob/user, var/list/metadata)
	if(!underwear_type)
		return

	var/obj/item/underwear/UW = new underwear_type()
	UW.SetName(underwear_name)
	UW.set_gender(underwear_gender)
	UW.icon = icon
	UW.icon_state = icon_state

	for(var/datum/gear_tweak/gt in tweaks)
		gt.tweak_item(user, UW, ((metadata && metadata["[gt]"]) ? metadata["[gt]"] : gt.get_default()))
	return UW
