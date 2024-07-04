//	Observer Pattern Implementation: Player Latejoin
//		Registration type: /mob/living
//
//		Raised when: A player joins the round after it has started.
//
//		Arguments that the called proc should expect:
//			/mob/living/character: The mob that joined the round.
//			/datum/job/job: The job the mob joined as.

/decl/observ/player_latejoin
	name = "Player Latejoin"
