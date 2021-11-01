var/global/list/unlocked_codex_scannables = list()

/datum/extension/scannable
	expected_type = /atom
	var/associated_entry_type
	var/scan_delay = 5 SECONDS

/datum/extension/scannable/New(var/datum/holder, var/entry_type, var/_scan_delay)
	..()
	associated_entry_type = entry_type
	if(!ispath(associated_entry_type, /datum/codex_entry/scannable))
		PRINT_STACK_TRACE("Invalid entry type supplied to scannable extension: [associated_entry_type || "NULL"]")
	if(isnum(_scan_delay))
		scan_delay = _scan_delay

/datum/codex_entry/scannable
	var/worth_points = 1
	var/category

/datum/extension/scannable/proc/is_scannable()
	return ispath(associated_entry_type, /datum/codex_entry/scannable) && !global.unlocked_codex_scannables[associated_entry_type]

/datum/extension/scannable/proc/scanned()

	if(!is_scannable())
		return FALSE

	var/datum/codex_entry/scannable/entry = new associated_entry_type
	SScodex.add_entry_by_string(entry.name, entry)
	global.unlocked_codex_scannables[associated_entry_type] = entry

	if(entry.category)
		var/decl/codex_category/cat = GET_DECL(entry.category)
		cat.items |= entry.name

	return entry
