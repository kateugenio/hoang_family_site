class FamilyController < ApplicationController
  # GET /family/tree
  # https://github.com/CanCanCommunity/cancancan/issues/53
  def tree
    authorize! :tree, :family
    @family_tree_photo = PhotoAlbum.find_by(is_admin: true, admin_type: 'family_tree')
  end
end
