require "./poncho/*"

module Poncho
  def self.from_file(file : String)
    Parser.from_file(file)
  end

  def self.parse(raw : String | IO)
    Parser.new(raw)
  end
end
