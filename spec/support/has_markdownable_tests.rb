RSpec.shared_examples "having markdownable" do |attr|
  using RSpec::Parameterized::TableSyntax

  setter = "#{attr}="
  attr_html = "#{attr}_html"
  attr_html_with_toc = "#{attr}_html_with_toc"

  subject (:model) { described_class.new }

  describe attr_html do

    where(:md, :html) do
      '#title'                    | '<h1 id="title">title</h1>'
      "```ruby:name.rb\n<a>\n```" | /<div class="code-filename">name\.rb/
      "```ruby:name.rb\n<a>\n```" | /class="CodeRay".*<pre>&lt;a&gt;/m
      "foo\nbar"                  | /foo<br>.*bar/m
    end

    with_them do
      before { model.send setter, md }
      its(attr_html) { should match html }
    end
  end

  describe attr_html_with_toc do
    where(:md, :html) do
      "#h1\n##h2" | /<li>.*h1.*<ul>.*<li>.*h2/m
    end

    with_them do
      before { model.send setter, md }
      its(attr_html_with_toc) { should match html }
    end
  end
end
