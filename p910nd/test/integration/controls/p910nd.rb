title "p910nd Integration Test"

describe processes("p910nd") do
  it { should exist }
  its('users') { should include 'root' }
end

describe processes("sh") do
  its('pids') { should include 1 }
end

describe port(9100) do
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end
