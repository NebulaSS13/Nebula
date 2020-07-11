#define SHIP_SIZE_TINY	1
#define SHIP_SIZE_SMALL	2
#define SHIP_SIZE_LARGE	3

//multipliers for max_speed to find 'slow' and 'fast' speeds for the ship
#define SHIP_SPEED_SLOW  1/(40 SECONDS)
#define SHIP_SPEED_FAST  3/(20 SECONDS)// 15 speed

#define OVERMAP_WEAKNESS_NONE 0
#define OVERMAP_WEAKNESS_FIRE 1
#define OVERMAP_WEAKNESS_EMP 2
#define OVERMAP_WEAKNESS_MINING 4
#define OVERMAP_WEAKNESS_EXPLOSIVE 8

#define HasBelow(Z) (((Z) > world.maxz || (Z) < 2 || ((Z)-1) > z_levels.len) ? 0 : z_levels[(Z)-1])
#define HasAbove(Z) (((Z) >= world.maxz || (Z) < 1 || (Z) > z_levels.len) ? 0 : z_levels[(Z)])

#define KM_OVERMAP_RATE		100
#define SHIP_MOVE_RESOLUTION 0.00001
#define MOVING(speed, min_speed) abs(speed) >= min_speed
#define SANITIZE_SPEED(speed) SIGN(speed) * Clamp(abs(speed), 0, max_speed)
#define CHANGE_SPEED_BY(speed_var, v_diff, min_speed) \
	v_diff = SANITIZE_SPEED(v_diff);\
	if(!MOVING(speed_var + v_diff, min_speed)) \
		{speed_var = 0};\
	else \
		{speed_var = round(SANITIZE_SPEED((speed_var + v_diff) / (1 + speed_var * v_diff / (max_speed ** 2))), SHIP_MOVE_RESOLUTION)}
// Uses Lorentzian dynamics to avoid going too fast.
#define SENSOR_COEFFICENT 1000