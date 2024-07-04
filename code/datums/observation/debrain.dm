/**
 * Observer Pattern Implementation: Debrained
 *
 * Raised when: A brainmob is created by the removal of a brain.
 *
 * Arguments that the called proc should expect:
 *     /mob/living/brainmob: The brainmob that was created.
 *     /obj/item/organ/internal/brain: The brain that was removed.
 *     /mob/living/owner: The mob the brain was formerly installed in.
 */
/decl/observ/debrain
	name = "Debrained"
	expected_type = /mob/living