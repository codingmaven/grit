require File.dirname(__FILE__) + '/helper'

class TestTag < Test::Unit::TestCase
  def setup
    @r = Repo.new(File.join(File.dirname(__FILE__), *%w[dot_git]), :is_bare => true)
  end

  # list_from_string size

  def test_list_from_string_size
    assert_equal 5, @r.tags.size
  end

  # list_from_string

  def test_list_from_string
    tag = @r.tags[1]

    assert_equal 'not_annotated', tag.name
    assert_equal 'ca8a30f5a7f0f163bbe3b6f0abf18a6c83b0687a', tag.commit.id
  end

  # list_from_string_for_signed_tag

  def test_list_from_string_for_signed_tag
    tag = @r.tags[2]

    assert_equal 'v0.7.0', tag.name
    assert_equal '7bcc0ee821cdd133d8a53e8e7173a334fef448aa', tag.commit.id
  end

  # list_from_string_for_annotated_tag

  def test_list_from_string_for_annotated_tag
    tag = @r.tags.first

    assert_equal 'annotated', tag.name
    assert_equal 'ca8a30f5a7f0f163bbe3b6f0abf18a6c83b0687a', tag.commit.id
  end

  # list_from_string_for_packed_tag

  def test_list_from_string_for_packed_tag
    tag = @r.tags[4]

    assert_equal 'packed', tag.name
    assert_equal 'ca8a30f5a7f0f163bbe3b6f0abf18a6c83b0687a', tag.commit.id
  end

  # list_from_string_for_packed_annotated_tag

  def test_list_from_string_for_packed_annotated_tag
    tag = @r.tags[3]

    assert_equal 'packed_annotated', tag.name
    assert_equal '7bcc0ee821cdd133d8a53e8e7173a334fef448aa', tag.commit.id
  end

  # describe_recent_tag

  def test_describe_recent_tag
    assert_equal 'annotated', @r.recent_tag_name
  end

  # describe_recent_tag_with_updates

  def test_describe_recent_tag_with_updates
    assert_equal 'v0.7.0-62-g3fa4e13', @r.recent_tag_name('3fa4e130fa18c92e3030d4accb5d3e0cadd40157')
  end

  # describe_missing_tag

  def test_describe_missing_Tag
    assert_nil @r.recent_tag_name('boom')
  end

  # read_content

  def test_reads_light_tag_message
    tag = @r.tags[1]
    assert_equal 'not_annotated', tag.name
    assert_equal 'added a pure-ruby git library and converted the cat_file commands to use it',
      tag.message
  end

  def test_attempts_to_read_bad_tag_message
    tag = Grit::Tag.new('abc', @r.tags[0].commit)
    assert_equal '', tag.message
  end

  def test_reads_annotated_tag_message
    tag = @r.tags[0]
    assert_equal 'annotated',      tag.name
    assert_equal 'Annotated tag.', tag.message
  end

  def test_reads_annotated_and_packed_tag_message
    tag = @r.tags[3]
    assert_equal 'packed_annotated', tag.name
    assert_equal 'v0.7.0',           tag.message
  end

  # inspect

  def test_inspect
    tag = @r.tags.last

    assert_equal %Q{#<Grit::Tag "#{tag.name}">}, tag.inspect
  end
end
