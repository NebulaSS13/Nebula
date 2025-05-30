#define SS_PRIORITY_TRADE 10  // Creates trade hubs on init, and adds/removes merchants every minute.

#define MERCHANT_INCLUDE_THIS_TYPE		BITFLAG(0)
#define MERCHANT_INCLUDE_SUBTYPES		BITFLAG(1)
#define MERCHANT_INCLUDE_ALL			(MERCHANT_INCLUDE_THIS_TYPE|MERCHANT_INCLUDE_SUBTYPES)
#define MERCHANT_EXCLUDE_THIS_TYPE		BITFLAG(2)
#define MERCHANT_EXCLUDE_SUBTYPES		BITFLAG(3)
#define MERCHANT_EXCLUDE_ALL			(MERCHANT_EXCLUDE_THIS_TYPE|MERCHANT_EXCLUDE_SUBTYPES)


/decl/modpack/merchants
	name = "Merchants"
	desc = "Adds a system for off-map merchants who can be traded with."
	nanoui_directory = "mods/content/merchants/nano_templates/"

/decl/modpack/merchants/pre_initialize()
	. = ..()
	global.debug_verbs |= list(
		/datum/admins/proc/list_merchants,
		/datum/admins/proc/add_singleton_trade_hub,
		/datum/admins/proc/add_overmap_trade_hub,
		/datum/admins/proc/remove_trade_hub,
		/datum/admins/proc/add_merchant,
		/datum/admins/proc/remove_merchant
		)