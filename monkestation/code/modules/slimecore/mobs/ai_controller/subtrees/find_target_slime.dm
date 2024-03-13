/datum/ai_planning_subtree/simple_find_target_no_trait
	var/trait = TRAIT_AI_PAUSED

/datum/ai_planning_subtree/simple_find_target_no_trait/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets_without_trait, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETING_STRATEGY, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION, trait)


/datum/ai_planning_subtree/simple_find_target_no_trait/slime
	trait = TRAIT_LATCH_FEEDERED

/datum/ai_planning_subtree/simple_find_target_no_trait/slime/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(!controller.blackboard[BB_BASIC_MOB_STOP_FLEEING])
		return
