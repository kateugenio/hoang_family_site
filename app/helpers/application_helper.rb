module ApplicationHelper
  def default_or_uploaded_avatar(user, width, height)
    image = if user.avatar.attached?
              user.avatar
            else
              'default-user-avatar'
            end
    image_tag(image, class: "d-block ui-w-30 rounded-circle", width: width, height: height)
  end
end
