#define DEITY_STRUCTURE_NEAR_IMPORTANT 	1 //Whether this needs to be near an important structure.
#define DEITY_STRUCTURE_ALONE			2 //Whether this can be near another of the same type.

#define MODE_DEITY         "deity"

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		0x1		//can a ghost cast it?
#define NEEDSCLOTHES	0x2		//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		0x4		//does it require the caster to be human?
#define Z2NOCAST		0x8		//if this is added, the spell can't be cast at centcomm
#define NO_SOMATIC		0x10	//spell will go off if the person is incapacitated or stunned
#define IGNOREPREV		0x20	//if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		0x40	//does the spell include the caster in its target selection?
#define SELECTABLE		0x80	//can you select each target for the spell?
#define NOFACTION		0x1000  //Don't do the same as our faction
#define NONONFACTION	0x2000  //Don't do people other than our faction
//AOE spells
#define IGNOREDENSE		0x40	//are dense turfs ignored in selection?
#define IGNORESPACE		0x80	//are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	0x100	//used by construct spells - checks for nullrods
#define NO_BUTTON		0x200	//spell won't show up in the HUD with this

/decl/content_package/antagonists_supernatural

/decl/content_package/antagonists_supernatural/get_spookiness()
	. = length(GLOB.cult?.current_antagonists)
