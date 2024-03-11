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
	///our number
	var/number = 0

	///list of all possible mutations
	var/list/possible_color_mutations = list()

	var/list/compiled_liked_foods = list()
	///the in progress mutation used for descs
	var/datum/slime_color/mutating_into
	///this is our mutation chance
	var/mutation_chance = 30

/mob/living/basic/slime/Initialize(mapload, datum/slime_color/passed_color)
	. = ..()
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_SLIME, 0.5, -11)
	AddElement(/datum/element/soft_landing)

	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	if(!passed_color)
		current_color = new /datum/slime_color/grey
	else
		current_color = new passed_color

	AddComponent(/datum/component/liquid_secretion, current_color.secretion_path, 10, 10 SECONDS, TYPE_PROC_REF(/mob/living/basic/slime, check_secretion))
	AddComponent(/datum/component/generic_mob_hunger, 400, 0.1, 5 MINUTES, 200)
	AddComponent(/datum/component/scared_of_item, 5)

	RegisterSignal(src, COMSIG_HUNGER_UPDATED, PROC_REF(hunger_updated))
	RegisterSignal(src, COMSIG_MOB_OVERATE, PROC_REF(attempt_change))

	for(var/datum/slime_mutation_data/listed as anything in current_color.possible_mutations)
		var/datum/slime_mutation_data/data = new listed
		data.on_add_to_slime(src)
		possible_color_mutations += data
		if(length(data.needed_items))
			compiled_liked_foods |= data.needed_items

	update_slime_varience()
	if(length(compiled_liked_foods))
		recompile_ai_tree()


/mob/living/basic/slime/Destroy()
	. = ..()
	for(var/datum/slime_trait/trait as anything in slime_traits)
		remove_trait(trait)
	UnregisterSignal(src, COMSIG_HUNGER_UPDATED)
	QDEL_NULL(current_color)

/mob/living/basic/slime/proc/recompile_ai_tree()
	var/list/new_planning_subtree = list()

	RemoveElement(/datum/element/basic_eating)

	if(!HAS_TRAIT(src, TRAIT_SLIME_RABID))
		new_planning_subtree |= /datum/ai_planning_subtree/simple_find_nearest_target_to_flee_has_item
		new_planning_subtree |= /datum/ai_planning_subtree/flee_target

	if(!(slime_flags & PASSIVE_SLIME))
		new_planning_subtree |= /datum/ai_planning_subtree/simple_find_target/slime

	if(length(compiled_liked_foods))
		AddElement(/datum/element/basic_eating, food_types = compiled_liked_foods)
		new_planning_subtree |= /datum/ai_planning_subtree/find_food
		ai_controller.set_blackboard_key(BB_BASIC_FOODS, compiled_liked_foods)

	new_planning_subtree |= /datum/ai_planning_subtree/basic_melee_attack_subtree/slime

	ai_controller.replace_planning_subtrees(new_planning_subtree)

/mob/living/basic/slime/proc/update_slime_varience()
	if(slime_flags & ADULT_SLIME)
		icon_state = "grey adult slime"
	else
		if(HAS_TRAIT(src, TRAIT_FEEDING))
			icon_state = "grey baby slime eat"
		else
			icon_state = "grey baby slime"
	color = current_color.slime_color

	update_name()
	SEND_SIGNAL(src, COMSIG_SECRETION_UPDATE, current_color.secretion_path, 10, 10 SECONDS)

/mob/living/basic/slime/proc/check_secretion()
	if((!(slime_flags & ADULT_SLIME)) || (slime_flags & STORED_SLIME) || (slime_flags & MUTATING_SLIME))
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

/mob/living/basic/slime/proc/start_split()
	ai_controller.set_ai_status(AI_STATUS_OFF)
	slime_flags |= SPLITTING_SLIME

	visible_message(span_notice("[name] starts to flatten, it looks to be splitting."))

	addtimer(CALLBACK(src, PROC_REF(finish_splitting)), 15 SECONDS)

/mob/living/basic/slime/proc/finish_splitting()
	SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, -200)
	update_slime_varience()

	slime_flags &= ~SPLITTING_SLIME
	ai_controller.set_ai_status(AI_STATUS_ON)

	var/mob/living/basic/slime/new_slime = new(loc, current_color.type)

/mob/living/basic/slime/proc/start_mutating()
	if(!pick_mutation())
		return FALSE

	ai_controller.set_ai_status(AI_STATUS_OFF)
	visible_message(span_notice("[name] starts to ungulate, it looks to be mutating."))
	slime_flags |= MUTATING_SLIME

	var/matrix/ungulate_matrix = matrix(transform)
	ungulate_matrix.Scale(1, 0.9)
	var/matrix/base_matrix = matrix(transform)
	var/base_pixel_y = pixel_y

	animate(src, transform = ungulate_matrix, time = 0.1 SECONDS, easing = EASE_OUT, loop = -1)
	animate(pixel_y = -1, time = 0.1 SECONDS, easing = EASE_OUT)
	animate(transform = base_matrix, time = 0.1 SECONDS, easing = EASE_IN)
	animate(pixel_y = base_pixel_y, time = 0.1 SECONDS, easing = EASE_IN)


	addtimer(CALLBACK(src, PROC_REF(finish_mutating)), 30 SECONDS)
	return TRUE

/mob/living/basic/slime/proc/change_color(datum/slime_color/new_color)
	QDEL_NULL(current_color)
	current_color = new_color

	update_slime_varience()

	compiled_liked_foods = list()

	QDEL_LIST(possible_color_mutations)
	possible_color_mutations = list()

	for(var/datum/slime_mutation_data/listed as anything in current_color.possible_mutations)
		var/datum/slime_mutation_data/data = new listed
		data.on_add_to_slime(src)
		possible_color_mutations += data
		if(length(data.needed_items))
			compiled_liked_foods |= data.needed_items

	recompile_ai_tree()

/mob/living/basic/slime/proc/finish_mutating()
	SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, -200)
	change_color(mutating_into)

	slime_flags &= ~MUTATING_SLIME
	ai_controller.set_ai_status(AI_STATUS_ON)

	animate(src) // empty animate to break ungulating

/mob/living/basic/slime/proc/pick_mutation(random = FALSE)
	var/list/valid_choices = list()
	for(var/datum/slime_mutation_data/listed as anything in possible_color_mutations)
		if(!random && !listed.can_mutate)
			continue
		valid_choices += listed
		valid_choices[listed] = listed.weight
	if(!length(valid_choices))
		return FALSE

	var/datum/slime_mutation_data/picked = pick_weight(valid_choices)
	mutating_into = new picked.output
	return TRUE

/mob/living/basic/slime/proc/attempt_change(datum/source, hunger_precent)
	if(prob(mutation_chance)) // we try to mutate 30% of the time
		if(!start_mutating())
			start_split()
	else
		start_split()
