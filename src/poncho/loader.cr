require "./parser"

module Poncho
  # `Poncho::Loader` is a .env file loader
  #
  # Poncho loads the environment file is easy to use. It accepts both single file (or path) and multiple files.
  #
  # ### Orders
  #
  # Poncho loads **single file** supports the following order with environment name (default is `development`):
  #
  # - `.env` - The Original®
  # - `.env.development` - Environment-specific settings.
  # - `.env.local` - Local overrides. This file is loaded for all environments except `test`.
  # - `.env.development.local` - Local overrides of environment-specific settings.
  #
  # > **NO** effect with multiple files, it only loads the given files.
  #
  # ### Overrides
  #
  # By default, Poncho won't overwrite existing environment variables as dotenv assumes the deployment environment
  # has more knowledge about configuration than the application does.
  #
  # ### Load single file
  #
  # ```
  # loader = Poncho::Loader.new env: "development"
  # loader.load ".env"
  # ```
  #
  # ### Load multiple files
  #
  # ```
  # loader = Poncho::Loader.new
  # loader.load ".env", ".env.local"
  # ```
  class Loader

    DEFAULT_ENV_NAME = "development"

    def initialize(@env : String? = nil)
    end

    # Load environment variables and overwrite existing ones.
    #
    # Same as `#load`(*files, overwrite: true)
    def load!(*paths)
      load(*paths, overwrite: true)
    end

    # Load environment variables
    def load(*paths, overwrite = false)
      if paths.size > 1 && paths.last.is_a?(Bool)
        overwrite = paths.last.as(Bool)
      end

      paths = paths.select {|f| f.is_a?(String) && !f.as(String).empty? }
      if paths.size > 1
        # Loads passed file in multiple files mode, ignore env name.
        paths.each do |path|
          load_to_env(path, overwrite) if File.exists?(path)
        end
      else
        # Loads orders files in single file mode.
        load_files(paths.first).each do |file|
          load_to_env(file, overwrite)
        end
      end
    end

    private def load_to_env(file : String, overwrite : Bool)
      Poncho::Parser.from_file(file, overwrite).each do |key, value|
        key_exists = ENV.has_key?(key)
        ENV[key] = value if !key_exists || (key_exists && overwrite)
      end
    end

    private def load_files(path : String) : Array(String)
      local_suffix = ".local"
      default_dotenv_name = ".env"
      env_name = @env || DEFAULT_ENV_NAME

      path = File.expand_path(path)
      filepath = Dir.exists?(path) ? path : File.dirname(path)
      filename = Dir.exists?(path) ? default_dotenv_name : File.basename(path)
      is_local_env = filename.ends_with?(local_suffix)
      Array(String).new.tap do |files|
        append_existed_file(files, filepath, filename)
        name = is_local_env ? "#{filename.gsub(local_suffix, "")}.#{env_name}" : "#{filename}.#{env_name}"
        append_existed_file(files, filepath, name)
        append_existed_file(files, filepath, "#{filename}#{local_suffix}") unless is_local_env
        append_existed_file(files, filepath, "#{filename}.#{env_name}#{local_suffix}")
      end
    end

    private def append_existed_file(files, path, name)
      if file = find_file?(path, name)
        files << file
      end
    end

    private def find_file?(path, name) : String?
      file = File.join(path, name)
      return file if File.exists?(file)
    end
  end

  # Poncho load helper
  #
  # ```
  # require "poncho/loader"
  # ```
  module LoaderHelper
    # Load environment variables and overwrite existing ones.
    #
    # Same as `#load`(*files, overwrite: true)
    #
    # ```
    # # Searching order: .env.development, .env.local, .env.development.local
    # Poncho.load! ".env"
    #
    # # Load from path
    # Poncho.load! "config/"
    #
    # # Load multiple files, ignore enviroment name.
    # Poncho.load! ".env", ".env.local", env: "test"
    # ```
    def load!(*files, env : String? = nil)
      load(*files, env: env, overwrite: true)
    end

    # Load environment variables
    #
    # ```
    # # Searching order: .env.development, .env.local, .env.development.local
    # Poncho.load ".env"
    #
    # # Load from path
    # Poncho.load "config/"
    #
    # # Load multiple files, ignore enviroment name.
    # Poncho.load ".env", ".env.local", env: "test"
    # ```
    def load(*files, env : String? = nil, overwrite = false)
      loader = Loader.new(env: env)
      loader.load(*files, overwrite: overwrite)
      loader
    end
  end

  extend LoaderHelper
end
