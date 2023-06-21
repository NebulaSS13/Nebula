/decl/gene
	/// Display name
	var/name="BASE GENE"
	///  What gene activates this?
	var/block = 0
	/// Any of a number of GENE_ flags.
	var/flags=0

/// Is the gene active in this mob's DNA?
/decl/gene/proc/is_active(var/mob/M)
	return (type in M.active_genes)

/decl/gene/proc/can_activate(var/mob/M, var/flags)
	return FALSE

/// Called when the gene activates.  Do your magic here.
/decl/gene/proc/activate(var/mob/M, var/connected, var/flags)
	return

// Called when the gene deactivates.  Undo your magic here.
/decl/gene/proc/deactivate(var/mob/M, var/connected, var/flags)
	return

// This section inspired by goone's bioEffects.

/**
* Called in each life() tick.
*/
/decl/gene/proc/OnMobLife(var/mob/M)
	return

/**
* Called when the mob dies
*/
/decl/gene/proc/OnMobDeath(var/mob/M)
	return

/**
* Called when the mob says shit
*/
/decl/gene/proc/OnSay(var/mob/M, var/message)
	return message

/**
* Called after the mob runs update_icons.
*
* @params M The subject.
* @params g Gender (m or f)
*/
/decl/gene/proc/OnDrawUnderlays(var/mob/M, var/g)
	return 0


/////////////////////
// BASIC GENES
//
// These just chuck in a mutation and display a message.
//
// Gene is activated:
//  1. If mutation already exists in mob
//  2. If the probability roll succeeds
//  3. Activation is forced (done in domutcheck)
/////////////////////


/decl/gene/basic
	name="BASIC GENE"
	/// Mutation to give
	var/mutation=0
	/// Activation probability
	var/activation_prob=45
	/// Possible activation messages
	var/activation_messages
	/// Possible deactivation messages
	var/deactivation_messages

/decl/gene/basic/can_activate(var/mob/M,var/flags)
	if(flags & MUTCHK_FORCED)
		return 1
	// Probability check
	return probinj(activation_prob,(flags&MUTCHK_FORCED))

/decl/gene/basic/activate(var/mob/M)
	M.mutations.Add(mutation)
	if(length(activation_messages))
		if(islist(activation_messages))
			to_chat(M, SPAN_NOTICE(pick(activation_messages)))
		else
			to_chat(M, SPAN_NOTICE(activation_messages))

/decl/gene/basic/deactivate(var/mob/M)
	M.mutations.Remove(mutation)
	if(length(deactivation_messages))
		if(islist(deactivation_messages))
			to_chat(M, SPAN_WARNING(pick(deactivation_messages)))
		else
			to_chat(M, SPAN_WARNING(deactivation_messages))
