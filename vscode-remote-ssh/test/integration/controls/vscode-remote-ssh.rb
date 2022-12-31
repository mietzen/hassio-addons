title "VS Code Remote SSH Integration Test"

describe processes(Regexp.new("sshd")) do
  it { should exist }
  its('users') { should include 'root' }
  its('pids') { should cmp "1"}
end
describe port(22) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end
