#define IC_TOPIC_UNHANDLED 0
#define IC_TOPIC_HANDLED 1
#define IC_TOPIC_REFRESH 2
#define IC_FLAG_CAN_FIRE 1

#define IC_INPUT 		"I"
#define IC_OUTPUT		"O"
#define IC_ACTIVATOR	"A"

// Pin functionality.
#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

// Methods of obtaining a circuit.
#define IC_SPAWN_DEFAULT			1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 			2 // If the circuit design will be available in the IC printer after upgrading it.

// Categories that help differentiate circuits that can do different tipes of actions
#define IC_ACTION_MOVEMENT   BITFLAG(0) // If the circuit can move the assembly
#define IC_ACTION_COMBAT     BITFLAG(1) // If the circuit can cause harm
#define IC_ACTION_LONG_RANGE BITFLAG(2) // If the circuit communicate with something outside of the assembly

// extra format type just for ICs
#define IC_FORMAT_PULSE			"\<PULSE\>"

// Used inside input/output list to tell the constructor what pin to make.
#define IC_PINTYPE_ANY				/datum/integrated_io
#define IC_PINTYPE_STRING			/datum/integrated_io/string
#define IC_PINTYPE_CHAR				/datum/integrated_io/char
#define IC_PINTYPE_COLOR			/datum/integrated_io/color
#define IC_PINTYPE_NUMBER			/datum/integrated_io/number
#define IC_PINTYPE_DIR				/datum/integrated_io/dir
#define IC_PINTYPE_BOOLEAN			/datum/integrated_io/boolean
#define IC_PINTYPE_REF				/datum/integrated_io/ref
#define IC_PINTYPE_LIST				/datum/integrated_io/lists
#define IC_PINTYPE_INDEX			/datum/integrated_io/index

#define IC_PINTYPE_PULSE_IN			/datum/integrated_io/activate
#define IC_PINTYPE_PULSE_OUT		/datum/integrated_io/activate/out

// Data limits.
#define IC_MAX_LIST_LENGTH			500

/decl/modpack/integrated_electronics
	name = "Custom Circuits Content"
