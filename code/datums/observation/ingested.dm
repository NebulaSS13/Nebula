//	Observer Pattern Implementation: Ingested
//		Registration type: /mob/living
//
//		Raised when: A living mob ingests reagents.
//
//		Arguments that the called proc should expect:
//			/mob/living/ingester:   The mob that has ingested something
//			/datum/reagents/source: The reagent holder being ingested from.
//			/datum/reagents/target: The reagent holder the ingested reagents move into.
//			amount:                 The number of reagents ingested from the reagent source.
//			multiplier:             The multiplier determining the ratio of reagents removed from the source to reagents added to the target.
//			copy:                   If true, reagents are copied from the source rather than transferred.

/decl/observ/ingested
	name = "Ingested"
	expected_type = /mob/living