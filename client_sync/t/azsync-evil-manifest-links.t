#!/usr/local/bin/perl -w

# evil-manifest-links.t -- test what happens if the azsync manifest tries to put stuff inside symlinks
#                          that point outside of the directory

use strict;
use warnings;
use lib 't/lib';

use Test::More tests => 6;
use Test::azsync qw/:all/;

$Test::azsync::AZSYNC_URL = $ENV{AZSYNC_TEST_URL}
  or die "you need to set AZSYNC_TEST_URL\n";
    
# bucket.bad.evil-manifest-links makes a symlink "xxx" -> ".." and then tries to put NODELIST in it

# make sure it won't get pulled down
azsync_dies( "bucket.bad.evil-manifest-links" );
scratch_is_gone( "'current' does not exist if the manifest refers to upwards paths" );

# ensure it didn't write anything anywhere
is( scalar qx[find $AZSYNC_SCRATCH -type f], "", "no files were left in scratch" );

# try on top of an existing bucket
azsync_ok( "bucket.tweak" );

# make sure it still doesn't get pulled down
azsync_dies( "bucket.bad.evil-manifest-links" );
scratch_is( "bucket.tweak", "scratch is unchanged after trying to fetch a corrupt bucket" );
