require 'spec_helper'

describe Bunto::Avatar do
  let(:doc) { doc_with_content(content) }
  let(:username) { 'hubot' }
  let(:args) { '' }
  let(:text) { "#{username} #{args}".squeeze(' ') }
  let(:content) { "{% avatar #{text} %}" }
  let(:rendered) { subject.render(nil) }
  let(:output) do
    doc.content = content
    doc.output  = Bunto::Renderer.new(doc.site, doc).run
  end
  subject { Bunto::Avatar.send(:new, 'avatar', text, nil) }

  it 'has a version number' do
    expect(Bunto::Avatar::VERSION).not_to be nil
  end

  it 'outputs the HTML' do
    expected =  '<img class="avatar avatar-small" '
    expected << 'src="https://avatars3.githubusercontent.com/'
    expected << 'hubot?v=3&amp;s=40" alt="hubot" srcset="'
    expected << 'https://avatars3.githubusercontent.com/hubot?v=3&amp;s=40 1x, '
    expected << 'https://avatars3.githubusercontent.com/hubot?v=3&amp;s=80 2x, '
    expected << 'https://avatars3.githubusercontent.com/hubot?v=3&amp;s=120 3x, '
    expected << 'https://avatars3.githubusercontent.com/hubot?v=3&amp;s=160 4x" '
    expected << 'width="40" height="40" data-proofer-ignore="true" />'
    expect(rendered)
    expect(output).to eql("<p>#{expected}</p>\n")
  end

  it 'parses the username' do
    expect(subject.send(:username)).to eql('hubot')
  end

  it 'determines the server number' do
    expect(subject.send(:server_number)).to eql(3)
  end

  it 'builds the host' do
    expect(subject.send(:host)).to eql('avatars3.githubusercontent.com')
  end

  it 'builds the path' do
    expect(subject.send(:path)).to eql('hubot?v=3&s=40')
  end

  it 'defaults to the default size' do
    expect(subject.send(:size)).to eql(40)
  end

  it 'builds the URL' do
    expected = 'https://avatars3.githubusercontent.com/hubot?v=3&s=40'
    expect(subject.send(:url)).to eql(expected)
  end

  it 'builds the params' do
    attrs = subject.send(:attributes)
    expect(attrs[:class]).to eql('avatar avatar-small')
    expect(attrs[:alt]).to eql('hubot')
    expect(attrs[:src]).to eql('https://avatars3.githubusercontent.com/hubot?v=3&s=40')
    expect(attrs[:width]).to eql(40)
    expect(attrs[:height]).to eql(40)
  end

  it 'includes data-proofer-ignore' do
    expect(output).to match(/data-proofer-ignore=\"true\"/)
  end

  context 'retina' do
    it 'builds the path with a scale' do
      expect(subject.send(:path, 2)).to eql('hubot?v=3&s=80')
    end

    it 'builds the URL with a scale' do
      expected = 'https://avatars3.githubusercontent.com/hubot?v=3&s=80'
      expect(subject.send(:url, 2)).to eql(expected)
    end

    it 'builds the srcset' do
      expected = { 1 => 40, 2 => 80, 3 => 120, 4 => 160 }
      base = Regexp.escape 'https://avatars3.githubusercontent.com/hubot?v=3&'
      srcset = subject.send(:srcset)
      expected.each do |scale, width|
        expect(srcset).to match(/#{base}s=#{width} #{scale}x/)
      end
    end
  end

  context 'when passed @hubot as a username' do
    let(:username) { '@hubot' }

    it 'parses the username' do
      expect(subject.send(:username)).to eql('hubot')
    end
  end

  context 'with a size is passed' do
    let(:args) { 'size=45' }

    it "parses the user's requested size" do
      expect(subject.send(:size)).to eql(45)
    end
  end

  context 'with a size < 48' do
    it 'includes the avatar-small class' do
      expect(rendered).to match(/avatar-small/)
    end

    it 'calculates the classes' do
      expect(subject.send(:classes)).to eql('avatar avatar-small')
    end
  end

  context 'with a size > 48' do
    let(:args) { 'size=80' }

    it "doesn't include the avatar-small class" do
      expect(rendered).to_not match(/avatar-small/)
    end

    it 'calculates the classes' do
      expect(subject.send(:classes)).to eql('avatar')
    end
  end

  context 'when passed the username as a rendered variable' do
    let(:content) { "{% assign user='hubot2' %}{% avatar {{ user }} %}" }

    it 'parses the variable' do
      expected =  '<img class="avatar avatar-small" '
      expected << 'src="https://avatars0.githubusercontent.com/'
      expected << 'hubot2?v=3&amp;s=40" alt="hubot2" srcset="'
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=40 1x, '
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=80 2x, '
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=120 3x, '
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=160 4x" '
      expected << 'width="40" height="40" data-proofer-ignore="true" />'
      expect(output).to eql("<p>#{expected}</p>\n")
    end
  end

  context 'when passed the username as a variable-argument' do
    let(:content) { "{% assign user='hubot2' %}{% avatar user=user %}" }

    it 'parses the variable' do
      expected =  '<img class="avatar avatar-small" '
      expected << 'src="https://avatars0.githubusercontent.com/'
      expected << 'hubot2?v=3&amp;s=40" alt="hubot2" srcset="'
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=40 1x, '
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=80 2x, '
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=120 3x, '
      expected << 'https://avatars0.githubusercontent.com/hubot2?v=3&amp;s=160 4x" '
      expected << 'width="40" height="40" data-proofer-ignore="true" />'
      expect(output).to eql("<p>#{expected}</p>\n")
    end
  end

  context 'loops' do
    let(:content) do
      content =  '{% assign users = "a|b" | split:"|" %}'
      content << '{% for user in users %}'
      content << '  {% avatar user=user %}'
      content << '{% endfor %}'
      content
    end

    it 'renders each avatar' do
      expect(output).to match('alt="b"')
    end
  end
end
