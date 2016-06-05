# For SunSpot's test configuration
# (https://github.com/sunspot/sunspot/wiki/RSpec-and-Sunspot)
Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
