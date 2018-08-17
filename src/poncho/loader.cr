require "./parser"

module Poncho
  # `Poncho::Loader` is a .env file loader
  class Loader
    ENVRIOMENTS = %w(development test production)

    def self.new
      loader = new
      yield loader
      loader
    end

    property env
    property delimiter
    property suffixes

    def initialize(@env : String? = nil, @delimiter = ".", @suffixes = ENVRIOMENTS)
    end

    # Load environment variables and overwrite existing ones.
    #
    # Same as `#load`(overwrite: true)
    def load!(*files)
      load(*files, overwrite: true)
    end

    # Load environment variables
    def load(*files, overwrite = false)
      # overwrite = files if (files.size > 1 && files[-1].is_a?(Bool))

      files.each do |file|
        next unless file.is_a?(String)
        Poncho::Parser.from_file(file, overwrite).each do |key, value|
          key_exists = ENV.has_key?(key)
          ENV[key] = value if !key_exists || (key_exists && overwrite)
        end
      end
    end

    # # Find dotenv file
    # private def find_dotenv(name) : String?
    #   return file if @suffixes.size.zero? && File.exists?(file)
    #   if (env = @env) && (dotenv_file = match_dotenv(file, env))
    #     return dotenv_file
    #   end

    #   @suffixes.each do |suffix|
    #     if dotenv_file = match_dotenv(file, suffix)
    #       return dotenv_file
    #     end
    #   end
    # end

    # # Append segment as suffix to match file and load it.
    # private def match_dotenv(file, suffix) : String?
    #   path = File.dirname(file)
    #   name = File.basename(file)

    #   return dotenv_file?(path, "#{name}#{@delimiter}#{suffix}") unless name.index(@delimiter, 1)

    #   dotenv_file?(path, matched_name)
    # end

    # private def dotenv_file?(path, name) : String?
    #   file = File.join(path, name)
    #   return file if File.exists?(file)
    # end
  end

  module LoaderHelper
    def load(file : String, overwrite = false)
      load(file, overwrite: overwrite)
    end

    def load(file : String, overwrite = false)
      load(file, overwrite: overwrite)
    end

    def load(*files, overwrite = false)
      loader = Loader.new(tuple_to_array(*files))
      yield loader
      loader.load(overwrite)
      loader
    end

    def load(*files, overwrite = false)
      loader = Loader.new(tuple_to_array(*files))
      loader.load(overwrite)
      loader
    end

    private def tuple_to_array(*tuples)
      tuples.each_with_object([] of String) do |key, obj|
        obj << key.to_s
      end
    end
  end

  # extend LoaderHelper
end
