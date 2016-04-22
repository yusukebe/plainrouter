require 'spec_helper'

describe PlainRouter::Method do
  it 'should handle get /' do
    router = PlainRouter::Method.new
    router.add('GET', '/a', 'g')
    router.add('POST', '/a', 'p')
    expect(router.match('GET', '/')).to eq nil
  end
  it 'should handle get /a' do
    router = PlainRouter::Method.new
    router.add('GET', '/a', 'g')
    router.add('POST', '/a', 'p')
    expect(router.match('GET', '/a')).to eq 'g'
  end
  it 'should handle post /a' do
    router = PlainRouter::Method.new
    router.add('GET', '/a', 'g')
    router.add('POST', '/a', 'p')
    expect(router.match('POST', '/a')).to eq 'p'
  end
  it 'should handle head /a' do
    router = PlainRouter::Method.new
    router.add('GET', '/a', 'g')
    router.add('POST', '/a', 'p')
    expect(router.match('HEAD', '/a')).to eq nil
  end
  it 'should handle any /b' do
    router = PlainRouter::Method.new
    router.add('GET', '/a', 'g')
    router.add('POST', '/a', 'p')
    router.add(nil, '/b', 'any')
    expect(router.match('POST', '/b')).to eq 'any'
  end
end
