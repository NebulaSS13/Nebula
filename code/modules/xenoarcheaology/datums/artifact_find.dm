/datum/artifact_find
	var/artifact_id
	var/artifact_find_type
	var/static/potential_finds = list(
		/obj/machinery/power/supermatter = 5,
		/obj/machinery/power/supermatter/shard = 25,
		/obj/machinery/auto_cloner = 100,
		/obj/machinery/giga_drill = 100,
		/obj/machinery/replicator = 100,
		/obj/structure/crystal = 150,
		/obj/structure/artifact = 1000
	)

/datum/artifact_find/New()
	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[random_id(/datum/artifact_find, 100, 999)]"
	artifact_find_type = pickweight(potential_finds)
