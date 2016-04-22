require 'spec_helper'

describe PlainRouter do
  it 'has a version number' do
    expect(PlainRouter::VERSION).not_to be nil
  end

  it 'should do root dispatch' do
    router = PlainRouter.new
    router.add('/', 'dispatch_root')
    expect(router.match('/')).to eq 'dispatch_root'
  end

  it 'should do entrylist dispatch' do 
    router = PlainRouter.new
    router.add('/entrylist', 'dispatch_entrylist')
    expect(router.match('/entrylist')).to eq 'dispatch_entrylist'
  end

  it 'should do user dispatch' do
    router = PlainRouter.new
    router.add('/:user', 'dispatch_user')
    expect(router.match('/gfx')).to eq ['dispatch_user', {'user' => 'gfx'}]
  end

  it 'should do year-month dispatch' do
    router = PlainRouter.new
    router.add('/:user/{year}', 'dispatch_year')
    router.add('/:user/{year}/{month:\d+}', 'dispatch_month')
    expect(
      router.match('/gfx/2013/12')
    ).to eq ['dispatch_month',{'user' => 'gfx', 'year' => '2013', 'month' => '12' }]
  end
  
end
