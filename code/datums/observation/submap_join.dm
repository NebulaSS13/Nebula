//	Observer Pattern Implementation: Submap Join
//		Registration type: /datum/submap
//
//		Raised when: A mob joins on a submap
//
//		Arguments that the called proc should expect:
//			/datum/submap/submap: The submap the mob joined.
//			/mob/joiner: The mob that joined the submap.
//			/datum/job/job: The job the mob joined as.

/decl/observ/submap_join
	name = "Submap Joined"
	expected_type = /datum/submap