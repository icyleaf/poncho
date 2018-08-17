require "../spec_helper"

private def clean_env(filename)
  env = Poncho::Parser.from_file(fixture_path(filename))
  env.each do |key, _|
    ENV.delete(key)
  end
end

describe Poncho::Loader do
  describe "loads" do
    describe "sample data" do
      loader = Poncho::Loader.new(fixture_path("parse_sample.env"))
      # loader.load
      # it_equal_group ENV
      # clean_env("parse_sample.env")
    end

    # describe "non-overwrite data" do
    #   loader = Poncho::Loader.new(fixture_path("overwrite.env"))
    #   loader.load
    #   it_equal ENV, "NAME", "foo"
    #   clean_env("overwrite.env")
    # end

    # describe "overwrite data" do
    #   loader = Poncho::Loader.new(fixture_path("overwrite.env"))
    #   loader.load!

    #   it_equal ENV, "NAME", "new"
    #   clean_env("overwrite.env")
    # end
  end
end
