require 'spec_helper'

describe WPScan::Finders::Plugins::UrlsInHomepage do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url) }
  let(:url)        { 'http://wp.lab/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugins', 'urls_in_homepage') }

  it_behaves_like 'App::Finders::WpItems::URLsInHomepage' do
    let(:type)                { 'plugins' }
    let(:uniq_links)          { true }
    let(:uniq_codes)          { true }
    let(:expected_from_links) { (1..4).map { |i| "dl-#{i}" } }
    let(:expected_from_codes) { (1..6).map { |i| "dc-#{i}" } }
  end

  describe '#passive' do
    before do
      stub_request(:get, finder.target.url).to_return(body: File.read(File.join(fixtures, 'found.html')))
      expect(finder.target).to receive(:content_dir).at_least(1).and_return('wp-content')
    end

    # TODO: Put it back when Dynamic Finder Xpath done
    # findings from items_from_links & items_from_code are ignored here
    # as tested in the above
    # it 'contains the plugins found from the #xpath_matches' do
    #  expect(finder.passive.map(&:slug)).to include(*WPScan::DB::DynamicPluginFinders.urls_in_page.keys)
    # end
  end
end
