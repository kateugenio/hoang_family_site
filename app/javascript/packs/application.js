// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'bootstrap'
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("trix")
require("@rails/actiontext")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

$(document).ready(function() {
  // Initiatlize Bootstraps Custom File Input: https://getbootstrap.com/docs/4.5/components/forms/#file-browser
  bsCustomFileInput.init();

  // Rails will add field_with_errors class to form fields, add bootstrap's is-invalid class to highlight in red
  $('.form-control').each(function() {
    if ($(this).closest('div').hasClass('field_with_errors')) {
      $(this).addClass('is-invalid');
    }
  });

  // New user welcome modal. This will only be triggered if user 'sign_in_count' equals 1, see DashboardController#index.
  $('#welcome-modal').modal('show');
});
