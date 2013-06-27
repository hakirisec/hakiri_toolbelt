require 'fileutils'

class Hakiri::Manifest < Hakiri::Cli
  #
  # Generates a JSON manifest file
  #
  def generate
    FileUtils::copy_file "#{File.dirname(__FILE__)}/manifest.json", "#{Dir.pwd}/manifest.json"
    File.chmod 0755, "#{Dir.pwd}/manifest.json"
    say '-----> Generating the manifest file...'
    say "       Generated the manifest file in #{Dir.pwd}/manifest.json"
    say "       Edit it and run \"hakiri system:scan\""
  end
end