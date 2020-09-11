after unpacking epub into a directory <epubdir>, run:
bin/cleanify -l <epubdir> -c
then either add to the Mapping::WHITELIST list in mapping.rb any words that are ok
or
bin/add_mapping <phrase> <replacement>
any that aren't

after that, run:
bin/cleanify -l <epubdir> -s -m

and confirm / tweak the changes
