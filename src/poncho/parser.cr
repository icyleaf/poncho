module Poncho
  # `Poncho::Parser` is a .env file parser
  #
  # Poncho parses the contents of your file containing environment variables is available to use.
  # It accepts a String or IO and will return an `Hash` with the parsed keys and values.
  #
  # ### Rules
  #
  # Poncho parser currently supports the following rules:
  #
  # - Skipped the empty line and comment(`#`).
  # - Ignore the comment which after (`#`).
  # - `NAME=foo` becomes `{"NAME" => "foo"}`.
  # - Empty values become empty strings.
  # - Whirespace is removed from right ends of the value.
  # - Single and Double quoted values are escaped.
  # - New lines are expanded if in double quotes.
  # - Inner quotes are maintained (such like json).
  # - Overwrite optional (default is non-overwrite).
  # - Only accpets string type value.
  #
  # ### Overrides
  #
  # By default, Poncho won't overwrite existing environment variables as dotenv assumes the deployment environment
  # has more knowledge about configuration than the application does.
  # To overwrite existing environment variables you can use `Poncho.parse!(string_or_io)` /
  # `Poncho.from_file(file, overwrite: true)` and `Poncho.parse(string_or_io, overwrite: true)`.
  #
  # ### Parse file
  #
  # ```
  # parser = Poncho::Parser.from_file(".env")
  # parser["ENV"] # => "development"
  # ```
  #
  # ### Parse raw string
  #
  # ```
  # parser = Poncho::Parser.new("ENV=development\nDB_NAME=poncho\nENV=production")
  # parser.parse
  # parser["ENV"] # => "development"
  #
  # # Overwrite the key
  # parser.parse!
  # parser["ENV"] # => "production"
  # ```
  class Parser
    def self.from_file(file : String, overwrite = false)
      parser = new(File.open(file))
      parser.parse(overwrite)
      parser
    end

    @env = {} of String => String

    def initialize(@raw : String | IO)
    end

    # Parse environment variables and overwrite existing ones.
    #
    # Same as `#parse`(overwrite: true)
    def parse!
      parse(true)
    end

    # Parse environment variables
    def parse(overwrite = false)
      @raw.each_line do |line|
        next if line.blank? || !line.includes?('=')
        next unless expression = extract_expression(line)

        key, value = expression.split("=", 2).map { |v| v.strip }
        if ['\'', '"'].includes?(value[0]) && ['\'', '"'].includes?(value[-1])
          if value[0] == '"' && value[-1] == '"'
            value = value.gsub("\\n", "\n").gsub("\\r", "\r")
          end

          value = value[1..-2]
        end

        env_key = env_key(key)
        key_existes = @env.has_key?(env_key)
        @env[env_key] = value if !key_existes || (key_existes && overwrite)
      end

      nil
    end

    # Returns this collection as a plain Hash.
    def to_h : Hash(String, String)
      @env
    end

    forward_missing_to @env

    private def env_key(key : String)
      unless key.includes?("_")
        # example: dbName => DB_NAME
        return (lowcase?(key) ? snakecase(key) : key).upcase
      end

      # example: DB_Name = DB_NAME
      key.split("_").each_with_object(Array(String).new) do |part, obj|
        obj << (lowcase?(part) ? snakecase(part) : part)
      end.join("_").upcase
    end

    private def extract_expression(raw)
      if raw.includes?('#')
        segments = [] of String
        quotes_open = false
        raw.split('#').each do |segment|
          if segment.scan("'").size == 1 || segment.scan("\"").size == 1
            if quotes_open
              quotes_open = false
              segments << segment
            else
              quotes_open = true
            end
          end

          if segments.size.zero? || quotes_open
            segments << segment
          end
        end

        line = segments.join('#')
        line unless line.empty?
      else
        raw
      end
    end

    private def snakecase(key : String) : String
      return key if key.empty?

      first = true
      String.build do |io|
        key.each_char do |char|
          if first
            io << char.downcase
          elsif char.ord >= 65 && char.ord <= 90
            io << '_' << char.downcase
          else
            io << char
          end

          first = false
        end
      end
    end

    private def lowcase?(key : String) : Bool
      key.each_codepoint do |codepoint|
        return true if codepoint >= 97 && codepoint <= 122
      end

      false
    end
  end

  # Poncho parser helper
  #
  # ```
  # require "poncho/parser"
  # ```
  module ParserHelper
    # Parse dotenv from file
    def from_file(file : String, overwrite = false)
      Parser.from_file(file, overwrite)
    end

    # Parse raw string and overwrite the value with same key
    #
    # Same as `#parse`(raw, overwrite: true)
    def parse!(raw : String | IO)
      parse(raw, true)
    end

    # Parse raw string
    def parse(raw : String | IO, overwrite = false)
      parser = Parser.new(raw)
      parser.parse(overwrite)
      parser
    end
  end

  extend ParserHelper
end
