# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  # Notification toggle
  (() ->
    showNotification = (event) ->
      trigger = $(event.target)
      offset = trigger.offset()
      target.fadeIn(100)
      target.offset({
        left: offset.left - target.outerWidth() + trigger.outerWidth(),
        top: offset.top + trigger.outerHeight()
      })

    hideNotification = (event) ->
      target.hide()

    target = $("#notifications-area")
    counter = $("#num-of-notification.new-notifications")
    counter.on "click", counter.parent(), showNotification
    $(document).on "click", hideNotification
  )()

# for turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
