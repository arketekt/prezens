# frozen_string_literal: true

module ApplicationHelpers
  def markdown(contents)
    renderer = Redcarpet::Render::HTML
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      fenced_code_blocks: true,
      footnotes: true,
      highlight: true,
      smartypants: true,
      strikethrough: true,
      tables: true,
      with_toc_data: true
    )
    markdown.render(contents)
  end

  def current_url
    File.join(ENV['URL'], current_page.url.chomp('index.html')
                                          .chomp('.html')
                                          .chomp('/'))
  end
end