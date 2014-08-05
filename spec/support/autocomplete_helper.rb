module AutocompleteHelper
  def fill_in_autocomplete(selector, value)
    script = %Q{ $('#{selector}').val('#{value}').focus().keypress() }
    page.execute_script(script)
  end

  def choose_autocomplete(text)
    expect(page).to have_css(".tt-suggestion p", text: text, visible: false)
    script = %Q{ $('.tt-suggestion:contains("#{text}")').click() }
    page.execute_script(script)
  end
end

RSpec.configure do |config|
  config.include AutocompleteHelper, type: :feature
end
