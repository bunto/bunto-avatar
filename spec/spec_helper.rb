$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bunto'
require 'bunto-avatar'

TEST_DIR = File.dirname(__FILE__)
TMP_DIR  = File.expand_path('../tmp', TEST_DIR)

def doc_with_content(_content, opts = {})
  my_site = site(opts)
  options = { site: my_site, collection: collection(my_site) }
  Bunto::Document.new(source_dir('_test/doc.md'), options)
end

def tmp_dir(*files)
  File.join(TMP_DIR, *files)
end

def source_dir(*files)
  tmp_dir('source', *files)
end

def dest_dir(*files)
  tmp_dir('dest', *files)
end

def collection(site, label = 'test')
  Bunto::Collection.new(site, label)
end

def site(opts = {})
  defaults = Bunto::Configuration::DEFAULTS
  opts = opts.merge(
    'source'      => source_dir,
    'destination' => dest_dir
  )
  conf = Bunto::Utils.deep_merge_hashes(defaults, opts)
  Bunto::Site.new(conf)
end

def fixture(name)
  path = File.expand_path "./fixtures/#{name}.json", File.dirname(__FILE__)
  File.open(path).read
end
