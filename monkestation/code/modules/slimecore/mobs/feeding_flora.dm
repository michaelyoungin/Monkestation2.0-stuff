/mob/living/basic/cockroach/rockroach
	name = "rockroach"
	desc = "This cockroach has decided to cosplay as a turtle and is carrying a rock shell on it's back."
	icon = 'monkestation/code/modules/slimecore/icons/xenofauna.dmi'
	icon_state = "rockroach"
	health = 15
	maxHealth = 15

/mob/living/basic/cockroach/rockroach/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squashable, squash_chance = 15, squash_damage = 5)
	AddElement(/datum/element/death_drops, list(/obj/item/rockroach_shell))

/obj/item/rockroach_shell
	name = "rockroach shell"
	desc = "A rocky shell of some poor rockroach."
	icon = 'monkestation/code/modules/slimecore/icons/xenofauna.dmi'
	icon_state = "rockroach_shell"
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 2
	throw_range = 7
