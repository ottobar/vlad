# :scm should define checkout, export and revision instance methods and set :source
class Vlad::NoScm
  set :source, Vlad::NoScm.new

  def checkout(revision, destination)
    run "echo 'Nothing to do to checkout the source code'"
  end

  def export(source, destination)
    run "echo 'Nothing to do to export the source code'"
  end

  def revision(revision)
    revision
  end

end
