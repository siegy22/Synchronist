module SyncsHelper
  def sync_progress_bar(sync)
    css_class = "progress-bar"
    css_class << " bg-danger" if sync.errored?
    css_class << " bg-success" if sync.succeeded?

    content_tag :div, class: "progress" do
      content_tag(
        :div,
        "#{sync.progress.round}%",
        style: "width: #{sync.progress}%",
        class: css_class,
        aria: { valuenow: sync.progress, valuemin: 0, valuemax: 100 },
        role: "progressbar"
      )
    end
  end
end
