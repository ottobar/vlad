class Vlad::Mercurial
  set :source, Vlad::Mercurial.new

  ##
  # Returns the command that will check out +revision+ from the code repo 
  # into directory +destination+

  def checkout(revision, destination)
    revision = 'tip' if revision =~ /^head$/i
    "hg pull -r #{revision} -R #{destination} #{code_repo}"
  end

  ##
  # Returns the command that will export +revision+ from the code repo into
  # the directory +destination+.

  def export(revision_or_source, destination)
    revision_or_source = 'tip' if revision_or_source =~ /^head$/i
    if revision_or_source =~ /^(\d+|tip)$/i then
      "hg archive -r #{revision_or_source} -R #{code_repo} #{destination}"
    else
      "hg archive -R #{revision_or_source} #{destination}"
    end
  end

  ##
  # Returns a command that maps human-friendly revision identifier +revision+
  # into a subversion revision specification.

  def revision_identifier
    "`hg identify -R #{code_repo} | cut -f1 -d\\ `"
  end
end
