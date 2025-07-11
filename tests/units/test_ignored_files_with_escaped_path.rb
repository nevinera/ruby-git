# frozen_string_literal: true

require 'test_helper'

# Test diff when the file path has to be quoted according to core.quotePath
# See https://git-scm.com/docs/git-config#Documentation/git-config.txt-corequotePath
#
class TestIgnoredFilesWithEscapedPath < Test::Unit::TestCase
  def test_ignored_files_with_non_ascii_filename
    in_temp_dir do |_path|
      create_file('README.md', '# My Project')
      `git init`
      `git add .`
      `git config --local core.safecrlf false` if Gem.win_platform?
      `git commit -m "First Commit"`
      create_file('my_other_file_☠', "First Line\n")
      create_file('.gitignore', 'my_other_file_☠')
      files = Git.open('.').ignored_files
      assert_equal(['my_other_file_☠'].sort, files)
    end
  end
end
