#!/usr/bin/perl -n00
# dedupe.pl - find duplicate words in the input stream

print "$ARGV: para $.: ($1)\n"
    while /(\b(\w+)\b\s+\b\2\b)/sg;

# usage: find . -name '*.txt' | xargs dupwords.pl
# http://blog.moertel.com/posts/2006-03-01-finding-duplicate-words-in-writing-a-handy-perl-script.html
