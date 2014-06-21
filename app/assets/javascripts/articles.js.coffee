# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # Markdown preview
  (() ->
    preview = (event) ->
      closestForm = $(event.target).closest("form")
      body = closestForm.find("textarea").val()
      $.ajax({
        url: ROOT_PATH + "articles/preview",
        type: "post",
        data: {body: body},
        dataType: "text",
        success: (data) ->
          previewArea = closestForm.find(".preview-area")
          previewArea.html(data)
          previewArea.show()
      })

    input = $(".preview-button")
    input.on "click", input.parent(), preview
  )()

  # Display comment edit form
  (() ->
    displayCommentEditForm = (event) ->
      dt = $(event.target).closest("dt")
      dt.next("dd").find(".comment-form").show();

    editLink = $(".comment-edit-link")
    editLink.on "click", editLink.parent(), displayCommentEditForm
  )()

# for turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
