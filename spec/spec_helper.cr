require "spec"
require "../src/poncho"

def it_equal_group(data = nil, file = __FILE__, line = __LINE__)
  it_equal data, "BLANK", "", file, line
  it_equal data, "STR", "foo", file, line
  it_equal data, "STR_WITH_COMMENTS", "bar", file, line
  it_equal data, "STR_WITH_HASH_SYMBOL", "abc#123", file, line
  it_equal data, "INT", "42", file, line
  it_equal data, "FLOAT", "33.3", file, line
  it_equal data, "BOOL_TRUE", "1", file, line
  it_equal data, "BOOL_FALSE", "0", file, line
  it_equal data, "PROXIED", "{{STR}}", file, line
  it_equal data, "SINGLE_QUOTES", "single_quotes", file, line
  it_equal data, "DOUBLE_QUOTES", "double_quotes", file, line
  it_equal data, "EXPAND_NEWLINES", "expand\nnewlines", file, line
  it_equal data, "DONT_EXPAND_NEWLINES_1", "dontexpand\\nnewlines", file, line
  it_equal data, "DONT_EXPAND_NEWLINES_2", "dontexpand\\nnewlines", file, line
  it_equal data, "LOWER_CASE", "lower_case", file, line
  it_equal data, "CAMEL_CASE", "camelCase", file, line
  it_equal data, "LIST_STR", "foo,bar", file, line
  it_equal data, "LIST_STR_WITH_SPACES", " foo,  bar", file, line
  it_equal data, "LIST_INT", "1,2,3", file, line
  it_equal data, "LIST_INT_WITH_SPACES", "1,  2,3", file, line
  it_equal data, "DICT_STR", "key1=val1, key2=val2", file, line
  it_equal data, "DICT_INT", "key1=1, key2=2", file, line
  it_equal data, "JSON", %Q{{"foo": "bar", "baz": [1, 2, 3]}}, file, line
  it_equal data, "URL", "https://example.com/path?query=1", file, line
  it_equal data, "UNDEFINED_EXPAND", "$TOTALLY_UNDEFINED_ENV_KEY", file, line
  it_equal data, "EQUAL_SIGNS", "equals==", file, line
  it_equal data, "RETAIN_INNER_QUOTES", %Q{{"foo": "bar"}}, file, line
  it_equal data, "RETAIN_INNER_QUOTES_AS_STRING", %Q{{"foo": "bar"}}, file, line
  it_equal data, "INCLUDE_SPACE", "some spaced out string", file, line
  it_equal data, "USERNAME", "user@example.com", file, line
  it_equal data, "SINGLE_VARIABLE", "foo", file, line
  it_equal data, "MULTIPLE_VARIABLE1", "foo42", file, line
  it_equal data, "MULTIPLE_VARIABLE2", "foo$INT1", file, line
  it_equal data, "SINGLE_BLOCK_VARIABLE", "foo42", file, line
  it_equal data, "SINGLE_QUOTES_VARIABLE", "hello $STR!", file, line
  it_equal data, "DOUBLE_QUOTES_VARIABLE", "hello foo, my email is user@example.com", file, line
end

def it_equal(data, key, expected, file = __FILE__, line = __LINE__)
  it "gets #{key}", file, line do
    data[key].should eq expected
  end
end

def clean_env(filename)
  data = Poncho::Parser.from_file fixture_path(filename)
  data.each do |key, _|
    ENV.delete(key)
  end
end

def load_fixture(filename : String)
  File.read_lines(fixture_path(filename)).join("\n")
end

def fixture_path
  File.expand_path("../fixtures/", __FILE__)
end

def fixture_path(filename : String)
  File.join(fixture_path, filename)
end
