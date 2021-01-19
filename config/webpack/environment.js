const { environment } = require('@rails/webpacker')

// Based on: https://www.botreetechnologies.com/blog/introducing-jquery-in-rails-6-using-webpacker/
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default']
  })
)

module.exports = environment
