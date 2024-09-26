require "open3"
require "fileutils"

class Youtube::ArchiveService
  def self.download_mp3(video_url, id_archive)
    output_dir = Rails.root.join("public", "music_files")
    FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)

    output_file = output_dir.join("#{id_archive}.mp3")
    return { downloaded: true, file_path: output_file } if File.exist?(output_file)

    # A gambitécnica começa aqui, usando lib de terceiros pra rodar comando no terminal de download de vídeo e
    # obtendo ele em formato .mp3 sem dor de cabeça
    command = "yt-dlp -x --audio-format mp3 -o \"#{output_file}\" #{video_url}"

    stdout, stderr, status = Open3.capture3(command)

    { downloaded: status.success?, file_path: output_file }
  end

  def self.get_path_mp3(id_archive)
    return unless id_archive

    "#{Rails.root.join("public", "music_files")}/#{id_archive}.mp3"
  end

  def self.destroy_mp3(id_archive)
    return unless id_archive

    output_dir = Rails.root.join("public", "music_files")
    return unless Dir.exist?(output_dir)

    begin
      File.open("#{output_dir}/#{id_archive}.mp3", "r") do |f|
        File.delete(f)
      end
    rescue Exception => e
      Rails.logger.error "Houve erro ao buscar arquivo mp3 id #{id_archive} para deletar: #{e.message}"
    end
  end
end
