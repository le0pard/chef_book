$ ->
  # AddThis buttons
  if $('#socialSharingBlock').is(":visible")
    window.addthis_config =
      data_track_addressbar: true
    window.addthis_share =
      title: "Cooking Infrastructure by Chef"
      description: "Cooking Infrastructure by Chef, free book about DevOps"
    $.getScript "http://s7.addthis.com/js/300/addthis_widget.js#pubid=ra-527012705413f0b7"