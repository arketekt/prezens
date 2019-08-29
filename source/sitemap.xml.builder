# frozen_string_literal: true

xml.instruct!
xml.urlset 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  sitemap
    .resources
    .select { |page| page.path =~ /\.html/ }
    .select { |page| !page.data.noindex }
    .each do |page|
    xml.url do
      xml.loc(URI.join(ENV.fetch('URL'),
                       page.url.chomp('index.html').chomp('.html'))).to_s
      xml.lastmod Date.today.to_time.iso8601
      xml.changefreq page.data.changefreq || 'monthly'
      xml.priority page.data.priority || '0.5'
    end
  end
end