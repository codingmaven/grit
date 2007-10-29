require File.dirname(__FILE__) + '/helper'

class TestCommit < Test::Unit::TestCase
  def setup
    @r = Repo.new(GRIT_REPO)
  end
  
  # __bake__
  
  def test_bake
    Git.any_instance.expects(:rev_list).returns(fixture('rev_list_single'))
    @c = Commit.create(@r, :id => '4c8124ffcf4039d292442eeccabdeca5af5c5017')
    @c.author # bake
    
    assert_equal "Tom Preston-Werner", @c.author.name
    assert_equal "tom@mojombo.com", @c.author.email
  end
  
  # diff
  
  def test_diff
    # git diff --full-index 91169e1f5fa4de2eaea3f176461f5dc784796769 > test/fixtures/diff_p
    
    Git.any_instance.expects(:diff).returns(fixture('diff_p'))
    diffs = Commit.diff(@r, 'master')
    
    assert_equal 15, diffs.size
    
    assert_equal '.gitignore', diffs.first.a_path
    assert_equal '.gitignore', diffs.first.b_path
    assert_equal '4ebc8aea50e0a67e000ba29a30809d0a7b9b2666', diffs.first.a_commit.id
    assert_equal '2dd02534615434d88c51307beb0f0092f21fd103', diffs.first.b_commit.id
    assert_equal '100644', diffs.first.mode
    assert_equal false, diffs.first.new_file
    assert_equal false, diffs.first.deleted_file
    assert_equal "--- a/.gitignore\n+++ b/.gitignore\n@@ -1 +1,2 @@\n coverage\n+pkg", diffs.first.diff
    
    assert_equal 'lib/grit/actor.rb', diffs[5].a_path
    assert_equal nil, diffs[5].a_commit
    assert_equal 'f733bce6b57c0e5e353206e692b0e3105c2527f4', diffs[5].b_commit.id
  end
  
  # to_s
  
  def test_to_s
    @c = Commit.create(@r, :id => 'abc')
    assert_equal "abc", @c.to_s
  end
  
  # inspect
  
  def test_inspect
    @c = Commit.create(@r, :id => 'abc')
    assert_equal %Q{#<Grit::Commit "abc">}, @c.inspect
  end
end