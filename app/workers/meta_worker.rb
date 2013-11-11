
class MetaWorker
  include Sidekiq::Worker

  def perform(audio_id)
    UploadedAudio.find(audio_id).fetch_meta
  end
end
