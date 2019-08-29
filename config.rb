# frozen_string_literal: true

require 'builder'
require 'uglifier'

Time.zone = 'UTC'

activate :aria_current
activate :autoprefixer
activate :sprockets
activate :inline_svg

set :fonts_dir, 'assets/fonts'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :css_dir, 'assets/stylesheets'

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :blog do |blog|
  blog.name = 'blog'
  blog.prefix = 'post'
  blog.permalink = '{title}.html'
  blog.sources = '{title}.html'
  blog.summary_length = 250
  blog.default_extension = '.md'
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = 'page/{num}'
  blog.layout = '/layouts/article_layout'
end

configure :development do
  activate :dotenv, env: '.env.development'
  activate :livereload do |reload|
    reload.no_swf = true
  end
  set :debug_assets, true
  # activate :relative_assets
  require 'rack/middleman/optional_html'
  use ::Rack::OptionalHtml,
      root: 'source/',
      urls: %w[/],
      try: %w[.html index.html /index.html]
end

configure :staging do
  activate :dotenv, env: '.env.staging'
  activate :gzip
  activate :minify_css, inline: true
  activate :minify_javascript, inline: true,
                               compressor: Uglifier.new(mangle: false,
                                                        comments: :none)
  activate :minify_html, remove_comments: false
  activate :asset_hash, ignore: %r{static\/.*|fonts\/.*} # exclude files in static and fonts folder from asset_hash
end

configure :production do
  activate :dotenv, env: '.env.production'
  activate :gzip
  activate :minify_css, inline: true
  activate :minify_javascript, inline: true,
                               compressor: Uglifier.new(mangle: false,
                                                        comments: :none)
  activate :minify_html, remove_comments: false
  activate :asset_hash, ignore: %r{static\/.*|fonts\/.*} # exclude files in static and fonts folder from asset_hash
end

activate :deploy do |deploy|
  deploy.build_before     = true
  deploy.deploy_method    = :rsync
  deploy.clean            = true
  deploy.host             = 'dikaio@165.225.157.75'
  deploy.port             = '2222'
  deploy.path             = '/srv/www/html/'
end