require 'fileutils'

class Hakiri::Manifest < Hakiri::Cli
  #
  # Generates a JSON manifest file
  #
  def generate
    FileUtils::copy_file "#{File.dirname(__FILE__)}/manifest.json", "#{Dir.pwd}/manifest.json"
    File.chmod 0755, "#{Dir.pwd}/manifest.json"
  end
end