# frozen_string_literal: true
require 'spec_helper'

describe Katex do
  it 'has a version number' do
    expect(Katex::VERSION).not_to be nil
    expect(Katex::KATEX_VERSION).not_to be nil
  end

  it 'renders via katex' do
    expect(Katex.render('c = \\pm\\sqrt{a^2 + b^2}')).to include('span')
  end

  it 'passes options to katex' do
    expect(Katex.render('c', display_mode: true)).to include('katex-display')
  end
end
