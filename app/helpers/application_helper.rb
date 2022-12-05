module ApplicationHelper
  def nav_link(path, *args, **kwargs, &block)
    content_tag(:li, class: nav_link_class(path)) do
      link_to(path, *args, class: "nav-link", **kwargs, &block)
    end
  end

  private
  def nav_link_class(path)
    if current_page?(path)
      "nav-item active"
    else
      "nav-item"
    end
  end
end
