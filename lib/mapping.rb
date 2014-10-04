require 'crypt'

module Mapping
extend self

@@mappings = nil

# if the value is an array, then it's one we want to display when we replace (we'll display them all if we do verbose)
# if it's not an array, we don't display it
MAPPINGS =
{'9768634b51ca38a98892c7086c9e3122' => ['doh', 'dangit', 'arrrggghhh'],
'3f6c82c5640cbdb903ebffb536501e1b' => ['doh', 'dangit', 'arrrggghhh'],
'77505a312e14133e2813677b42177e12' => ['doh', 'dangit', 'arrrggghhh'],
'de5ed538c7552a471ba1e69271af4e00' => ['doh', 'dangit', 'arrrggghhh'],
'4a1387bafcfa3d3ebc29334e82f47d56' => ['loser', 'dork'],
'd6c79ee62074da77e988a7bca45017d9' => ['loser', 'dork'],
'278139c2481ec87e71a4f421bdcaa7b9' => ['loser', 'dork'],
'cdf9360e37b1cea42eb3debfb91eec80' => ['loser', 'dork'],
'ede96167c49f2e8906c93567aa545aeb' => ['loser', 'dork'],
'728bb4d112e685a8375336b0a228420b' => ['loser', 'dork'],
'f087d92fccba7cc5bf6e861dcf1d6773' => ['loser', 'dork'],
'95d28fed6cbc7f15f3a2419f8cbaf8bd' => "you're",
'8e7f8eec77c0d110cc4a5af52e161c70' => '',
'157be2f48759e163aca91e020174524b' => ['why not'],
# DYNAMICALLY INSERT RIGHT BEFORE THIS LINE
}

def get_regex(phrase)
  phrase.gsub!(' ', '[\s\,\-\!-.]+')
  /(\W)(#{phrase})(\W)/i
end

def get_mappings
  return @@mappings if @@mappings
  @@mappings = MAPPINGS.collect do |key, value|
    [Crypt.decrypt(key), value]
  end
  @@mappings.sort! do |elem1, elem2|
    elem2[0].length <=> elem1[0].length
  end
  @@mappings.collect! do |key, value|
    [get_regex(key), value]
  end
  @@mappings
end

def mapping_filename
  File.join(Doh.root, 'lib', 'mapping.rb')
end

def read_mapping_file
  File.readlines(mapping_filename)
end

def dynamic_insert_line(lines)
  lines.find_index {|line| line =~ /DYNAMICALLY INSERT RIGHT BEFORE THIS LINE/}
end

def write_mapping_file(lines)
  outf = File.new(mapping_filename, 'w+')
  lines.each do |line|
    outf << line
  end
  outf.close
end


end


# make sure we match
# your butt is to:
# your, butt, is
# your - butt, is
