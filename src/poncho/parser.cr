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
  # - `ENV=development` becomes `{"ENV" => "development"}`.
  # - Converts camelcase boundaries to underscores and upcase the key: `dbName` becomes `DB_NAME`, `DB_NAME` becomes `DB_NAME`
  # - Support variables in value. `$NAME` or `${NAME}`.
  # - Whitespace is removed from both ends of the value. `NAME = foo ` becomes`{"NAME" => "foo"}
  # - New lines are expanded if in double quotes. `MULTILINE="new\nline"` becomes `{"MULTILINE" => "new\nline"}
  # - Inner quotes are maintained (such like `Hash`/`JSON`). `JSON={"foo":"bar"}` becomes `{"JSON" => "{\"foo\":\"bar\"}"}
  # - Empty values become empty strings.
  # - Single and double quoted values are escaped.
  # - Overwrite optional (default is non-overwrite).
  # - Support variables in value. `WELCOME="hello $NAME"` becomes `{"WELCOME" => "hello foo"}`
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
    @vars = {} of String => Array(String)

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
        key, value = extract_env(expression)
        set_env(key, value, overwrite)
      end

      replace_variables
    end

    # Returns this collection as a plain Hash.
    def to_h : Hash(String, String)
      @env
    end

    forward_missing_to @env

    private def extract_env(expression : String)
      search_vars = true
      key, value = expression.split("=", 2).map { |v| v.strip }
      if ['\'', '"'].includes?(value[0]) && ['\'', '"'].includes?(value[-1])
        if value[0] == '"' && value[-1] == '"'
          value = value.gsub("\\n", "\n").gsub("\\r", "\r")
        else
          search_vars = false
        end

        value = value[1..-2]
      end

      if search_vars && (vars = find_vars(value))
        @vars[env_key(key)] = vars
      end

      [key, value]
    end

    private def set_env(key : String, value : String, overwrite : Bool)
      env_key = env_key(key)
      key_existes = @env.has_key?(env_key)
      if !key_existes || (key_existes && overwrite)
        @env[env_key] = value
      end
    end

    private def env_key(key : String)
      key.underscore.upcase
    end

    private def replace_variables
      @vars.each do |key, vars|
        replaced = false

        value = @env[key]
        vars.each do |var|
          var_key = var[1..-1]
          if var_key[0] == '{' && var_key[-1] == '}'
            var_key = var_key[1..-2]
          end

          if var_value = @env[env_key(var_key)]?
            value = value.sub(var, var_value)
            replaced = true
          end
        end

        @env[key] = value if replaced
      end
    end

    private def find_vars(value : String)
      return unless starts_at = value.index('$')
      vars = value[(starts_at + 1)..-1].split('$')
      Array(String).new.tap do |obj|
        vars.each do |var|
          brace_open = false
          value = String.build do |io|
            io << '$'
            var.each_char do |char|
              brace_open = true if char == '{'
              io << char if var_name_valid?(char)
              if brace_open && char == '}'
                break
              end
            end
          end

          obj << value
        end
      end
    end

    private def var_name_valid?(char)
      ord = char.ord
      (ord >= 48 && ord <= 57) ||
      (ord >= 65 && ord <= 90) ||
      (ord >= 97 && ord <= 122) ||
      [95, 123, 125].includes?(ord)
    end

    private def extract_expression(raw) : String?
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
