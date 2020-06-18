require "./spec_helper"

describe Poncho do
  describe ".parse" do
    describe "loads from file" do
      describe ".from_file" do
        env = Poncho.from_file fixture_path("parse_sample.env")
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
        env = Poncho.from_file fixture_path("overwrite.env")
        it_equal env, "PONCHO_NAME", "foo"
      end

      describe "overwrite the key" do
        env = Poncho.from_file fixture_path("overwrite.env"), true
        it_equal env, "PONCHO_NAME", "overwrite"
      end

      describe "#to_h" do
        env = Poncho.from_file fixture_path("parse_sample.env")
        env.to_h.should be_a Hash(String, String)
        it_equal_group env.to_h
      end
    end
  end

  describe ".load" do
    describe "loads single file" do
      describe "disable overwrite" do
        describe "with sample file" do
          Poncho.load fixture_path("parse_sample.env")
          it_equal_group ENV.to_h
          clean_env "parse_sample.env"
        end

        describe "with overwrite file" do
          Poncho.load fixture_path("overwrite.env")
          it_equal ENV.to_h, "PONCHO_NAME", "foo"
          clean_env "overwrite.env"
        end

        describe "with file and test env" do
          Poncho.load fixture_path("app.env"), env: "test"
          it_equal ENV.to_h, "PONCHO_NAME", "poncho"
          clean_env "app.env.test.local"
        end

        describe "with path" do
          Poncho.load fixture_path("load_from_path")
          it_equal ENV.to_h, "PONCHO_FROM", ".env"
          it_equal ENV.to_h, "PONCHO_PATH", "/Users/icyleaf/workspaces/poncho"
          clean_env "load_from_path/.env"
          clean_env "load_from_path/.env.local"
        end

        describe "with path and test env" do
          Poncho.load fixture_path("load_from_path"), env: "test"
          it_equal ENV.to_h, "PONCHO_FROM", ".env"
          it_equal ENV.to_h, "PONCHO_URL", "localhost.test"
          it_equal ENV.to_h, "PONCHO_MYSQL_HOST", "localhost.test"
          it_equal ENV.to_h, "PONCHO_MYSQL_DATABASE", "poncho_test"
          it_equal ENV.to_h, "PONCHO_PATH", "/home/ci/github/poncho"
          clean_env "load_from_path/.env"
          clean_env "load_from_path/.env.test"
        end

        describe "with path and production env" do
          Poncho.load fixture_path("load_from_path"), env: "production"
          it_equal ENV.to_h, "PONCHO_FROM", ".env"
          it_equal ENV.to_h, "PONCHO_URL", "poncho.example.com"
          it_equal ENV.to_h, "PONCHO_MYSQL_HOST", "poncho.example.com"
          it_equal ENV.to_h, "PONCHO_MYSQL_DATABASE", "poncho_production"
          it_equal ENV.to_h, "PONCHO_MYSQL_USER", "poncho"
          it_equal ENV.to_h, "PONCHO_MYSQL_PASSWORD", "p@nchO"
          it_equal ENV.to_h, "PONCHO_PATH", "/Users/icyleaf/workspaces/poncho"
          clean_env "load_from_path/.env"
          clean_env "load_from_path/.env.production.local"
        end
      end
    end

    describe "enable overwrite" do
      describe "with overwrite file" do
        Poncho.load! fixture_path("overwrite.env")
        it_equal ENV.to_h, "PONCHO_NAME", "overwrite"
        clean_env "overwrite.env"
      end

      describe "with path" do
        Poncho.load! fixture_path("load_from_path")
        it_equal ENV.to_h, "PONCHO_FROM", ".local"
        it_equal ENV.to_h, "PONCHO_PATH", "/Users/icyleaf/workspaces/poncho"
        clean_env "load_from_path/.env"
        clean_env "load_from_path/.env.local"
      end

      describe "with path and env" do
        Poncho.load! fixture_path("load_from_path"), env: "test"
        it_equal ENV.to_h, "PONCHO_FROM", ".local"
        it_equal ENV.to_h, "PONCHO_URL", "localhost.test"
        it_equal ENV.to_h, "PONCHO_MYSQL_HOST", "localhost.test"
        it_equal ENV.to_h, "PONCHO_MYSQL_DATABASE", "poncho_test"
        it_equal ENV.to_h, "PONCHO_PATH", "/Users/icyleaf/workspaces/poncho"
        clean_env "load_from_path/.env"
        clean_env "load_from_path/.env.test"
      end

      describe "with path and production env" do
        Poncho.load! fixture_path("load_from_path"), env: "production"
        it_equal ENV.to_h, "PONCHO_FROM", ".production.local"
        it_equal ENV.to_h, "PONCHO_URL", "poncho.example.com"
        it_equal ENV.to_h, "PONCHO_MYSQL_HOST", "poncho.example.com"
        it_equal ENV.to_h, "PONCHO_MYSQL_DATABASE", "poncho_production"
        it_equal ENV.to_h, "PONCHO_MYSQL_USER", "poncho"
        it_equal ENV.to_h, "PONCHO_MYSQL_PASSWORD", "p@nchO"
        it_equal ENV.to_h, "PONCHO_PATH", "/Users/icyleaf/workspaces/poncho"
        clean_env "load_from_path/.env"
        clean_env "load_from_path/.env.production.local"
      end
    end

    describe "loads multiple files" do
      describe "with non-overwrite" do
        Poncho.load fixture_path("overwrite.env"), fixture_path("app.env.test.local"), env: "development"
        it_equal ENV.to_h, "PONCHO_NAME", "foo"
        it_equal ENV.to_h, "PONCHO_ENV", "test"
        clean_env "overwrite.env"
        clean_env "app.env.test.local"
      end

      describe "with overwrite" do
        Poncho.load! fixture_path("overwrite.env"), fixture_path("app.env.test.local"), env: "development"
        it_equal ENV.to_h, "PONCHO_NAME", "poncho"
        it_equal ENV.to_h, "PONCHO_ENV", "test"
        clean_env "overwrite.env"
        clean_env "app.env.test.local"
      end

      describe "with env" do
        Poncho.load! fixture_path("load_from_path/.env"), fixture_path("load_from_path/.env.test"), env: "production"
        it_equal ENV.to_h, "PONCHO_FROM", ".test"
        it_equal ENV.to_h, "PONCHO_URL", "localhost.test"
        it_equal ENV.to_h, "PONCHO_MYSQL_HOST", "localhost.test"
        it_equal ENV.to_h, "PONCHO_MYSQL_DATABASE", "poncho_test"
        it_equal ENV.to_h, "PONCHO_PATH", "/home/ci/github/poncho"
        clean_env "load_from_path/.env"
        clean_env "load_from_path/.env.test"
      end
    end
  end
end
