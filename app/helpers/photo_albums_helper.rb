module PhotoAlbumsHelper
  def filtered_by(user_albums, params)
    if params[:album] == 'current_user'
      'My Albums'
    elsif params[:user]
      user_albums.select { |album| album[:id] == params[:user].to_i }.first[:name]
    else
      'All Albums'
    end
  end
end
