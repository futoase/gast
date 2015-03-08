require 'spec_helper'

describe 'the index page', type: :feature do
  it 'get index in' do
    visit '/'

    Gast::LANGUAGES.each_with_index do |language, idx|
      find("//select/option[#{idx+1}]").text eq language
    end
  end

  it 'should be able to selected of multi language' do
    visit '/'

    find('//select').select('python')
    find('//select').text eq 'python'
    find('//select').select('ruby')
    find('//select').text eq 'ruby'
  end

  it 'should be able to write text on the textarea' do
    visit '/'

    find('//textarea').set 'Hello world'
    find('//textarea').text eq 'Hello world'
  end

  it 'should be able to write text on the title input' do
    visit '/'

    find('//input').set 'My Title'
    find('//input').text eq 'My Title'
  end
end
