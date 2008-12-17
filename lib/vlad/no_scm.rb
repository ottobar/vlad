# :scm should define checkout, export and revision instance methods and set :source
class Vlad::NoScm
  set :source, Vlad::NoScm.new

  def checkout(revision, destination)
    puts "Nothing to do to checkout the source code"
    ""
  end

  def export(source, destination)
    puts "Nothing to do to export the source code"
    "mkdir #{destination}"
  end

  def revision(revision)
    revision
  end

end
