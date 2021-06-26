/decl/special_role
	initial_spawn_req = 1
	initial_spawn_target = 1
	
/decl/special_role/mercenary
	initial_spawn_req = 1
	initial_spawn_target = 2
	
/decl/special_role/raider
	initial_spawn_req = 1
	initial_spawn_target = 2
	
/decl/special_role/cultist
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/cultist/Initialize()
	. = ..()
	LAZYDISTINCTADD(blacklisted_jobs, /datum/job/tradeship_robot)

/decl/special_role/renegade
	initial_spawn_req = 1
	initial_spawn_target = 2
	
/decl/special_role/loyalist
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/loyalist/Initialize()
	. = ..()
	LAZYDISTINCTADD(blacklisted_jobs, /datum/job/tradeship_robot)

/decl/special_role/revolutionary
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/revolutionary/Initialize()
	. = ..()
	LAZYDISTINCTADD(blacklisted_jobs, /datum/job/tradeship_robot)

/decl/special_role/changeling/Initialize()
	. = ..()
	LAZYDISTINCTADD(blacklisted_jobs, /datum/job/tradeship_robot)

/decl/special_role/godcultist/Initialize()
	. = ..()
	LAZYDISTINCTADD(blacklisted_jobs, /datum/job/tradeship_robot)



