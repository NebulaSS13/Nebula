SUBSYSTEM_DEF(automove)
	name = "Automated Movement"
	wait = 1
	flags = SS_NO_INIT
	priority = SS_PRIORITY_AUTO_MOVE

	var/list/moving_atoms    = list()
	var/list/moving_metadata = list()
	var/list/processing_atoms

/datum/controller/subsystem/automove/proc/unregister_mover(atom/movable/mover)
	if(!istype(mover))
		CRASH("Invalid parameters to unregister_mover: [mover || "NULL"]")
	if(length(moving_atoms))
		moving_atoms     -= mover
	if(length(moving_metadata))
		moving_metadata  -= mover
	if(length(processing_atoms))
		processing_atoms -= mover

/datum/controller/subsystem/automove/proc/register_mover(atom/movable/mover, controller_type, datum/automove_metadata/metadata)
	if(!istype(mover) || (!ispath(controller_type, /decl/automove_controller) && !istype(controller_type, /decl/automove_controller)))
		CRASH("Invalid parameters to register_mover: [controller_type || "NULL"], [mover || "NULL"]")

	var/decl/automove_controller/controller = ispath(controller_type) ? GET_DECL(controller_type) : controller_type
	moving_atoms[mover] = controller
	if(istype(metadata))
		moving_metadata[mover] = metadata
	else
		moving_metadata -= mover

	if(suspended)
		wake()

/datum/controller/subsystem/automove/fire(resumed = FALSE)

	if(!resumed)
		processing_atoms = moving_atoms.Copy()

	if(!length(processing_atoms))
		suspend()
		return

	var/i = 0
	var/atom/movable/mover
	var/decl/automove_controller/controller
	while(i < processing_atoms.len)
		i++
		mover = processing_atoms[i]
		controller = processing_atoms[mover]
		if(controller.handle_mover(mover, moving_metadata[mover]) == PROCESS_KILL && !QDELETED(mover))
			mover.stop_automove()
		if(MC_TICK_CHECK)
			processing_atoms.Cut(1, i+1)
			return
