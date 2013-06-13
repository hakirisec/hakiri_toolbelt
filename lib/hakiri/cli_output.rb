class Hakiri::CliOutput
  def initialize
    @technologies_table = []
  end

  def fancy_technologies_table(technologies)
    technologies.each { |key, value| @technologies_table << [key, value[:version]] }

    Terminal::Table.new rows: @technologies_table
  end
end