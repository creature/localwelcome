require 'redcarpet/render_strip'

module ApplicationHelper
  def render_prompt_banner(heading, link_text, link_target, explanation, opts = {})
    classes = %w{banner bg-warning text-warning} << opts.fetch(:class, "")
    content_tag :div, class: classes.join(" ") do
      content_tag :div, class: "container" do
        content_tag(:h1, "#{heading} &ndash; ".html_safe + link_to("#{link_text} &raquo;".html_safe, link_target)) +
        content_tag(:p, explanation)
      end
    end
  end

  # Render a Markdown string as HTML
  def render_markdown(text)
    markdown_parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, filter_html: true)
    markdown_parser.render(text).html_safe
  end

  # Strip out any Markdown formatting and return a plaintext version
  def render_markdown_as_text(text)
    markdown_parser = Redcarpet::Markdown.new(Redcarpet::Render::StripDown, filter_html: true)
    markdown_parser.render(text)
  end

  # Is this a web request that we should respond to with the Arabic locale/translations?
  def arabic_request?
    "ar" == request.subdomains.first
  end

  # Generate a link to the English-language version of this page.
  def english_current_url
    "//" + request.domain + request.fullpath
  end

  # Generate a link to the Arabic-language version of this page.
  def arabic_current_url
    if arabic_request?
      return request.original_url
    else
      "//ar." + request.domain + request.fullpath
    end
  end
end
