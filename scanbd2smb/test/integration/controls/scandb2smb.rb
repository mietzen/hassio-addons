title "scandb2smb Integration Test"

describe processes(Regexp.new("scandb")) do
  it { should exist }
  its('users') { should include 'root' }
  its('pids') { should cmp "1"}
end
