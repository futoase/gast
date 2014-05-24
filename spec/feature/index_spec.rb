describe "the index page", type: :feature do
  it "get index in" do
    visit '/'

    get_languages.each_with_index do |language, idx|
      find(:xpath, "//select/option[#{idx+1}]").text eq language
    end
  end
  :qa
end
