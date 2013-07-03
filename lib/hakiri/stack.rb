require 'active_support/all'

class Hakiri::Stack
  attr_accessor :technologies, :default_command

  #
  # Initializes a stack.
  #
  def initialize()
    @default_command = ''
    @technologies = {}
    @errors = []
  end

  #
  # Parses a supplied JSON file and sets stack technologies.
  #
  # @param [String] json_file
  #   JSON file with technologies in the Hakiri format.
  #
  def build_from_json_file(json_file)
    @technologies = JSON.parse(IO.read(json_file))
  end

  #
  # Parses a supplied Gemfile.lock and sets stack technologies.
  #
  # @param [String] gemfile
  #   Gemfile.lock file.
  #
  def build_from_gemfile(gemfile)
    begin
      lockfile = Bundler::LockfileParser.new(IO.read(gemfile))

      lockfile.sources.map do |source|
        case source
          when Bundler::Source::Git
            case source.uri
              when /^git:/, /^http:/
                say "!      Insecure Source: #{source.uri}"
            end
          when Bundler::Source::Rubygems
            source.remotes.each do |uri|
              if uri.scheme == 'http'
                say "!      Insecure Source: #{uri.to_s}"
              end
            end
        end
      end

      lockfile.specs.each do |gem|
        @technologies[gem.name] = { name: gem.name, version: gem.version.to_s, type: 'gem' }
      end
    rescue Exception => e
      say "!      Couldn\'t parse your Gemfile.lock: #{e}"
    end
  end

  #
  # This method analyzes user input from the Hakiri gem and sets up
  # default commands to retrieve versions.
  #
  # @param [String] server
  #   Rails server selection.
  #
  # @param [String] extra_server
  #   Apache, nginx, both or neither.
  #
  # @param [String] db
  #   DB selection.
  #
  # @param [String] redis
  #   Is Redis present?
  #
  # @param [String] memcached
  #   Is Memcached present?
  #
  def build_from_input(server, extra_server, db, redis, memcached)
    @technologies['ruby'] = { :command => @default_command }
    @technologies['ruby-on-rails'] = { :command => @default_command }

    case server
      when 1
        @technologies['unicorn'] = { :command => @default_command }
      when 2
        @technologies['phusion-passenger'] = { :command => @default_command }
      when 3
        @technologies['thin'] = { :command => @default_command }
      when 4
        @technologies['trinidad'] = { :command => @default_command }
        @technologies['java'] = { :command => @default_command }
        @technologies['apache-tomcat'] = { :command => @default_command }
        @technologies['jruby'] = { :command => @default_command }
      else
        nil
    end

    case extra_server
      when 1
        @technologies['apache'] = { :command => @default_command }
      when 2
        @technologies['nginx'] = { :command => @default_command }
      when 3
        @technologies['apache'] = { :command => @default_command }
        @technologies['nginx'] = { :command => @default_command }
      else
        nil
    end

    case db
      when 1
        @technologies['mysql'] = { :command => @default_command }
      when 2
        @technologies['postgres'] = { :command => @default_command }
      when 3
        @technologies['mongodb'] = { :command => @default_command }
      else
        nil
    end

    @technologies['redis'] = { :command => @default_command } if redis

    @technologies['memcached'] = { :command => @default_command } if memcached
  end

  #
  # Attempts to get versions of technologies in the @technologies
  # instance variable. If a version is part of a technology hash then it doesn't
  # get overwritten by this method.
  #
  def fetch_versions
    @technologies.each do |technology_slug, value|
      @technologies[technology_slug].symbolize_keys!

      technology_class = Hakiri.const_get(technology_slug.gsub('-', '_').camelcase)
      technology_object = technology_class.new(value[:command])

      if technology_object.version
        @technologies[technology_slug][:version] = technology_object.version unless @technologies[technology_slug][:version] and @technologies[technology_slug][:version] != ''
        @technologies[technology_slug][:name] = technology_object.name
      else
        @technologies.delete(technology_slug)
      end
    end
  end
end