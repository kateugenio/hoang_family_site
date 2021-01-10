module PhotoAlbumsHelper
  def filtered_by(user_albums)
    if params[:my_albums]
      'My Albums'
    elsif params[:user]
      album = user_albums.select { |album| album[:id] == params[:user].to_i }.first[:name]
    else
      'All Albums'
    end
  end
end
