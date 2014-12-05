describe "filmstrip coffee", ->
  beforeEach -> 
    @options = {
      framerate: 1000
      image_container_selector: "#pancakes"
      frame_urls: ["lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg", "lol.jpg"]
      setup_cbfn: "Setup"
      pre_animation_cbfn: "pre_animation"
      post_animation_cbfn: "post_animation"
      post_showFrame_cbfn: "post_showFrame"
    }
    @filmstrip = new Filmstrip(@options)
    @options.frame_urls = []
    @filmstrip2 = new Filmstrip(@options)


  describe "constructor", ->
    it "has the correct totalFrames value", ->    
      expect(@filmstrip.totalFrames).toEqual(10)
    it "has the configured container selector", ->
      expect(@filmstrip.options.image_container_selector).toEqual("#pancakes")
    it "has the configured setup_cbfn", ->
      expect(@filmstrip.options.setup_cbfn).toEqual("Setup")
    it "has the configured pre_animation_cbfn", ->
      expect(@filmstrip.options.pre_animation_cbfn).toEqual("pre_animation")
    it "has the configured post_animation_cbfn", ->
      expect(@filmstrip.options.post_animation_cbfn).toEqual("post_animation")
    it "has the configured post_showFrame_cbfn", ->
      expect(@filmstrip.options.post_showFrame_cbfn).toEqual("post_showFrame")

  describe "jump to frame", ->
    it "sets the correct value", ->
      @filmstrip.jumpTo(5)
      expect(@filmstrip.currFrame).toEqual(5)
    it "can't go out of bounds negative", ->
      @filmstrip.jumpTo(-1)
      expect(@filmstrip.currFrame).toEqual(0)
    it "can't go out of bounds postive", ->
      @filmstrip.jumpTo(11)
      expect(@filmstrip.currFrame).toEqual(9)

  describe "play to frame", ->
    it "plays to the final frame", ->
      runs ->
        @filmstrip.play()
      waitsFor( =>
        @filmstrip.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(@filmstrip.currFrame).toEqual(9)
    it "plays to the zeroth frame", ->
      @filmstrip.currFrame = 9
      runs ->
        @filmstrip.playTo(0)
      waitsFor( =>
        @filmstrip.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(@filmstrip.currFrame).toEqual(0)
    it "shouldn't play past the final frame", ->
      runs ->
        @filmstrip.playTo(100)
      waitsFor( =>
        @filmstrip.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(@filmstrip.currFrame).toEqual(9)
    it "shouldn't play past to the zeroth frame", ->
      @filmstrip.currFrame = 9
      runs ->
        @filmstrip.playTo(-10)
      waitsFor( =>
        @filmstrip.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(@filmstrip.currFrame).toEqual(0)

  describe "doAnimation", ->
    it "should not change the current frame", ->
      @filmstrip.currFrame = 5
      @filmstrip.doAnimation(5)
      expect(@filmstrip.currFrame).toEqual(5)
    it "should increment the current frame", ->
      @filmstrip.currFrame = 5
      @filmstrip.doAnimation(10)
      expect(@filmstrip.currFrame).toEqual(6)
    it "should deccrement the current frame", ->
      @filmstrip.currFrame = 5
      @filmstrip.doAnimation(0)
      expect(@filmstrip.currFrame).toEqual(4)
    it "should clear the animation timeout variable", ->
      @filmstrip.currFrame = 5
      @filmstrip.doAnimation(5)
      expect(@filmstrip.animator_timeout).toEqual(false)

  describe "callbacks", ->
    it "should call setup callback", ->
      setup_callback = jasmine.createSpy()
      @options.setup_cbfn = setup_callback
      @filmstrip2 = new Filmstrip(@options)
      expect(setup_callback).toHaveBeenCalled()

    it "should call pre-animation callback", ->
      pre_animation_callback = jasmine.createSpy("for pre animation callback")
      @filmstrip.options.pre_animation_cbfn = pre_animation_callback
      @filmstrip.play()
      expect(pre_animation_callback).toHaveBeenCalled()

    it "should call post-animation callback", ->
      post_animation_callback = jasmine.createSpy("for post animation callback")
      @filmstrip.options.post_animation_cbfn = post_animation_callback
      runs =>
        @filmstrip.play()
      waitsFor( =>
        @filmstrip.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(post_animation_callback).toHaveBeenCalled()

    it "should call frame animation callback", ->
      frame_cbfn = jasmine.createSpy("for post frame change callback")
      @filmstrip.options.post_showFrame_cbfn = frame_cbfn
      runs =>
        @filmstrip.play()
      waitsFor( =>
        @filmstrip.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(frame_cbfn.callCount).toEqual(9)

  describe "without frames", ->
    it "should return undefined when bounding the frame index", ->
      expect(@filmstrip2.bound_frame_index(0)).toEqual(undefined)

    it "shouldn't call pre-animation callback", ->
      pre_animation_callback = jasmine.createSpy("for pre animation callback")
      @filmstrip2.options.pre_animation_cbfn = pre_animation_callback
      @filmstrip2.play()
      expect(pre_animation_callback).not.toHaveBeenCalled()

    it "shouldn't call post-animation callback", ->
      post_animation_callback = jasmine.createSpy("for post animation callback")
      @filmstrip2.options.post_animation_cbfn = post_animation_callback
      runs =>
        @filmstrip2.play()
      waitsFor( =>
        @filmstrip2.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(post_animation_callback).not.toHaveBeenCalled()
    it "shouldn't call frame animation callback", ->
      frame_cbfn = jasmine.createSpy("for post frame change callback")
      @filmstrip2.options.post_showFrame_cbfn = frame_cbfn
      runs =>
        @filmstrip2.play()
      waitsFor( =>
        @filmstrip2.animator_timeout == false
      , "animation to complete", 500)
      runs =>
        expect(frame_cbfn.callCount).toEqual(0)
