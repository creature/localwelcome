# We hide the "Who do you want to meet?" box for JS users, and display it in a popover when they click the 'request an invite' button.
add_invite_form_listeners = ->
  $("form.new-invite").on("submit", (ev) ->
    ev.preventDefault()
    $("#invite-modal").modal 'show'
  )

# Call add_invite_form_listeners both on full page load & when Turbolinks loads a new page
$ add_invite_form_listeners
$(document).on 'page:load', add_invite_form_listeners
