module BootstrapFlashHelper
  ALERT_TYPES = [:success, :info, :warning, :danger].freeze unless const_defined?(:ALERT_TYPES)

  # rubocop: disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Rails/OutputSafety
  def bootstrap_flash(options={})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_class = options.extract!(:class)[:class]
      tag_options = {
        class: "alert alert-#{type} alert-dismissible fade show #{tag_class}"
      }.merge(options)

      close_button = tag.button(raw("&times;"), type: "button", class: "close",
                                                "data-dismiss": "alert", "aria-label": "close")

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
  # rubocop: enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Rails/OutputSafety
end
