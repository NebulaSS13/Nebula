// TODO: FSM/decl based stances
#define STANCE_NONE              /decl/mob_controller_stance/none
#define STANCE_IDLE              /decl/mob_controller_stance/idle
#define STANCE_ALERT             /decl/mob_controller_stance/alert
#define STANCE_ATTACK            /decl/mob_controller_stance/attack
#define STANCE_ATTACKING         /decl/mob_controller_stance/attacking
#define STANCE_TIRED             /decl/mob_controller_stance/tired
#define STANCE_CONTAINED         /decl/mob_controller_stance/contained
 //basically 'do nothing'
#define STANCE_COMMANDED_STOP    /decl/mob_controller_stance/commanded/stop
//follows a target
#define STANCE_COMMANDED_FOLLOW  /decl/mob_controller_stance/commanded/follow
//catch all state for misc commands that need one.
#define STANCE_COMMANDED_MISC    /decl/mob_controller_stance/commanded/misc
//we got healing powers yo
#define STANCE_COMMANDED_HEAL    /decl/mob_controller_stance/commanded/heal
#define STANCE_COMMANDED_HEALING /decl/mob_controller_stance/commanded/healing

#define AI_ACTIVITY_IDLE              0
#define AI_ACTIVITY_MOVING_TO_TARGET  1
#define AI_ACTIVITY_BUILDING          2
#define AI_ACTIVITY_REPRODUCING       3
