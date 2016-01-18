module ApplicationHelper
  def render_admin_prompt(heading, link_text, link_target, explanation)
    content_tag :div, class: "banner bg-warning text-warning" do
      content_tag :div, class: "container" do
        content_tag(:h1, "#{heading} &ndash; ".html_safe + link_to("#{link_text} &raquo;".html_safe, link_target)) +
        content_tag(:p, explanation)
      end
    end
  end

  def arabic_request?
    "ar" == request.subdomains.first
  end
end
