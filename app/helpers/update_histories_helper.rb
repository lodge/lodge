require 'diffy'
module UpdateHistoriesHelper
  def diff(old, new)
    diff = Diffy::Diff.new(
      old, new,
      include_plus_and_minus_in_html: true,
      allow_empty_diff: false
    ).to_s(:html_simple).html_safe

    return diff.blank? ? new : diff
  end
end
