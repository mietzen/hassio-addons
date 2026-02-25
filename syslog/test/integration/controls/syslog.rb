title "syslog Integration Test"

describe command("python3 -c 'import logging; import logging.handlers; print(\"ok\")'") do
  its('stdout') { should match /ok/ }
  its('exit_status') { should eq 0 }
end

describe file("/journal2syslog.py") do
  it { should exist }
end

describe file("/run.sh") do
  it { should exist }
  it { should be_executable }
end
