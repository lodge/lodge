$ ->
  insertAtCaret = (target, str) ->
    obj = $(target)
    obj.focus()
    if navigator.userAgent.match(/MSIE/)
      range = document.selection.createRange()
      range.text = str
      range.select()
    else
      text = obj.val()
      position = obj.get(0).selectionStart
      currentPosition = position + str.length
      obj.val text.substr(0, position) + str + text.substr(position)
      obj.get(0).setSelectionRange currentPosition, currentPosition

  $("#fileupload").fileupload
    dropZone: $('#article_body')
    url: '/images.json'
    sequentialUploads: true
    dataType: 'json'
    done: (e, data) ->
      $.each data.files, (index, file) ->
        text = '![' + file.name + '](' + data.result.image_url + ')'
        insertAtCaret('#article_body', text)
