# frozen_string_literal: true

require 'builder'
require 'uglifier'

Time.zone = 'America/Los_Angeles'

activate :aria_current
activate :autoprefixer
activate :sprockets
activate :inline_svg

set :js_dir, 'assets/javascripts'
set :css_dir, 'assets/stylesheets'
set :fonts_dir, 'assets/fonts'
set :images_dir, 'assets/img'

set :markdown,
    autolink: true,
    fenced_code_blocks: true,
    footnotes: true,
    highlight: true,
    smartypants: true,
    strikethrough: true,
    tables: true,
    with_toc_data: true
set :markdown_engine, :redcarpet

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :blog do |blog|
  blog.name = 'blog'
  blog.prefix = 'post'
  blog.permalink = '{title}.html'
  blog.sources = '{title}.html'
  blog.summary_length = 250
  blog.default_extension = '.html.erb'
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = 'page/{num}'
  blog.layout = '/layouts/blog'
end

configure :development do
  activate :dotenv, env: '.env.development'
  activate :livereload do |reload|
    reload.no_swf = true
  end
  set :debug_assets, true
  activate :relative_assets
  require 'rack/middleman/optional_html'
  use ::Rack::OptionalHtml,
      root: 'source',
      urls: %w('/'),
      try: %w('.html index.html /index.html')
end

configure :production do
  activate :dotenv, env: '.env.production'
  activate :gzip
  activate :minify_css, inline: true
  activate :minify_javascript, inline: true,
                               compressor: Uglifier.new(mangle: false,
                                                        comments: :none)
  activate :minify_html, remove_comments: false
  activate :asset_hash, ignore: %r{^assets/static/.*}
end
