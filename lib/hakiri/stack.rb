require 'active_support/all'

class Hakiri::Stack
  attr_accessor :technologies, :default_path

  def initialize()
    @default_path = ''
    @technologies = {}
  end

  def build_from_json(technologies)

  end

  # This method analyzes user input from the Hakiri gem and sets up
  # default paths to retrieve versions.
  #
  # * *Args*    :
  #   - +server+ -> Rails server selection
  #   - +extra_server+ -> Apache, nginx, both or neither
  #   - +db+ -> DB selection
  #   - +redis+ -> is Redis present?
  #   - +memcached+ -> is Memcached present?
  #
  def build_from_input(server, extra_server, db, redis, memcached)
    @technologies['ruby'] = { path: @default_path }
    @technologies['ruby_on_rails'] = { path: @default_path }

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
    @technologies.each do |technology_name, value|
      begin
        technology_class = Hakiri.const_get(technology_name.gsub('-', '_').camelcase)
        technology_object = technology_class.new(value[:path])

        if technology_object.version
          @technologies[technology_name][:version] = technology_object.version
        else
          @technologies.delete(technology_name)
        end
      rescue Exception => e
        puts "Error: technology #{technology_name} doesn't exist."
        @technologies.delete(technology_name)
      end
    end
  end
end