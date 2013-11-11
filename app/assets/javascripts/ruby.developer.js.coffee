jQuery ->
  $('.content').on 'click', '.awe-cog', ->
#    console.log($(this))
    item = $(this).closest('li')
#    image_url = item.find('a.thumbnail img').attr('src')
    image_url = item.find('i').css('background-image').replace('url(', '').replace(')','')



#    console.log(item, image_url, item.data('url'))

    type = item.data('type')
    submit_url = item.data('url')

    if($(".slideshow-setting-div").length == 1)
      $("div.form").removeClass('form')
      $("div.individual").addClass('form')
      $("div.slideshow-setting-div").hide()
      $("div.individual").show()

    $('.form').find('form').attr('action', submit_url)

    if type == 'photo'
      $('#caption').val(item.data('caption'))
    else if type == 'track' or type == 'video' or type == 'music'
      $('#caption').val(item.data('title'))
      url = "http://www.youtube.com/v/#{item.data('video-id')}"
      $('.form-video').data('url', url)
    else
      $('#caption').val(item.data('name'))

    $('#tags').val(item.data('tags'))
    $('#object_id').val(item.data('id'))


    $('.form-image, .form-video').attr('href', image_url)
    $('.form-image img, .form-video img').attr('src', image_url)
    
  $('.content').on 'click', '.awe-trash', ->
#    console.log($(this))
    item = $(this).closest('li')
    image_url = item.find('a.thumbnail img').attr('src')
#    console.log(item, image_url, item.data('url'))

    type = item.data('type')
    submit_url = item.data('url')

    $('#demoModal').find('form').attr('action', submit_url)

    
  $('.preview').on 'click', (event) ->
    event.preventDefault()
    $('.track-preview').html('')
