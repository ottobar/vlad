class Vlad::Git

  set :source, Vlad::Git.new
  set :git_cmd, "git"

  ##
  # Returns the command that will check out +revision+ from the
  # code repo into directory +destination+.  +revision+ can be any
  # SHA1 or equivalent (e.g. branch, tag, etc...)

  def checkout(revision, destination)
    destination = 'repo' if destination == '.'
    revision = 'HEAD' if revision =~ /head/i

    [ "rm -rf #{destination}",
      "#{git_cmd} clone #{code_repo} #{destination}",
      "cd #{destination}",
      "#{git_cmd} checkout -f -b deployed-#{revision} #{revision}",
      "#{git_cmd} submodule init",
      "#{git_cmd} submodule update"
    ].join(" && ")
  end

  ##
  # Returns the command that will export +revision+ from the code repo into
  # the directory +destination+.

  def export(revision, destination)
    revision = 'HEAD' if revision == "."

    [ "mkdir -p #{destination}",
      "#{git_cmd} archive --format=tar #{revision} | (cd #{destination} && tar xf -)"
    ].join(" && ")
  end

  ##
  # Returns a command that maps human-friendly revision identifier +revision+
  # into a git SHA1.

  def revision(revision)
    revision = 'HEAD' if revision =~ /head/i

    "`#{git_cmd} rev-parse #{revision}`"
  end
end
