// Flags for damage types
/// Generic physical damage sources - Punches, general attacks, bullets, etc
var/global/const/DAMAGE_BRUTE     = "brute"
/// Generic burn damage sources - Lasers, focused heat sources (Not fire, see DAMAGE_FIRE), etc
var/global/const/DAMAGE_BURN      = "burn"
/// Non-harming energy effects - Stun mode weapons, tasers, practice lasers, etc
var/global/const/DAMAGE_STUN      = "stun"
/// Electrical damage, shock rounds, less-than-lethal lasers, etc
var/global/const/DAMAGE_SHOCK     = "shock"
/// Strictly EMP damage, primarily used in emp_act()
var/global/const/DAMAGE_EMP       = "emp"
/// Strictly explosion damage, primarily used in explode_act()
var/global/const/DAMAGE_EXPLODE   = "explode"
/// Strictly fire damage, primarily used in fire_act()
var/global/const/DAMAGE_FIRE      = "fire"
/// Radiation damage
var/global/const/DAMAGE_RADIATION = "radiation"
/// Bio-damage. Infections, viruses, etc.
var/global/const/DAMAGE_BIO       = "bio"
/// Pain damage. Used for compatabiltiy with legacy code, not intended for actual health tracking use.
var/global/const/DAMAGE_PAIN      = "pain"
/// Toxin and poison damage.
var/global/const/DAMAGE_TOXIN     = "toxin"
/// Genetic damage
var/global/const/DAMAGE_GENETIC   = "genetic"
/// Oxyloss damage
var/global/const/DAMAGE_OXY       = "oxy"
/// Brain damage
var/global/const/DAMAGE_BRAIN     = "brain"

/// Common, basic damage types
#define DAMAGE_STANDARD   list(DAMAGE_BRUTE, DAMAGE_BURN)
/// Damage types that should specifically affect electrical systems
#define DAMAGE_ELECTRICAL list(DAMAGE_SHOCK, DAMAGE_EMP)
/// All damage flags
#define DAMAGE_ALL        list(DAMAGE_BRUTE, DAMAGE_BURN, DAMAGE_STUN, DAMAGE_SHOCK, DAMAGE_EMP, DAMAGE_EXPLODE, DAMAGE_FIRE, DAMAGE_RADIATION, DAMAGE_BIO, DAMAGE_PAIN, DAMAGE_TOXIN, DAMAGE_GENETIC, DAMAGE_OXY, DAMAGE_BRAIN)


// Flags for use health types
/// Uses simple health vars, no extension
var/global/const/USE_HEALTH_SIMPLE = "simple"
/// Uses the standard health extension
var/global/const/USE_HEALTH_EXTENSION = /datum/extension/health
/// Uses the damage sources health extension
var/global/const/USE_HEALTH_DAMAGE_SOURCES = /datum/extension/health/damage_sources
