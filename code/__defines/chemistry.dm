#define DEFAULT_HUNGER_FACTOR 0.03 // Factor of how fast mob nutrition decreases
#define DEFAULT_THIRST_FACTOR 0.03 // Factor of how fast mob hydration decreases

#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_INJECT 3
#define CHEM_INHALE 4

#define MINIMUM_CHEMICAL_VOLUME 0.01

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

/// Stabilizing brain, pulse and breathing
#define CE_STABLE        "stable"
/// Spaceacilin
#define CE_ANTIBIOTIC    "antibiotic"
/// Iron/nutriment
#define CE_BLOODRESTORE  "bloodrestore"
/// Reduces the impact of shock/pain
#define CE_PAINKILLER    "painkiller"
/// Liver filtering
#define CE_ALCOHOL       "alcohol"
/// Liver damage
#define CE_ALCOHOL_TOXIC "alcotoxic"
/// Stimulants
#define CE_SPEEDBOOST    "gofast"
/// Slowdown
#define CE_SLOWDOWN      "goslow"
/// increases or decreases heart rate
#define CE_PULSE         "xcardic"
/// stops heartbeat
#define CE_NOPULSE       "heartstop"
/// Removes toxins
#define CE_ANTITOX       "antitox"
/// Helps oxygenate the brain.
#define CE_OXYGENATED    "oxygen"
/// Allows the brain to recover after injury
#define CE_BRAIN_REGEN   "brainfix"
/// Generic toxins, stops autoheal.
#define CE_TOXIN         "toxins"
/// Breathing depression, makes you need more air
#define CE_BREATHLOSS    "breathloss"
/// Stabilizes or wrecks mind. Used for hallucinations
#define CE_MIND    		 "mindbending"
/// Prevents damage from being frozen
#define CE_CRYO 	     "cryogenic"
/// Gets in the way of blood circulation, higher the worse
#define CE_BLOCKAGE	     "blockage"
/// Helium voice. Squeak squeak.
#define CE_SQUEAKY		 "squeaky"
/// Gives xray vision.
#define CE_THIRDEYE      "thirdeye"
/// Applies sedation effects, i.e. paralysis, inability to use items, etc.
#define CE_SEDATE        "sedate"
/// Speeds up stamina recovery.
#define CE_ENERGETIC     "energetic"
/// Lowers the subject's voice to a whisper
#define	CE_VOICELOSS     "whispers"
/// Causes eyes to glow.
#define CE_GLOWINGEYES   "eyeglow"
/// Causes brute damage to regenerate.
#define CE_REGEN_BRUTE   "bruteheal"
/// Causes burn damage to regenerate.
#define CE_REGEN_BURN    "burnheal"
/// Anaphylaxis etc.
#define CE_ALLERGEN      "allergyreaction"

#define GET_CHEMICAL_EFFECT(X, C) (LAZYACCESS(X.chem_effects, C) || 0)

//reagent flags
#define IGNORE_MOB_SIZE BITFLAG(0)
#define AFFECTS_DEAD    BITFLAG(1)

#define HANDLE_REACTIONS(_reagents)  if(!QDELETED(_reagents)) { SSmaterials.active_holders[_reagents] = TRUE; }
#define UNQUEUE_REACTIONS(_reagents) SSmaterials.active_holders -= _reagents

#define REAGENT_LIST(R) ((istype(R, /datum/reagents) && R:get_reagents()) || "No reagent holder")

#define REAGENT_TOTAL_VOLUME(R) (UNLINT((istype(R, /datum/reagents) && R:total_volume) || 0))
#define REAGENT_TOTAL_LIQUID_VOLUME(R) (UNLINT((istype(R, /datum/reagents) && R:total_liquid_volume) || 0))

#define REAGENT_MAXIMUM_VOLUME(R) (UNLINT((istype(R, /datum/reagents) && R:maximum_volume) || 0))
#define REAGENTS_FREE_SPACE(R) (UNLINT(istype(R, /datum/reagents) ? (R.maximum_volume - R.total_volume) : 0))

#define REAGENT_VOLUMES(R)        ( (istype(R, /datum/reagents) && UNLINT(R:reagent_volumes)) || null )
#define REAGENT_SOLID_VOLUMES(R)  ( (istype(R, /datum/reagents) && UNLINT(R:solid_volumes))   || null )
#define REAGENT_LIQUID_VOLUMES(R) ( (istype(R, /datum/reagents) && UNLINT(R:liquid_volumes))  || null )
#define REAGENT_GET_MAX_VOL(R)    ( (istype(R, /datum/reagents) && UNLINT(R:maximum_volume))  || 0 )
#define REAGENT_GET_ATOM(R)       ( (istype(R, /datum/reagents) && UNLINT(R:my_atom))         || null )

#define REAGENT_VOLUME(R, M)      ( istype(R, /datum/reagents) && UNLINT(R:reagent_volumes && R:reagent_volumes[RESOLVE_TO_DECL(M)]) )
#define LIQUID_VOLUME(R, M)       ( istype(R, /datum/reagents) && UNLINT(R:liquid_volumes  && R:liquid_volumes[RESOLVE_TO_DECL(M)]) )
#define SOLID_VOLUME(R, M)        ( istype(R, /datum/reagents) && UNLINT(R:solid_volumes   && R:solid_volumes[RESOLVE_TO_DECL(M)]) )
#define REAGENT_DATA(R, M)        ( istype(R, /datum/reagents) && UNLINT(R:reagent_data    && R:reagent_data[RESOLVE_TO_DECL(M)]) )

#define REAGENT_SET_MAX_VOL(R, V) if(istype(R, /datum/reagents)) { UNLINT(R:maximum_volume = V) }
#define REAGENT_ADD_MAX_VOL(R, V) if(istype(R, /datum/reagents)) { UNLINT(R:maximum_volume += V) }
#define REAGENT_SET_ATOM(R, A)    if(istype(R, /datum/reagents)) { UNLINT(R:my_atom = A) }
#define REAGENT_SET_DATA(R, M, D) if(istype(R, /datum/reagents)) { LAZYSET(UNLINT(R:reagent_data), M, D) }


#define CHEM_DOSE(M, R) LAZYACCESS(M._chem_doses, RESOLVE_TO_DECL(R))

#define MAT_SOLVENT_NONE        0
#define MAT_SOLVENT_MILD        1
#define MAT_SOLVENT_MODERATE    2
#define MAT_SOLVENT_STRONG      3
#define MAT_SOLVENT_VERY_STRONG 7
#define MAT_SOLVENT_STRONGEST   10
#define MAT_SOLVENT_IMMUNE   INFINITY

#define DIRTINESS_DECONTAMINATE -3
#define DIRTINESS_STERILE       -2
#define DIRTINESS_CLEAN         -1
#define DIRTINESS_NEUTRAL        0

#define DEFAULT_GAS_ACCELERANT /decl/material/gas/hydrogen
#define DEFAULT_GAS_OXIDIZER   /decl/material/gas/oxygen

#define CHEM_REACTION_FLAG_OVERFLOW_CONTAINER BITFLAG(0)

#define MAX_SCRAP_MATTER (SHEET_MATERIAL_AMOUNT * 5) // Maximum amount of matter in chemical scraps