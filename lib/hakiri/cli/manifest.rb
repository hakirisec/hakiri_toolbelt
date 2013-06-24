class Hakiri::Manifest < Hakiri::Cli
  #
  # Generates a JSON manifest file
  #
  def generate
    File.open(file, 'w') do |f|

    end
    File.chmod 0755, file
    say "-----> Generated manifest in #{file}"
  end
end