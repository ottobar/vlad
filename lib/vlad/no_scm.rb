# :scm should define checkout, export and revision_identifier instance methods and set :source
class Vlad::NoScm
  set :source, Vlad::NoScm.new

  def checkout(revision, destination)
    "echo 'Nothing to do to checkout the source code'"
  end

  def export(source, destination)
    puts "Nothing to do to export the source code"
    "mkdir #{destination}"
  end

  def revision_identifier
    revision
  end

end
