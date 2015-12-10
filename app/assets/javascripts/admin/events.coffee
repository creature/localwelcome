activate_popovers = -> $('.popoverable').popover trigger: "hover", html: true

# Call activate_popovers on full page load and Turbolinks page change.
$ activate_popovers
$(document).on 'page:load', activate_popovers
