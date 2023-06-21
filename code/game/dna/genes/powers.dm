///////////////////////////////////
// POWERS
///////////////////////////////////

/decl/gene/basic/nobreath
	name="No Breathing"
	activation_messages="You feel no need to breathe."
	mutation=mNobreath

/decl/gene/basic/nobreath/Initialize()
	. = ..()
	block=global.NOBREATHBLOCK

/decl/gene/basic/remoteview
	name="Remote Viewing"
	activation_messages="Your mind expands."
	mutation=mRemote

/decl/gene/basic/remoteview/Initialize()
	. = ..()
	block=global.REMOTEVIEWBLOCK

/decl/gene/basic/remoteview/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remoteobserve

/decl/gene/basic/regenerate
	name="Regenerate"
	activation_messages="You feel better."
	mutation=mRegen

/decl/gene/basic/regenerate/Initialize()
	. = ..()
	block=global.REGENERATEBLOCK

/decl/gene/basic/regenerate
	name="Super Speed"
	activation_messages="Your leg muscles pulsate."
	mutation=mRun

/decl/gene/basic/regenerate/Initialize()
	. = ..()
	block=global.INCREASERUNBLOCK

/decl/gene/basic/remotetalk
	name="Telepathy"
	activation_messages="You expand your mind outwards."
	mutation=mRemotetalk

/decl/gene/basic/remotetalk/Initialize()
	. = ..()
	block=global.REMOTETALKBLOCK

/decl/gene/basic/remotetalk/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remotesay

/decl/gene/basic/morph
	name="Morph"
	activation_messages="Your skin feels strange."
	mutation=mMorph

/decl/gene/basic/noshock/Initialize()
	. = ..()
	block=global.MORPHBLOCK

/decl/gene/basic/morph/activate(var/mob/M)
	..(M)
	M.verbs += /mob/living/carbon/human/proc/morph

/decl/gene/basic/cold_resist
	name="Cold Resistance"
	activation_messages="Your body is filled with warmth."
	mutation=MUTATION_COLD_RESISTANCE

/decl/gene/basic/cold_resist/Initialize()
	. = ..()
	block=global.FIREBLOCK

/decl/gene/basic/cold_resist/can_activate(var/mob/M,var/flags)
	if(flags & MUTCHK_FORCED)
		return 1
	// Probability check
	var/_prob=30
	//if(mHeatres in M.mutations)
	//	_prob=5
	if(probinj(_prob,(flags&MUTCHK_FORCED)))
		return 1

/decl/gene/basic/cold_resist/OnDrawUnderlays(var/mob/M,var/g)
	return "fire_s"

/decl/gene/basic/noprints
	name="No Prints"
	activation_messages="Your fingers feel numb."
	mutation=mFingerprints

/decl/gene/basic/noprints/Initialize()
	. = ..()
	block=global.NOPRINTSBLOCK

/decl/gene/basic/noshock
	name="Shock Immunity"
	activation_messages="Your skin feels strange."
	mutation=mShock

/decl/gene/basic/noshock/Initialize()
	. = ..()
	block=global.SHOCKIMMUNITYBLOCK

/decl/gene/basic/xray
	name="X-Ray Vision"
	activation_messages="The walls suddenly disappear."
	mutation=MUTATION_XRAY

/decl/gene/basic/xray/Initialize()
	. = ..()
	block=global.XRAYBLOCK
