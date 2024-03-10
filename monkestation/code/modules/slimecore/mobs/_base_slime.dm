/mob/living/basic/slime
	name = "grey baby slime (123)"
	icon = 'monkestation/code/modules/slimecore/icons/slimes.dmi'
	icon_state = "baby_grey"

	ai_controller = /datum/ai_controller/basic_controller/slime

	pass_flags = PASSTABLE | PASSGRILLE
	gender = NEUTER
	faction = list(FACTION_SLIME)

	//emote_see = list("jiggles", "bounces in place")
	speak_emote = list("blorbles")
	bubble_icon = "slime"
	initial_language_holder = /datum/language_holder/slime

	verb_say = "blorbles"
	verb_ask = "inquisitively blorbles"
	verb_exclaim = "loudly blorbles"
	verb_yell = "loudly blorbles"

	// canstun and canknockdown don't affect slimes because they ignore stun and knockdown variables
	// for the sake of cleanliness, though, here they are.
	status_flags = CANUNCONSCIOUS|CANPUSH

	///we track flags for slimes here like ADULT_SLIME, and PASSIVE_SLIME
	var/slime_flags = NONE

	///our current datum for slime color
	var/datum/slime_color/current_color
	///this is our last cached hunger precentage between 0 and 1
	var/hunger_precent = 0
	///how much hunger we need to produce
	var/production_precent = 0.6
	///our list of slime traits
	var/list/slime_traits = list()
	///used to help our name changes so we don't rename named slimes
	var/static/regex/slime_name_regex = new("\\w+ (baby|adult) slime \\(\\d+\\)")

/mob/living/basic/slime/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_SLIME, 0.5, -11)
	AddElement(/datum/element/soft_landing)

	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	if(!current_color)
		current_color = new /datum/slime_color/green

	AddComponent(/datum/component/liquid_secretion, current_color.secretion_path, 10, 10 SECONDS, TYPE_PROC_REF(/mob/living/basic/slime, check_secretion))
	AddComponent(/datum/component/generic_mob_hunger, 400, 0.1, 5 MINUTES, 200)
	AddComponent(/datum/component/scared_of_item, 5)

	RegisterSignal(src, COMSIG_HUNGER_UPDATED, PROC_REF(hunger_updated))

	update_slime_varience()

/mob/living/basic/slime/proc/update_slime_varience()
	if(slime_flags & ADULT_SLIME)
		icon_state = "grey adult slime"
	else
		if(HAS_TRAIT(src, TRAIT_FEEDING))
			icon_state = "grey baby slime eat"
		else
			icon_state = "grey baby slime"
	color = current_color.slime_color

	SEND_SIGNAL(src, COMSIG_SECRETION_UPDATE, current_color.secretion_path, 10, 10 SECONDS)

/mob/living/basic/slime/proc/check_secretion()
	if(!(slime_flags & ADULT_SLIME))
		return FALSE

	if(hunger_precent < production_precent)
		return FALSE
	return TRUE

/mob/living/basic/slime/proc/hunger_updated(datum/source, current_hunger, max_hunger)
	hunger_precent = current_hunger / max_hunger
	if(hunger_precent > 0.6)
		slime_flags |= ADULT_SLIME
	else
		slime_flags &= ~ADULT_SLIME
	update_slime_varience()

/mob/living/basic/slime/proc/add_trait(datum/slime_trait/added_trait)
	var/datum/slime_trait/new_trait = new added_trait
	new_trait.on_add(src)
	slime_traits += new_trait

/mob/living/basic/slime/proc/remove_trait(datum/slime_trait/removed_trait)
	slime_traits -= removed_trait
	qdel(removed_trait)

/mob/living/basic/slime/update_name()
	if(slime_name_regex.Find(name))
		number = rand(1, 1000)
		name = "[current_color.name] [(slime_flags & ADULT_SLIME) ? "adult" : "baby"] slime ([number])"
		real_name = name
	return ..()
