jQuery-Marquee without CSS3 Support
==============

A greatly simplified and rewritten in coffeescript version of jquery.marquee with state save/load support.
Example usage with Turbolinks:

```coffee
marquee_offset = '20px'
$ma = false

m_start = ->
  $ma = $('#h-line')
  if $ma.hasClass('done')
    $ma.html($ma.find('.js-marquee:first').html())
  $ma.addClass('done').marquee(
    duration: 20000
    delayBeforeStart: 0
    duplicated: true
    pauseOnHover: true
    pauseOnCycle: true
  )
  $ma.marquee('setOffset', marquee_offset)
  $ma.marquee('reanimate')

m_stop = ->
  marquee_offset = $ma.marquee('getOffset')
  $ma.marquee('destroy').removeClass('done')

init = ->
  m_start()

if Turbolinks.supported
  $(document).on('page:change', init)
  $(document).on('page:before-unload', ->
    m_stop()
  )

else
  $(init)
```

## License

MIT license, same as original plugin according to https://plugins.jquery.com/marquee/