#define ADULT_SLIME (1<<0)
#define PASSIVE_SLIME (1<<1)
#define STORED_SLIME (1<<2)

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
