require "./spec_helper"

describe Poncho do
  describe "loads from file" do
    describe ".from_file" do
      env = Poncho.from_file(fixture_path("parse_sample.env"))
      it_equal_group env
    end

    describe "#new" do
      env = Poncho.parse File.open(fixture_path("parse_sample.env"))
      env.parse
      it_equal_group env
    end
  end

  describe "loads from raw string" do
    env = Poncho.parse load_fixture("parse_sample.env")
    env.parse
    it_equal_group env
  end

  describe "gets" do
    describe "non-overwrite the key" do
      env = Poncho.from_file(fixture_path("overwrite.env"))
      it_equal env, "PONCHO_NAME", "foo"
    end

    describe "overwrite the key" do
      env = Poncho.from_file(fixture_path("overwrite.env"), true)
      it_equal env, "PONCHO_NAME", "overwrite"
    end

    describe "#to_h" do
      env = Poncho.from_file(fixture_path("parse_sample.env"))
      env.to_h.should be_a Hash(String, String)
      it_equal_group env.to_h
    end
  end
end
