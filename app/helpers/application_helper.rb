module ApplicationHelper
  def default_or_uploaded_avatar(user)
    return user.avatar if user.avatar.attached?

    'default-user-avatar'
  end

  def rounded_avatar(user, width, height)
    image = default_or_uploaded_avatar(user)
    image_tag(image, class: "d-block ui-w-30 rounded-circle img-raised", width: width,
                     height: height)
  end

  def uri_scheme?(str)
    uri = URI.parse(str)
    %w(http https).include?(uri.scheme)
  end

  def external_site_url(url)
    return url if uri_scheme?(url)

    url.prepend('https://')
  end

  def removed_social_media_at_sign(at_handle)
    return at_handle unless at_handle.first === '@'

    at_handle.delete('@')
  end

  def render_upload_photo_modal(user)
    return if session[:skipped_profile_photo_upload]

    return unless user.sign_in_count == 1 && !user.admin? && !user.avatar.attached?

    render 'new_user_welcome_modal'
  end
end
