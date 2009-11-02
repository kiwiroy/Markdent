use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
Header 1
========

Header 2
--------

# Header 1A

## Header 2A

### Header 3

#### Header 4

##### Header 5

###### Header 6
EOF

    my $expect = [
        {
            type  => 'header',
            level => 1,
        },
        [
            {
                type => 'text',
                text => 'Header 1',
            },
        ], {
            type  => 'header',
            level => 2,
        },
        [
            {
                type => 'text',
                text => 'Header 2',
            },
        ], {
            type  => 'header',
            level => 1,
        },
        [
            {
                type => 'text',
                text => 'Header 1A',
            },
        ], {
            type  => 'header',
            level => 2,
        },
        [
            {
                type => 'text',
                text => 'Header 2A',
            },
        ], {
            type  => 'header',
            level => 3,
        },
        [
            {
                type => 'text',
                text => 'Header 3',
            },
        ], {
            type  => 'header',
            level => 4,
        },
        [
            {
                type => 'text',
                text => 'Header 4',
            },
        ], {
            type  => 'header',
            level => 5,
        },
        [
            {
                type => 'text',
                text => 'Header 5',
            },
        ], {
            type  => 'header',
            level => 6,
        },
        [
            {
                type => 'text',
                text => 'Header 6',
            },
        ],
    ];

    parse_ok( $text, $expect, 'all possible header types' );
}

{
    my $text = <<'EOF';
Header *with em*
================

### H3 **with strong**
EOF

    my $expect = [
        {
            type  => 'header',
            level => 1,
        },
        [
            {
                type => 'text',
                text => 'Header ',
            },
            { type => 'emphasis' },
            [
                {
                    type => 'text',
                    text => 'with em',
                },
            ],
        ], {
            type  => 'header',
            level => 3,
        },
        [
            {
                type => 'text',
                text => 'H3 ',
            },
            { type => 'strong' },
            [
                {
                    type => 'text',
                    text => 'with strong',
                },
            ],
        ],
    ];

    parse_ok( $text, $expect, 'two-line header with em markup' );
}