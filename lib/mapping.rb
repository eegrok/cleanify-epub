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
'157be2f48759e163aca91e020174524b' => ['why not'],
'e60f02c41899c86e363f07ee147b6ac14f943e4f2cd619d546024f6a80f110cf' => ['you little'],
'f0cdf21ec6fbe6adfdfafc923cda98775ad0ff1c699ee33a5e5e1e0ae5d1f456' => ['eat them alive'],
'957e057203245895f4f96e87e8cc9b3f43ee808bbd69858fdd0e63a2ccf140c4' => ['little bugger'],
'81aefe89f51f77c4d161210b4fd4b1598f9d14042b17c10ec036a15f02977f46' => ['give me that'],
'0d8a78dfe14e8666052176c8a941f1fa' => [','],
'ad4f47b31819d1b76e7ae7396cd67c94' => ['definitely'],
'8e7f8eec77c0d110cc4a5af52e161c70' => ['go away'],
'55e30a5bf531973037ae995d8f63f42d' => ['an idiot'],
'dcc1fa1c57f1df8ac17bb0f75c227a57' => ['mean person'],
'47702b6eeaf339618807fb3ab165541e6a4492e953ebaf5c11b6c31a8609f890' => ['what to do'],
'c2482e6864f36962f9df51d290df8694' => ['really sure'],
'e61a511065e184efff52977a0a65dfb7ed7e2d01c1c4a652281a324132493d7a' => ['forget both of you'],
'4eb98f87b53597c9ca65ac7f0733079d' => ['forget'],
'47f2dfa2d66a40b571c66c2b4cf6a223' => ['definitely'],
'7f25fa4c30a14f5db76ac877cb05b462' => ['messed up'],
'22c2d858affd21075c7927d662d56529' => ['pain'],
'c6df290bf32413fb1957e138307b50f2' => ['no way'],
'7bc51426dd87a8d9d55a1f9c7d77c79c' => ['beat you'],
# DYNAMICALLY INSERT RIGHT BEFORE THIS LINE
}

def get_regex(phrase)
  opens_non_word = phrase =~ /^\W/
  ends_non_word = phrase =~ /\W$/
  phrase = phrase.gsub(',', '[\s]*,[\s]*')
  phrase.gsub!(' ', '[\s\,\-\!-.]+')
  open_optional = opens_non_word ? '?' : ''
  end_optional = ends_non_word ? '?' : ''
  /(\W)#{open_optional}(#{phrase})(\W)#{end_optional}/i
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
