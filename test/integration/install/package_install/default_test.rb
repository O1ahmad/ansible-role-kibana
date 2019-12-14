title "Kibana package installation suite"

describe user('kibana') do
  it { should exist }
end

describe group('kibana') do
  it { should exist }
end

describe package('kibana') do
  it { should be_installed }
end
