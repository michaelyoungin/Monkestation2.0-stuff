#define ADULT_SLIME (1<<0)
#define PASSIVE_SLIME (1<<1)
#define STORED_SLIME (1<<2)
#define MUTATING_SLIME (1<<3)
#define SPLITTING_SLIME (1<<4)

#define TRAIT_ON_DEATH (1<<0)
#define TRAIT_VISUAL (1<<1)

#define TRAIT_FEEDING "feeding_trait"
#define LATCH_TRAIT "latch_trait"

#define BB_BASIC_MOB_SCARED_ITEM "BB_basic_mob_scared_item"

#define TRAIT_SLIME_STASIS "slime_stasis"
#define TRAIT_SLIME_RABID "slime_rabid"

#define TRAIT_OVERFED "overfed_trait"

///from obj/item/vacuum_nozzle/afterattack(atom/movable/target, mob/user, proximity, params): (obj/item/vacuum_nozzle/nozzle, mob/user)
#define COMSIG_LIVING_VACUUM_PRESUCK "living_vacuum_presuck"
	#define COMPONENT_LIVING_VACUUM_CANCEL_SUCK (1<<0)

#define SLIME_VALUE_TIER_1 200
#define SLIME_VALUE_TIER_2 400
#define SLIME_VALUE_TIER_3 800
#define SLIME_VALUE_TIER_4 1600
#define SLIME_VALUE_TIER_5 3200
#define SLIME_VALUE_TIER_6 6400
#define SLIME_VALUE_TIER_7 12800

#define SLIME_SELL_MODIFIER_MIN 	  -0.03
#define SLIME_SELL_MODIFIER_MAX 	  -0.01
#define SLIME_SELL_OTHER_MODIFIER_MIN 0.002
#define SLIME_SELL_OTHER_MODIFIER_MAX 0.005
#define SLIME_SELL_MAXIMUM_MODIFIER   2
#define SLIME_SELL_MINIMUM_MODIFIER   0.25
#define SLIME_RANDOM_MODIFIER_MIN -0.0003
#define SLIME_RANDOM_MODIFIER_MAX 0.0003
