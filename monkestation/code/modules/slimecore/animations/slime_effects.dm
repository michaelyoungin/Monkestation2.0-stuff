/obj/effect/abstract/blank
	name = ""
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon ='monkestation/code/modules/slimecore/icons/filters.dmi'
	icon_state = "blank"

GLOBAL_DATUM(rainbow_effect, /obj/effect/abstract/blank)

/atom/movable/proc/rainbow_effect() // this just animates between the primary colors of a rainbow
	if(!GLOB.rainbow_effect)
		GLOB.rainbow_effect = new
		GLOB.rainbow_effect.add_filter("rainbow", 10, alpha_mask_filter(render_source = "rainbow"))

		animate(GLOB.rainbow_effect, color = "#FF0000", time = rand(0.3 SECONDS, 1.2 SECONDS), loop = -1, easing = LINEAR_EASING, flags = ANIMATION_PARALLEL)
		animate(color = "#FFFF00", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#00FF00", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#00FFFF", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#0000FF", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#FF00FF", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)

	vis_contents += GLOB.rainbow_effect
	render_target = "rainbow"

/atom/movable/proc/remove_rainbow_effect()
	vis_contents -= GLOB.rainbow_effect
	render_target = null

/image/proc/rainbow_effect() // this just animates between the primary colors of a rainbow
	if(!GLOB.rainbow_effect)
		GLOB.rainbow_effect = new
		GLOB.rainbow_effect.add_filter("rainbow", 10, alpha_mask_filter(render_source = "rainbow"))

		animate(GLOB.rainbow_effect, color = "#FF0000", time = rand(0.3 SECONDS, 1.2 SECONDS), loop = -1, easing = LINEAR_EASING, flags = ANIMATION_PARALLEL)
		animate(color = "#FFFF00", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#00FF00", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#00FFFF", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#0000FF", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)
		animate(color = "#FF00FF", time = rand(0.3 SECONDS, 1.2 SECONDS), easing = LINEAR_EASING)

	vis_contents += GLOB.rainbow_effect
	render_target = "rainbow"

/atom/proc/ungulate()
	var/matrix/ungulate_matrix = matrix(transform)
	ungulate_matrix.Scale(1, 0.9)
	var/matrix/base_matrix = matrix(transform)
	var/base_pixel_y = pixel_y

	animate(src, transform = ungulate_matrix, time = 0.1 SECONDS, easing = EASE_OUT, loop = -1)
	animate(pixel_y = -1, time = 0.1 SECONDS, easing = EASE_OUT)
	animate(transform = base_matrix, time = 0.1 SECONDS, easing = EASE_IN)
	animate(pixel_y = base_pixel_y, time = 0.1 SECONDS, easing = EASE_IN)
