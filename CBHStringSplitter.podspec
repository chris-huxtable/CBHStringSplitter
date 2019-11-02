Pod::Spec.new do |spec|

  spec.name                   = 'CBHStringSplitter'
  spec.version                = '0.1.0'
  spec.module_name            = 'CBHStringSplitter'

  spec.summary                = 'A convenient utility for splitting stings with a minimal memory footprint.'
  spec.homepage               = 'https://github.com/chris-huxtable/CBHStringSplitter'

  spec.license                = { :type => 'ISC', :file => 'LICENSE' }

  spec.author                 = { 'Chris Huxtable' => 'chris@huxtable.ca' }
  spec.social_media_url       = 'https://twitter.com/@Chris_Huxtable'

  spec.osx.deployment_target  = '10.10'

  spec.source                 = { :git => 'https://github.com/chris-huxtable/CBHStringSplitter.git', :tag => "v#{spec.version}" }

  spec.requires_arc           = true

  spec.public_header_files    = 'CBHStringSplitter/**/*.h'
  spec.source_files           = "CBHStringSplitter/**/*.{h,m}"

end
