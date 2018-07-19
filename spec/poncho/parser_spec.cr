require "../spec_helper"

private def it_equal(env, key, expected, file = __FILE__, line = __LINE__)
  it "gets #{key}", file, line do
    env[key].should eq expected
  end
end

private def spec_group(env)
  it_equal env, "BLANK", ""
  it_equal env, "STR", "foo"
  it_equal env, "STR_WITH_COMMENTS", "bar"
  it_equal env, "STR_WITH_HASH_SYMBOL", "abc#123"
  it_equal env, "INT", "42"
  it_equal env, "FLOAT", "33.3"
  it_equal env, "BOOL_TRUE", "1"
  it_equal env, "BOOL_FALSE", "0"
  it_equal env, "PROXIED", "{{STR}}"
  it_equal env, "SINGLE_QUOTES", "single_quotes"
  it_equal env, "DOUBLE_QUOTES", "double_quotes"
  it_equal env, "EXPAND_NEWLINES", "expand\nnewlines"
  it_equal env, "DONT_EXPAND_NEWLINES_1", "dontexpand\\nnewlines"
  it_equal env, "DONT_EXPAND_NEWLINES_2", "dontexpand\\nnewlines"
  it_equal env, "LOWER_CASE", "lower_case"
  it_equal env, "CAMEL_CASE", "camelCase"
  it_equal env, "LIST_STR", "foo,bar"
  it_equal env, "LIST_STR_WITH_SPACES", " foo,  bar"
  it_equal env, "LIST_INT", "1,2,3"
  it_equal env, "LIST_INT_WITH_SPACES", "1,  2,3"
  it_equal env, "DICT_STR", "key1=val1, key2=val2"
  it_equal env, "DICT_INT", "key1=1, key2=2"
  it_equal env, "JSON", %Q{{"foo": "bar", "baz": [1, 2, 3]}}
  it_equal env, "URL", "https://example.com/path?query=1"
  it_equal env, "UNDEFINED_EXPAND", "$TOTALLY_UNDEFINED_ENV_KEY"
  it_equal env, "EQUAL_SIGNS", "equals=="
  it_equal env, "RETAIN_INNER_QUOTES", %Q{{"foo": "bar"}}
  it_equal env, "RETAIN_INNER_QUOTES_AS_STRING", %Q{{"foo": "bar"}}
  it_equal env, "INCLUDE_SPACE", "some spaced out string"
  it_equal env, "USERNAME", "user@example.com"
end

describe Poncho::Parser do
  describe ".from_file" do
    env = Poncho::Parser.from_file(File.join(fixture_path, "sample.env"))
    spec_group env
  end

  describe "#new" do
    describe "from raw string" do
      env = Poncho::Parser.new load_fixture("sample.env")
      spec_group env
    end

    describe "from file" do
      env = Poncho::Parser.new File.open(File.join(fixture_path, "sample.env"))
      spec_group env
    end
  end
end
