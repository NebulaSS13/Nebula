// TODO: FSM/decl based stances
#define STANCE_NONE                   0
#define STANCE_IDLE                   1
#define STANCE_ALERT                  2
#define STANCE_ATTACK                 3
#define STANCE_ATTACKING              4
#define STANCE_TIRED                  5
#define STANCE_INSIDE                 6
 //basically 'do nothing'
#define STANCE_COMMANDED_STOP         7
//follows a target
#define STANCE_COMMANDED_FOLLOW       8
//catch all state for misc commands that need one.
#define STANCE_COMMANDED_MISC         9
//we got healing powers yo
#define STANCE_COMMANDED_HEAL        10
#define STANCE_COMMANDED_HEALING     11

#define AI_ACTIVITY_IDLE              0
#define AI_ACTIVITY_MOVING_TO_TARGET  1
#define AI_ACTIVITY_BUILDING          2
#define AI_ACTIVITY_REPRODUCING       3