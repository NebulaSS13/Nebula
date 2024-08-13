/*
This is pretty much just an optimization for wait=0 timers. They're relatively common, but generally don't actually need the more
 complex features of SStimer. SSdpc can handle these timers instead (and it's a lot simpler than SStimer is), but it can't handle
 complex timers with flags. This doesn't need to be explicitly used, eligible timers are automatically converted.
*/

SUBSYSTEM_DEF(dpc)
	name = "Delayed Procedure Call"
	wait = 1
	runlevels = RUNLEVELS_ALL
	priority = SS_PRIORITY_DPC
	flags = SS_TICKER | SS_NO_INIT

	var/list/queued_calls = list()
	var/avg = 0
	var/list/unique_queued_calls = list()
	var/unique_avg = 0

/datum/controller/subsystem/dpc/stat_entry()
	return ..() + " Q: [queued_calls.len], AQ: ~[round(avg)], UQ: [unique_queued_calls.len], AQ: ~[round(unique_avg)]"

/datum/controller/subsystem/dpc/fire(resumed = FALSE)
	var/list/qc = queued_calls
	var/list/uqc = unique_queued_calls
	if (!resumed)
		avg = MC_AVERAGE_FAST(avg, qc.len)
		unique_avg = MC_AVERAGE_FAST(unique_avg, uqc.len)

	var/q_idex = 1

	while (q_idex <= qc.len)
		var/datum/callback/CB = qc[q_idex]
		q_idex += 1

		CB.InvokeAsync()

		if (MC_TICK_CHECK)
			break

	if (q_idex > 1)
		queued_calls.Cut(1, q_idex)

	q_idex = 1 // Reuse this variable so we don't waste time allocating two
	while (q_idex <= uqc.len)
		var/hash = uqc[q_idex]
		var/datum/callback/CB = uqc[hash]
		q_idex += 1

		CB.InvokeAsync()

		if (MC_TICK_CHECK)
			break

	if (q_idex > 1)
		unique_queued_calls.Cut(1, q_idex)
