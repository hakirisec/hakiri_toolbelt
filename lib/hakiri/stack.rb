require 'active_support/all'

class Hakiri::Stack
  attr_accessor :technologies, :default_path

  # This method initializes Hakiri::Stack class
  #
  def initialize()
    @default_path = ''
    @technologies = {}
    @errors = []
  end

  # This method parses a supplied JSON file and sets stack technologies.
  #
  # * *Args*    :
  #   - +json_file+ -> JSON file with technologies in the Hakiri format.
  #
  def build_from_json_file(json_file)
    @technologies = JSON.parse(IO.read(json_file))
  end

  # This method analyzes user input from the Hakiri gem and sets up
  # default paths to retrieve versions.
  #
  # * *Args*    :
  #   - +server+ -> Rails server selection.
  #   - +extra_server+ -> Apache, nginx, both or neither.
  #   - +db+ -> DB selection.
  #   - +redis+ -> is Redis present?
  #   - +memcached+ -> is Memcached present?
  #
  def build_from_input(server, extra_server, db, redis, memcached)
    @technologies['ruby'] = { path: @default_path }
    @technologies['ruby-on-rails'] = { path: @default_path }

    case server
      when 1
        @technologies['unicorn'] = { path: @default_path }
      when 2
        @technologies['phusion-passenger'] = { path: @default_path }
      when 3
        @technologies['thin'] = { path: @default_path }
      when 4
        @technologies['trinidad'] = { path: @default_path }
        @technologies['java'] = { path: @default_path }
        @technologies['apache-tomcat'] = { path: @default_path }
        @technologies['jruby'] = { path: @default_path }
      else
        nil
    end

    case extra_server
      when 1
        @technologies['apache'] = { path: @default_path }
      when 2
        @technologies['nginx'] = { path: @default_path }
      when 3
        @technologies['apache'] = { path: @default_path }
        @technologies['nginx'] = { path: @default_path }
      else
        nil
    end

    case db
      when 1
        @technologies['mysql'] = { path: @default_path }
      when 2
        @technologies['postgres'] = { path: @default_path }
      when 3
        @technologies['mongodb'] = { path: @default_path }
      else
        nil
    end

    @technologies['redis'] = { path: @default_path } if redis

    @technologies['memcached'] = { path: @default_path } if memcached
  end

  # This method attempts to get versions of technologies in the @technologies
  # instance variable. If a version is part of a technology hash then it doesn't
  # get overwritten by this method.
  #
  def fetch_versions
    @technologies.each do |technology_slug, value|
      @technologies[technology_slug].symbolize_keys!

      technology_class = Hakiri.const_get(technology_slug.gsub('-', '_').camelcase)
      technology_object = technology_class.new(value[:path])

      if technology_object.version
        @technologies[technology_slug][:version] = technology_object.version unless @technologies[technology_slug][:version] and @technologies[technology_slug][:version] != ''
        @technologies[technology_slug][:name] = technology_object.name
      else
        @technologies.delete(technology_slug)
      end
    end
  end
end