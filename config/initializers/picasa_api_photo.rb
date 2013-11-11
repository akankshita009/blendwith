module Picasa
  module API
    class Photo < Base
  
      def show(album_id, photo_id, options = {})

        # response = Connection.new.get(:path => path, :query => options, :headers => auth_header)
        path = "https://picasaweb.google.com/data/feed/api/user/#{user_id}/albumid/#{album_id}/photoid/#{photo_id}"
        

        response = Connection.new.get(:path => path, :query => options, :headers => auth_header)

        photo = Picasa::Presenter::Photo.new(response.parsed_response["feed"])
        src = response.parsed_response["feed"]["media$group"]["media$content"][0]["url"] rescue nil
        [photo, src]
      end
    end
  end
end
