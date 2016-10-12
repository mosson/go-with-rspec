module GoBuild
  extend self

  def build(file)
    process = ChildProcess.build('go', 'build', file)
    err = Tempfile.new('stderr-spec')
    process.io.stderr = err
    process.start
    process.poll_for_exit(10)
    err.rewind
    unless process.exit_code == 0
      fail err.read
    end
  end
end
