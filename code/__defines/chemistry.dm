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

#define CE_STABLE        "stable"       // Stabilizing brain, pulse and breathing
#define CE_ANTIBIOTIC    "antibiotic"   // Spaceacilin
#define CE_BLOODRESTORE  "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER    "painkiller"   // Reduces the impact of shock/pain
#define CE_ALCOHOL       "alcohol"      // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic"    // Liver damage
#define CE_SPEEDBOOST    "gofast"       // Stimulants
#define CE_SLOWDOWN      "goslow"       // Slowdown
#define CE_PULSE         "xcardic"      // increases or decreases heart rate
#define CE_NOPULSE       "heartstop"    // stops heartbeat
#define CE_ANTITOX       "antitox"      // Removes toxins
#define CE_OXYGENATED    "oxygen"       // Helps oxygenate the brain.
#define CE_BRAIN_REGEN   "brainfix"     // Allows the brain to recover after injury
#define CE_TOXIN         "toxins"       // Generic toxins, stops autoheal.
#define CE_BREATHLOSS    "breathloss"   // Breathing depression, makes you need more air
#define CE_MIND    		 "mindbending"  // Stabilizes or wrecks mind. Used for hallucinations
#define CE_CRYO 	     "cryogenic"    // Prevents damage from being frozen
#define CE_BLOCKAGE	     "blockage"     // Gets in the way of blood circulation, higher the worse
#define CE_SQUEAKY		 "squeaky"      // Helium voice. Squeak squeak.
#define CE_THIRDEYE      "thirdeye"     // Gives xray vision.
#define CE_SEDATE        "sedate"       // Applies sedation effects, i.e. paralysis, inability to use items, etc.
#define CE_ENERGETIC     "energetic"    // Speeds up stamina recovery.
#define	CE_VOICELOSS     "whispers"     // Lowers the subject's voice to a whisper
#define CE_GLOWINGEYES   "eyeglow"      // Causes eyes to glow.

#define CE_REGEN_BRUTE   "bruteheal"    // Causes brute damage to regenerate.
#define CE_REGEN_BURN    "burnheal"     // Causes burn damage to regenerate.

#define GET_CHEMICAL_EFFECT(X, C) (LAZYACCESS(X.chem_effects, C) || 0)

//reagent flags
#define IGNORE_MOB_SIZE BITFLAG(0)
#define AFFECTS_DEAD    BITFLAG(1)

#define HANDLE_REACTIONS(_reagents)  if(!QDELETED(_reagents)) { SSmaterials.active_holders[_reagents] = TRUE; }
#define UNQUEUE_REACTIONS(_reagents) SSmaterials.active_holders -= _reagents

#define REAGENT_LIST(R) (R.reagents?.get_reagents() || "No reagent holder")

#define REAGENTS_FREE_SPACE(R) (R?.maximum_volume - R?.total_volume)
#define REAGENT_VOLUME(REAGENT_HOLDER, REAGENT_TYPE) (REAGENT_HOLDER?.reagent_volumes && REAGENT_HOLDER.reagent_volumes[REAGENT_TYPE])

#define LIQUID_VOLUME(REAGENT_HOLDER, REAGENT_TYPE) (REAGENT_HOLDER?.liquid_volumes && REAGENT_HOLDER.liquid_volumes[REAGENT_TYPE])
#define SOLID_VOLUME(REAGENT_HOLDER, REAGENT_TYPE) (REAGENT_HOLDER?.solid_volumes && REAGENT_HOLDER.solid_volumes[REAGENT_TYPE])

#define REAGENT_DATA(REAGENT_HOLDER, REAGENT_TYPE)   (REAGENT_HOLDER?.reagent_data    && REAGENT_HOLDER.reagent_data[REAGENT_TYPE])

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