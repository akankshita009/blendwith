# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131028202610) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.text     "image_url"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "network"
    t.string   "social_network_id"
  end

  create_table "collections", :force => true do |t|
    t.string   "title"
    t.text     "image_url"
    t.string   "network"
    t.string   "social_netowrk_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "owner_id",         :null => false
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.text     "body",             :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "containers", :force => true do |t|
    t.integer  "albumize_id"
    t.string   "albumize_type"
    t.integer  "collection_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "containers", ["albumize_id"], :name => "index_containers_on_albumize_id"
  add_index "containers", ["albumize_type"], :name => "index_containers_on_albumize_type"
  add_index "containers", ["collection_id"], :name => "index_containers_on_collection_id"

  create_table "content_controls", :force => true do |t|
    t.integer "user_id"
    t.integer "itemizable_id"
    t.string  "itemizable_type"
  end

  add_index "content_controls", ["itemizable_id", "itemizable_type"], :name => "content_control_itemizable"
  add_index "content_controls", ["user_id"], :name => "index_content_controls_on_user_id"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "cover_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "friend_feeds", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "network"
    t.string   "title"
    t.string   "image_url"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "media_type"
    t.integer  "item_id"
    t.boolean  "private",    :default => false
  end

  create_table "friend_maps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "is_confirmed", :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "itemizable_id"
    t.string   "itemizable_type", :default => "Photo"
    t.integer  "playlist_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "items", ["itemizable_id", "itemizable_type"], :name => "index_items_on_itemizable_id_and_itemizable_type"
  add_index "items", ["playlist_id"], :name => "index_items_on_playlist_id"

  create_table "music_urls", :force => true do |t|
    t.string   "music_url"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               :default => false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "photo_albums", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "album_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "photo_albums", ["album_id"], :name => "index_photo_albums_on_album_id"
  add_index "photo_albums", ["photo_id"], :name => "index_photo_albums_on_photo_id"

  create_table "photo_urls", :force => true do |t|
    t.string   "image_url"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "user_id"
    t.string   "caption",    :default => ""
  end

  create_table "photos", :force => true do |t|
    t.string   "caption"
    t.text     "image_url"
    t.boolean  "private",           :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "network"
    t.string   "social_network_id"
  end

  create_table "players", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "players", ["user_id"], :name => "index_players_on_user_id"

  create_table "playlists", :force => true do |t|
    t.string   "name"
    t.integer  "player_id"
    t.integer  "items_count"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "user_id"
    t.string   "type",                     :default => "ImagePlaylist"
    t.boolean  "slide_show",               :default => true
    t.string   "transition",               :default => "Slide"
    t.string   "background_music_id"
    t.string   "background_music_type"
    t.string   "background_music_url"
    t.string   "background_music_title"
    t.string   "social_network"
    t.integer  "delay_second",             :default => 5
    t.boolean  "set_feed",                 :default => true
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "cover_image_source"
  end

  add_index "playlists", ["player_id"], :name => "index_playlists_on_player_id"
  add_index "playlists", ["user_id"], :name => "index_playlists_on_user_id"

  create_table "profile_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "services", :force => true do |t|
    t.string   "uid"
    t.text     "provider"
    t.integer  "user_id"
    t.string   "access_token"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.text     "data"
    t.datetime "expires_at"
    t.string   "google_service"
    t.boolean  "disconnected",   :default => false
    t.string   "refresh_token"
  end

  add_index "services", ["user_id"], :name => "index_services_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.text     "track_object"
    t.boolean  "private"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "network"
    t.string   "audio_url"
    t.string   "social_network_id"
  end

  create_table "twitter_users", :force => true do |t|
    t.text     "twitter_user"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "uploaded_audios", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "panda_audio_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "artist"
    t.string   "album"
    t.string   "genre"
    t.string   "music_photo_file_name"
    t.string   "music_photo_content_type"
    t.string   "music_photo_file_size"
    t.string   "music_photo_updated_at"
  end

  create_table "uploaded_photos", :force => true do |t|
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.string   "caption",            :default => ""
  end

  create_table "uploaded_videos", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "panda_video_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",                  :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "no_need_confirm",                     :default => true
    t.integer  "comment_count",                       :default => 0
    t.string   "city"
    t.string   "location"
    t.string   "player_title"
    t.text     "player_description"
    t.string   "privacy"
    t.string   "uid"
    t.string   "provider"
    t.string   "player_token"
    t.boolean  "approved",                            :default => false
    t.datetime "deleted_at"
    t.integer  "embed_code_privacy",     :limit => 2, :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["deleted_at"], :name => "index_users_on_deleted_at"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "video_albums", :force => true do |t|
    t.string   "name"
    t.text     "image_url"
    t.string   "network"
    t.string   "social_network_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "video_urls", :force => true do |t|
    t.string   "video_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "title"
  end

  create_table "video_video_albums", :force => true do |t|
    t.integer  "video_id"
    t.integer  "video_album_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "video_video_albums", ["video_album_id"], :name => "index_video_video_albums_on_video_album_id"
  add_index "video_video_albums", ["video_id"], :name => "index_video_video_albums_on_video_id"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.boolean  "private",           :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "network"
    t.string   "video_id"
    t.string   "social_network_id"
    t.string   "image_url"
  end

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
