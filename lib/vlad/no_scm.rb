# :scm should define checkout, export and revision instance methods and set :source
class Vlad::NoScm
  set :source, Vlad::NoScm.new

  def checkout(revision, destination)
    "echo 'Nothing to do to checkout the source code'"
  end

  def export(source, destination)
    ["echo 'Nothing to do to export the source code'",
     "mkdir #{destination}"
    ].join(" && ")
  end

  def revision(revision)
    revision
  end

end
