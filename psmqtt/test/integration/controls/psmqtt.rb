title "psmqtt Integration Test"

describe processes(Regexp.new("psmqtt")) do
  it { should exist }
end
