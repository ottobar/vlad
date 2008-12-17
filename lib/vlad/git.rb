class Vlad::Git
  set :revision, "origin/master"
  set :source, Vlad::Git.new
  set :git_cmd, "git"
  set :git_enable_submodules, true

  ##
  # Returns the command that will check out +revision+ from the
  # code repo into directory +destination+.  +revision+ can be any
  # SHA1 or equivalent (e.g. branch, tag, etc...)

  def checkout(revision, destination)
    destination = 'cached-copy' if destination == '.'
    git_revision = revision =~ /head/i ? 'HEAD' : revision

    commands = [ "([ -d #{destination}/.git ] && echo 'Existing repository found' || #{git_cmd} clone #{code_repo} #{destination})",
                 "cd #{destination}",
                 "#{git_cmd} fetch",
                 "#{git_cmd} reset --hard #{git_revision}"
               ]

    if git_enable_submodules
      commands << [ "#{git_cmd} submodule -q init",
                    "#{git_cmd} submodule -q update"
                  ]
    end
    commands.join(" && ")
  end

  ##
  # Returns the command that will export +revision+ from the code repo into
  # the directory +destination+.

  def export(source, destination)
    git_revision = revision =~ /head/i ? 'HEAD' : revision

    [ "mkdir -p #{destination}",
      "#{git_cmd} archive --format=tar #{git_revision} | (cd #{destination} && tar xf -)"
    ].join(" && ")
  end

  ##
  # Returns a command that maps human-friendly revision identifier +revision+
  # into a git SHA1.

  def revision_identifier
    git_revision = revision =~ /head/i ? 'HEAD' : revision

    "`cd #{scm_path}/cached-copy && #{git_cmd} rev-parse #{git_revision}`"
  end

end
