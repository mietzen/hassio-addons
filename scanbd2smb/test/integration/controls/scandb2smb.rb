title "scandb2smb Integration Test"

describe processes(Regexp.new("/usr/sbin/scanbd")) do
  it { should exist }
  its('users') { should include 'saned' }
  its('pids') { should cmp "1"}
end
