SUBSYSTEM_DEF(approvals)
	name       = "Approvals"
	flags      = SS_NO_FIRE
	init_order = SS_INIT_EARLY

	var/const/approvals_path   = "data/approvals.json" // This should definitely use a DB rather than json but heigh no
	var/list/pending_approvals = list()
	var/list/all_approvals     = list()
	var/alist/guid_to_approval = alist()

/datum/controller/subsystem/approvals/stat_entry()
	..("P:[pending_approvals.len] A:[all_approvals.len]")

/datum/controller/subsystem/approvals/Initialize(start_timeofday)
	..()
	if(!fexists(approvals_path))
		return

	// Notes for future consideration
	// - load approved + pending on first run, apply approvals to update whitelist or such
	// - only keep pending approvals, discard everything else? or load everything so people can check their approvals?

	// Should also consider integrating this more tightly with instantiate_serialized_data() but given datum handling
	// this should be fine. It's not like approvals will be associated with DM refs or turfs or such I would assume.

	try
		var/max_guid = 0
		for(var/list/approval_data in json_decode(file2text(approvals_path)))
			var/create_type = approval_data[/datum::type]
			var/datum/approval/approval = new create_type(approval_data)
			all_approvals += approval
			guid_to_approval[approval.guid] = approval
			max_guid = max(max_guid, approval.guid)
			if(approval.status <= /datum/approval::APPROVAL_SUBMITTED)
				pending_approvals += approval
		set_guid(type, max_guid)
		for(var/i = 1 to max_guid)
			if(!guid_to_approval[i])
				free_guid(type, i)

	catch(var/exception/E)
		error("Exception when loading approvals file: [EXCEPTION_TEXT(E)]")

/datum/controller/subsystem/approvals/proc/store_approval(mob/_submitter, datum/approval/_approval)
	_approval.submitter = _submitter.client?.ckey || "system"
	_approval.guid = get_guid(type)
	all_approvals += _approval
	guid_to_approval[_approval.guid] = _approval.guid
	if(_approval.status <= /datum/approval::APPROVAL_SUBMITTED)
		pending_approvals |= _approval
	_approval.on_creation(_submitter)

/datum/controller/subsystem/approvals/proc/save_approvals()

	// Take a timestamped backup just in case.
	if(fexists(approvals_path))
		var/backup_path = "[approvals_path].[BACKUP_TIMESTAMP]"
		if(!fcopy(approvals_path, backup_path))
			log_error("Failed to back up approvals file [approvals_path]")
			return

	var/list/all_approval_data = list()
	for(var/datum/approval/approval as anything in all_approvals)
		all_approval_data += list(approval.Serialize())

	try
		var/write_data = json_encode(all_approval_data)
		var/write_file = file(approvals_path)
		to_file(write_file, write_data)

	catch(var/exception/E)
		log_error("Exception when saving approvals file: [EXCEPTION_TEXT(E)]")
		return

/datum/approval
	var/guid
	var/name
	var/submitter
	var/approver
	var/body
	var/status = APPROVAL_CREATED

	var/const/APPROVAL_CREATED   = 0
	var/const/APPROVAL_SUBMITTED = 1
	var/const/APPROVAL_APPROVED  = 2
	var/const/APPROVAL_DENIED    = 2

/datum/approval/proc/on_creation(mob/_submitter)
	return

/datum/approval/New(list/_data)
	if(islist(_data))
		guid      = _data[nameof(/datum/approval::guid)]
		name      = _data[nameof(/datum/approval::name)]
		body      = _data[nameof(/datum/approval::body)]
		submitter = _data[nameof(/datum/approval::submitter)]
		approver  = _data[nameof(/datum/approval::approver)]
		status    = _data[nameof(/datum/approval::status)]
	. = ..()

/datum/approval/Serialize()
	. = ..()
	.[nameof(/datum/approval::guid)]      = guid
	.[nameof(/datum/approval::name)]      = name
	.[nameof(/datum/approval::body)]      = body
	.[nameof(/datum/approval::submitter)] = submitter
	.[nameof(/datum/approval::approver)]  = approver
	.[nameof(/datum/approval::status)]    = status

/datum/approval/proc/on_approver_response(_approver, _approved = TRUE, _reason = "Unsupplied.")
	approver = _approver
	status = _approved ? APPROVAL_APPROVED : APPROVAL_DENIED
	if(submitter)
		for(var/client/client)
			if(client.ckey == submitter)
				to_chat(client, "Your submission #[guid] has been [status == APPROVAL_APPROVED ? "approved" : "denied"] by [approver] for reason: [_reason].")

// Do we need to serialize icons for these separately to uploaded icons, or should we
// immediately record it in the uploaded icon repo even if denied and delete it later?
// Approvals need to persist across restarts...
/datum/approval/player_icon
	var/icon_guid
	var/icon/icon

/datum/approval/player_icon/on_creation(mob/_submitter)
	. = ..()
	icon_guid = SSuploaded_icons.store_icon(_submitter?.ckey || "system", body, 0, icon)

/datum/approval/player_icon/Serialize()
	. = ..()
	.[nameof(/datum/approval/player_icon::icon_guid)] = icon_guid

/datum/approval/player_icon/on_approver_response(_approver, _approved = TRUE, _reason = "Unsupplied.")
	. = ..()
	if(status == APPROVAL_DENIED && icon_guid)
		SSuploaded_icons.remove_icon(icon_guid)
		icon = null
		icon_guid = null
