title "linux2mqtt Integration Test"

describe processes(Regexp.new("linux2mqtt")) do
  it { should exist }
end
