module Crypto
  def self.decrypt(data)
    return nil if data.to_s.empty?

    decipher = OpenSSL::Cipher::AES.new(128, :ECB)
    decipher.decrypt
    decipher.key = ENV["BOT_SECRET_KEY"]
    decipher.update(Base64.decode64(data)) + decipher.final
  end

  def self.encrypt(data)
    return nil if data.to_s.empty?

    cipher = OpenSSL::Cipher::AES.new(128, :ECB)
    cipher.encrypt
    cipher.key = ENV["BOT_SECRET_KEY"]
    enc = cipher.update(data.to_s) + cipher.final
    Base64.encode64(enc).gsub("\n", "")
  end
end
