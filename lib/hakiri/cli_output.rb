class Hakiri::CliOutput
  def initialize
    @technologies_table = []
  end

  def fancy_technologies_table(technologies)
    technologies.each { |technology_name, payload| @technologies_table << [technology_name, payload[:version]] }

    Terminal::Table.new rows: @technologies_table
  end

  def separator
    "+#{ '-' * 68 }+"
  end
end