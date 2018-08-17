require "./poncho/*"

module Poncho
  extend self

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
