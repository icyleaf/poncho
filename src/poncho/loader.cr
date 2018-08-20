require "./parser"

module Poncho
  # `Poncho::Loader` is a .env file loader
  class Loader
    property env

    def initialize(@env : String = "development")
    end

    # Load environment variables and overwrite existing ones.
    #
    # Same as `#load`(overwrite: true)
    def load!(*files)
      load(*files, overwrite: true)
    end

    # Load environment variables
    def load(*files, overwrite = false)
      if files.size > 1 && files.last.is_a?(Bool)
        overwrite = files.last.as(Bool)
      end

      files.each do |file|
        next unless file.is_a?(String)
        if file = find_file(file)
          Poncho::Parser.from_file(file, overwrite).each do |key, value|
            key_exists = ENV.has_key?(key)
            ENV[key] = value if !key_exists || (key_exists && overwrite)
          end
        end
      end
    end

    # Find dotenv file
    private def find_file(file : String) : String?
      filepath = File.dirname(file)
      filename = File.basename(file)

      search_filenames(filename).each do |name|
        tempfile = File.join(filepath, name)
        return tempfile if File.exists?(tempfile)
      end
    end

    private def search_filenames(name : String) : Array(String)
      local_suffix = ".local"

      Array(String).new.tap do |names|
        names << name

        is_local_env = name.ends_with?(local_suffix)
        names << "#{name}#{local_suffix}" unless is_local_env

        name = name.gsub(local_suffix, "") if is_local_env
        names << "#{name}.#{env}" unless is_local_env
        names << "#{name}.#{env}#{local_suffix}"
      end
    end
  end

  module LoaderHelper
    def load!(*files, env = "development")
      loader = Loader.new(env)
      loader.load!(*files, overwrite: true)
      loader
    end

    def load(*files, env = "development", overwrite = false)
      loader = Loader.new(env)
      loader.load(*files, overwrite)
      loader
    end
  end

  extend LoaderHelper
end
