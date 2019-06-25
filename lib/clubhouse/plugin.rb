module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Teng Siong Ong/danger-clubhouse
  # @tags monday, weekends, time, rattata
  #
  # This plugin will detect stories from clubhouse and link to them.
  #
  # @example Customize the clubhouse organization and check for stories to link to them.
  #
  #          clubhouse.organization = 'organization'
  #          clubhouse.link_stories!
  #
  # @see  siong1987/danger-clubhouse
  # @tags clubhouse
  class DangerClubhouse < Plugin
    # The clubhouse organization name, you must set this!
    #
    # @return   [String]
    attr_accessor :organization

    # Check the branch, commit messages, comments and description to find clubhouse stories to link to.
    #
    # @return [void]
    def link_stories!
      story_ids = []
      story_ids += find_story_ids_in_branch
      story_ids += find_story_ids_in_commits
      story_ids += find_story_ids_in_description
      story_ids += find_story_ids_in_comments
    
      post!(story_ids) unless story_ids.empty?
    end

    # Find clubhouse story ids in the body
    #
    # @return [Array<String>]
    def find_story_ids(body)
      body.scan(/ch(\d+)/).flatten
    end
    
    # Find clubhouse story id in the body
    #
    # @return [String, nil]
    def find_story_id(body)
      find_story_ids(body).first
    end

    private

    def find_story_ids_in_branch
      find_story_ids(github.branch_for_head) if defined? @dangerfile.github
    end

    def find_story_ids_in_commits
      messages.map { |message| find_story_ids(message) }.flatten
    end
    
    def find_story_ids_in_description
      find_story_ids(github.pr_body) if defined? @dangerfile.github
    end

    def find_story_ids_in_comments
      if defined? @dangerfile.github
        github
          .api
          .issue_comments(github.pr_json.head.repo.id, github.pr_json.number)
          .map { |comment| find_story_ids(comment.body) }
          .flatten
      end
    end

    def post!(story_ids)
      message = "### Clubhouse Stories\n\n"
      story_ids.each do |id|
        message << "* [https://app.clubhouse.io/#{organization}/story/#{id}](https://app.clubhouse.io/#{organization}/story/#{id}) \n"
      end
      markdown message
    end

    def messages
      git.commits.map(&:message)
    end
  end
end
