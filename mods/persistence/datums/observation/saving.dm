//	Observer Pattern Implementation: World Saving
//		Registration type: /datum
//
//		Raised when: Persistence is starting the saving process for the world.
//
//		Arguments that the called proc should expect:
//		None

GLOBAL_DATUM_INIT(world_saving_event, /decl/observ/world_saving, new)

/decl/observ/world_saving
	name = "World Saving"
	expected_type = /datum