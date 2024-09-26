require "google/apis/youtube_v3"
require "uri"

class Youtube::SearchService
  # Esse REGEX é somente para buscar o ID na Url do Youtube,
  # se caso o param query for um link
  YOUTUBE_URL_REGEX = /\A(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/ # não me pergunte, mas sim do ChatGPT

  def self.music(query)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = ENV["YOUTUBE_API_KEY"]

    video_id = extract_video_id(query)

    if video_id
      search_response = youtube.list_videos("snippet", id: video_id)
    else
      search_response = youtube.list_searches("snippet", q: query, max_results: 1, type: "video")
    end

    if search_response.items.any?
      video = search_response.items.first
      video_id ||= video.id.video_id
      snippet = video.snippet

      {
        link: "https://www.youtube.com/watch?v=#{video_id}",
        title: snippet.title,
        description: snippet.description,
        channel_title: snippet.channel_title,
        published_at: snippet.published_at,
        thumbnail: snippet.thumbnails.high.url,
        found: true,
      }
    else
      { link: "Nenhum vídeo encontrado para essa pesquisa.", found: false }
    end
  end

  private

  def self.extract_video_id(query)
    match = query.match(YOUTUBE_URL_REGEX)
    match[1] if match
  end
end
