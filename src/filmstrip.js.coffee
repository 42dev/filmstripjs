###
	Filmstrip.coffee
	Created by the 42 developer team
	Version 1.0 4/16/13
	
	Requirements: jQuery
###

class window.Filmstrip

	#
	# constructor ->
	# The constructor generates all the image tags and adds them to the container
	# It also fires an optional callback when it's complete
	#
	constructor: (opts) ->
		@currFrame = 0 # Used internally to track which frame is currently being shown
		@animator_timeout = false # used internally
		@totalFrames = 0
		@frames = []

		#
		# options: 
		# image_container_selector: The selector for the DOM element that will contain all the images
		# frame_urls: An array of image urls, one for each frame
		# framerate: How many frames/second should the plugin try to play at? (upper bound varies per machine)
		# setup_cbfn: callback function to call post setup
		# pre_animation_cbfn: callback function to call before animation starts
		# post_animation_cbfn: callback function to call after the animation ends
		# post_showFrame_cbfn(current_frame_index): callback function to call when each frame is shown
		#
		@options =
			image_container_selector: "#container"
			frame_urls: []
			framerate: 42
			setup_cbfn: false
			pre_animation_cbfn: false
			post_animation_cbfn: false
			pre_showFrame_cbfn: false
			post_showFrame_cbfn: false

		$.extend(@options, opts)
		@$container = $(@options.image_container_selector).empty()
		@generate_images()

		if @frames.length > 0
			@frames[0].show()
			
		@totalFrames = @frames.length

		if typeof @options.setup_cbfn is "function"
			@options.setup_cbfn()


	#
	# play ->
	# "Plays" the "Video" to the last frame
	#
	play: =>
		@playTo(@totalFrames-1)


	#
	# pause ->
	# "Pauses" the "Video"
	#
	pause: =>
		window.clearInterval(@animator_timeout)
		@animator_timeout = false


	#
	# jumpTo ->
	# Shows a specific frame
	#
	jumpTo: (frame_index) =>
		frame_index = @bound_frame_index(frame_index)
		window.clearInterval(@animator_timeout)
		@animator_timeout = false

		# Do nothing if frame_index is undefined
		if frame_index is undefined
			return

		@frames[@currFrame].hide()
		@frames[frame_index].show()
		@currFrame = frame_index


	#
	# playFromTo (start_frame, end_frame)
	# "Plays" from one frame to the other
	#
	playFromTo: (start_frame, end_frame) =>
		@currFrame  = @bound_frame_index(start_frame)
		@playTo(@bound_frame_index(end_frame))


	#
	# playTo (frame_index) =>
	# "Plays" the "Video" and stops at a specific frame
	# You can use this method for playing in reverse as well
	#
	playTo: (frame_index) =>
		window.clearInterval(@animator_timeout)
		@animator_timeout = false
		frame_index = @bound_frame_index(frame_index)

		# Do nothing if frame_index is undefined
		if frame_index is undefined
			return
		
		if typeof @options.pre_animation_cbfn is 'function'
			@options.pre_animation_cbfn(@currFrame)
		# animate to nearest keyframe
		@animator_timeout = setInterval =>
			@doAnimation(frame_index)
		, (1/(@options.framerate/1000))


	#
	# doAnimation(frame_index)
	#
	doAnimation: (frame_index) =>
		# Pre-showFrame callback, passes the previous frame
		if typeof @options.pre_showFrame_cbfn is 'function'
			@options.pre_showFrame_cbfn(@currFrame) 
		if @currFrame!=frame_index
			# hide the current frame
			@frames[@currFrame].hide()
			if frame_index > @currFrame
				@currFrame++
			else
				@currFrame--
			# show the next frame
			@frames[@currFrame].show()

			#call back
			if typeof @options.post_showFrame_cbfn is 'function'
				@options.post_showFrame_cbfn(@currFrame)
		else
			window.clearInterval(@animator_timeout)
			@animator_timeout = false
			if typeof @options.post_animation_cbfn is 'function'
				@options.post_animation_cbfn(@currFrame)


	#
	# generate_images () =>
	# Uses the frame_urls array to generate all the required image tags and adds them to the container
	#
	generate_images: () =>
		#generate all the images
		for url in @options.frame_urls
			$frame = $('<img src="'+url+'" style="display:none;" />')
			@$container.append($frame)
			@frames.push($frame)


	#
	# bound_frame_index (new_index) =>
	# Helper method for ensuring the target frame remains within the bounds
	# Returns undefined if there are no frames
	#
	bound_frame_index: (frame_index) ->
		if @totalFrames == 0
			return undefined
		Math.max(Math.min(frame_index, @totalFrames-1), 0)
