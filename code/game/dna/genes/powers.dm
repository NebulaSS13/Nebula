///////////////////////////////////
// POWERS
///////////////////////////////////

/datum/dna/gene/basic/nobreath
	name="No Breathing"
	activation_messages=list("You feel no need to breathe.")
	mutation=mNobreath

/datum/dna/gene/basic/nobreath/New()
	..()
	block=global.NOBREATHBLOCK

/datum/dna/gene/basic/remoteview
	name="Remote Viewing"
	activation_messages=list("Your mind expands.")
	mutation=mRemote

/datum/dna/gene/basic/remoteview/New()
	..()
	block=global.REMOTEVIEWBLOCK

/datum/dna/gene/basic/remoteview/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remoteobserve

/datum/dna/gene/basic/regenerate
	name="Regenerate"
	activation_messages=list("You feel better.")
	mutation=mRegen

/datum/dna/gene/basic/regenerate/New()
	..()
	block=global.REGENERATEBLOCK

/datum/dna/gene/basic/regenerate
	name="Super Speed"
	activation_messages=list("Your leg muscles pulsate.")
	mutation=mRun

/datum/dna/gene/basic/nobreath/New()
	..()
	block=global.INCREASERUNBLOCK

/datum/dna/gene/basic/remotetalk
	name="Telepathy"
	activation_messages=list("You expand your mind outwards.")
	mutation=mRemotetalk

/datum/dna/gene/basic/remotetalk/New()
	..()
	block=global.REMOTETALKBLOCK

/datum/dna/gene/basic/remotetalk/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remotesay

/datum/dna/gene/basic/morph
	name="Morph"
	activation_messages=list("Your skin feels strange.")
	mutation=mMorph

/datum/dna/gene/basic/morph/New()
	..()
	block=global.MORPHBLOCK

/datum/dna/gene/basic/morph/activate(var/mob/M)
	..(M)
	M.verbs += /mob/living/carbon/human/proc/morph

/datum/dna/gene/basic/cold_resist
	name="Cold Resistance"
	activation_messages=list("Your body is filled with warmth.")
	mutation=MUTATION_COLD_RESISTANCE

/datum/dna/gene/basic/cold_resist/New()
	..()
	block=global.FIREBLOCK

/datum/dna/gene/basic/cold_resist/can_activate(var/mob/M,var/flags)
	if(flags & MUTCHK_FORCED)
		return 1
	// Probability check
	var/_prob=30
	//if(mHeatres in M.mutations)
	//	_prob=5
	if(probinj(_prob,(flags&MUTCHK_FORCED)))
		return 1

/datum/dna/gene/basic/cold_resist/OnDrawUnderlays(var/mob/M,var/g)
	return "fire_s"

/datum/dna/gene/basic/noprints
	name="No Prints"
	activation_messages=list("Your fingers feel numb.")
	mutation=mFingerprints

/datum/dna/gene/basic/noprints/New()
	..()
	block=global.NOPRINTSBLOCK

/datum/dna/gene/basic/noshock
	name="Shock Immunity"
	activation_messages=list("Your skin feels strange.")
	mutation=mShock

/datum/dna/gene/basic/noshock/New()
	..()
	block=global.SHOCKIMMUNITYBLOCK

/datum/dna/gene/basic/xray
	name="X-Ray Vision"
	activation_messages=list("The walls suddenly disappear.")
	mutation=MUTATION_XRAY

/datum/dna/gene/basic/xray/New()
	..()
	block=global.XRAYBLOCK
