title "AppDaemon Store Integration Test"

describe file("/run.sh") do
  it { should exist }
  it { should be_executable }
end

describe file("/opt/appdaemon-store-venv/bin/appdaemon-store") do
  it { should exist }
  it { should be_executable }
end

describe processes(Regexp.new("appdaemon-store")) do
  it { should exist }
end

describe port(8099) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
end
