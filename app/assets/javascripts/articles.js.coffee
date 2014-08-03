$(document).on("ready page:load", () ->


  (() ->
    # tagging
    initTypeAhead = () ->
      $("input.js-tag-names").typeahead('destroy')

      bhTags = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 10,
        dupDetector: (remoteMatch, localMatch) ->
          remoteMatch.id == localMatch.id
        ,
        # prefetch: {
        #   url: '/tags/list.json',
        #   ttl: 5000
        # },
        remote: '/tags/list.json?q=%QUERY'
      });

      bhTags.initialize()

      $("input.js-tag-names").typeahead(
        {
          hint: true,
          highlight: true,
          minLength: 1
        },
        {
          name: 'tagName',
          displayKey: 'name',
          source: bhTags.ttAdapter(),
          templates: {
            suggestion: Handlebars.compile('<p><strong>{{name}}</strong> ({{taggings_count}})</p>')
          }
        }
      );



    initTypeAhead()

    # add tag btn
    $("#js-add-tag-btn").click(() ->
      if $(".tag-group").size() < 4
        $tagGroup = $("<div class='tag-group'><input class='typeahead js-tag-names form-control' type='text' placeholder='タグ' name='article[tag_list][]' /><button class='btn btn-xs js-remove-tag-btn' type='button'>&times;</button></div>")
        $tagGroup.insertBefore("#js-add-tag-btn")
        initTypeAhead()
    );

    # remove tag btn
    $("#tag-input-container").on("click", ".js-remove-tag-btn", () ->
      if 1 < $("#tag-input-container .js-remove-tag-btn").size()
        $(this).parent(".tag-group").remove()
    );
  )();


)
