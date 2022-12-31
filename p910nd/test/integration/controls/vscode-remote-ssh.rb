title "p910nd Integration Test"

describe processes(Regexp.new("p910nd")) do
  it { should exist }
  its('users') { should include 'root' }
  its('pids') { should cmp "1"}
end
describe port(9100) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end
