# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # User Info
  (() ->
    # User icon size
    ICON_SIZE = 80
    ARTICLE_PATH = "/articles/"
    userInfoArea = $("#user-info-area")
    userInfoArea.on "click", (event) ->
      event.stopPropagation()

    showUserInfo = (event) ->
      trigger = $(event.target)
      $.getJSON(ROOT_PATH + "users/" + trigger.attr(userIdDataAttrName), (user) ->
          # Set icon
          icon = $("#user-info-icon")
          icon.attr("src", createGravatarUrl(user.gravatar))
          icon.attr("alt", user.name)
          icon.attr("title", user.name)
          $("#user-info-name").text(user.name)
          $("#user-info-contribution .num-of-contribution").text(user.contribution)
          articleList = $("#user-info-article-list>ol")
          articleList.empty();
          $.each(user.articles, () ->
            li = $("<li>")
            a = $("<a>")
            a.attr("href", ARTICLE_PATH + this.id)
            a.text(this.title)
            li.append(a)
            articleList.append(li);
          )
          offset = trigger.offset()
          userInfoArea.fadeIn(100)
          userInfoArea.offset({
            left: offset.left - userInfoArea.outerWidth() + trigger.outerWidth(),
            top: offset.top + trigger.outerHeight()
          })
          areaOffset = userInfoArea.offset()
          if areaOffset.left < 0
            userInfoArea.offset({
              left: areaOffset.left + userInfoArea.outerWidth() - trigger.outerWidth()
            })
      )

    hideUserInfo = (event) ->
      userInfoArea.hide()

    createGravatarUrl = (gravatarHash) ->
      "http://www.gravatar.com/avatar/" + gravatarHash + "?size=" + ICON_SIZE;

    userIdDataAttrName = "data-user-id"
    triggers = $("[" + userIdDataAttrName + "]")
    triggers.on "click", triggers.parent(), showUserInfo
    $(document).on "click", hideUserInfo
  )()

# for turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
