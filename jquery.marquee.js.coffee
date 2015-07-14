(($, window) ->
  class Marquee
    defaults:
      # requires jQuery easing plugin. Default is 'linear'
      easing: 'linear',
      # speed in milliseconds of the marquee in milliseconds
      duration: 5000,
      # gap in pixels between the tickers
      gap: 20,
      # on hover pause the marquee - using jQuery plugin https://github.com/tobia/Pause
      pauseOnHover: false

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @$el = $(el)
      @$el.wrapInner('<div class="js-marquee"></div>')
      @$el.find('.js-marquee').css({
        'margin-right': @options.gap,
        'float': 'left'
      })
      @$clone = @$el.find('.js-marquee').clone(true).appendTo(@$el)
      @$el.wrapInner('<div style="width:100000px" class="js-marquee-wrapper"></div>')
      @$wrapper = @$el.find('.js-marquee-wrapper')

      if @options.pauseOnHover
        @$el.bind('mouseenter mouseleave', @toggle)

      @reset()
      @animate()

    reset: =>
      console.log 'reset'
      @$wrapper.css('margin-left', '10px')

    animate: =>
      @running = true
      animationCss = {
        'margin-left': '-' + @elWidth() + 'px'
      }
      console.log animationCss
      @$wrapper.animate(animationCss, @duration(), @options.easing, =>
        console.log 'finished'
        @$el.trigger('finished')
        @reset()
        @animate()
      )

    elWidth: =>
      @$el.find('.js-marquee:first').width() + @options.gap

    duration: =>
      containerWidth = @$el.width()
      ret = ((parseInt(@elWidth(), 10) + parseInt(containerWidth, 10)) / parseInt(containerWidth, 10)) * @options.duration
      if @getOffset() < 0
        ret = ret * ((@elWidth() + @getOffset()) / @elWidth())
      ret

    pause: =>
      if $.fn.pause
        @$wrapper.pause()
        @running = false
        @$el.trigger('paused')

    resume: =>
      if $.fn.resume
        @$wrapper.resume()
        @running = true
        @$el.trigger('resumed')

    toggle: =>
      if @running
        @pause()
      else
        @resume()

    setOffset: (value)=>
      @$wrapper.css('margin-left', value)

    getOffset: (value)=>
      parseInt(@$wrapper.css('margin-left'))

    reanimate: ->
      @$wrapper.stop()
      @animate()

    destroy: =>
      @$el.find("*").andSelf().unbind()
      @$el.html(@$el.find('.js-marquee:first').html())
 
  $.fn.extend marquee: (option, args...) ->
    $this = $(this)
    data = $this.data('marquee')
    if !data
      $this.data 'marquee', (data = new Marquee(this, option))
    if typeof option == 'string'
      data[option].apply(data, args)
 
) window.jQuery, window
