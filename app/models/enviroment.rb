class Enviroment < ApplicationRecord
  before_save :encrypt_value
  after_find :decrypt_value

  private

  def encrypt_value
    self.value = Crypto.encrypt(self.value) if self.value
  end

  def decrypt_value
    self.value = Crypto.decrypt(self.value) if self.value
  end
end
