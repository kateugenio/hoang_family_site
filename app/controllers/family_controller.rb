class FamilyController < ApplicationController
  # GET /family/tree
  # https://github.com/CanCanCommunity/cancancan/issues/53
  def tree
    @family_tree_photo = PhotoAlbum.find_by(is_admin: true, admin_type: 'family_tree')
  end

  # GET/family/bios
  def bios
    @family_members = User.non_admin_approved_users
  end
end
