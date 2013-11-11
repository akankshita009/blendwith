jQuery ->


  object = {}

  $(document).on 'click', '.play', (event) ->
    event.preventDefault()

  
    $self = $(this)
    trackId = $(this).data('trackId')
    path = "/tracks/#{trackId}/stream"
    
    if object[trackId]
      if $self.text() == 'Play'
        soundManager.play(object[trackId])
        $self.text('Stop')
      else
        soundManager.stop(object[trackId])
        $self.text('Play')
    else
      SC.stream path, (sound) ->
        sound.play()
        soundId = sound.sID
        object[trackId] = soundId
        $self.text('Stop')


