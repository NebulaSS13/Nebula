// Quick and deliberate movements are not necessarily mutually exclusive
#define MOVE_INTENT_NONE       0
#define MOVE_INTENT_DELIBERATE BITFLAG(0)
#define MOVE_INTENT_EXERTIVE   BITFLAG(1)
#define MOVE_INTENT_QUICK      BITFLAG(2)
#define MOVE_INTENT_NEUTRAL    BITFLAG(3)

/decl/move_intent
	var/name
	var/flags = MOVE_INTENT_NONE
	var/move_delay = 1
	var/hud_icon_state

/decl/move_intent/proc/can_be_used_by(var/mob/user)
	if(flags & MOVE_INTENT_QUICK)
		return user.can_sprint()
	return TRUE

/decl/move_intent/creep
	name = "Creep"
	flags = MOVE_INTENT_DELIBERATE
	hud_icon_state = "creeping"

/decl/move_intent/creep/Initialize()
	. = ..()
	move_delay = get_config_value(/decl/config/num/movement_creep)

/decl/move_intent/walk
	name = "Walk"
	hud_icon_state = "walking"
	flags = MOVE_INTENT_NEUTRAL

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = get_config_value(/decl/config/num/movement_walk)

/decl/move_intent/run
	name = "Run"
	flags = MOVE_INTENT_EXERTIVE | MOVE_INTENT_QUICK
	hud_icon_state = "running"

/decl/move_intent/run/Initialize()
	. = ..()
	move_delay = get_config_value(/decl/config/num/movement_run)
