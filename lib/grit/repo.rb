module Grit
  
  class Repo
    # The path of the git repo as a String
    attr_accessor :path
  
    # Create a new Repo instance
    #   +path+ is the path to either the root git directory or the bare git repo
    #
    # Examples
    #   g = Repo.new("/Users/tom/dev/grit")
    #   g = Repo.new("/Users/tom/public/grit.git")
    #
    # Returns Repo
    def initialize(path)
      if File.exist?(File.join(path, '.git'))
        self.path = File.join(path, '.git')
      elsif File.exist?(path) && path =~ /\.git$/
        self.path = path
      else
        raise InvalidGitRepositoryError.new(path) unless File.exist?(path)
      end
    end
  
    # Return the project's description. Taken verbatim from REPO/description
    #
    # Returns String
    def description
      File.open(File.join(self.path, 'description')).read.chomp
    end
  
    # Return an array of Head objects representing the available heads in
    # this repo
    #
    # Returns Grit::Head[]
    def heads
      output = Git.for_each_ref(
                 "--sort=-committerdate",
                 # "--count=1",
                 "--format='%(objectname) %(refname) %(subject)%00%(committer)'",
                 "refs/heads")
                 
      heads = []
    
      output.split("\n").each do |line|
        heads << Head.from_string(line)
      end
    
      heads
    end
  end # Repo
  
end # Grit