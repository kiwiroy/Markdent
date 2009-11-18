use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
**strong with *bad** em*
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            { type => 'strong' },
            [
                {
                    type => 'text',
                    text => 'strong with *bad',
                },
            ], {
                type => 'text',
                text => " em*\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'good strong containing bad emphasis' );
}

{
    my $text = <<'EOF';
**bad strong with *good em*
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => '**bad strong with ',
            },
            { type => 'emphasis' },
            [
                {
                    type => 'text',
                    text => 'good em',
                },
            ], {
                type => 'text',
                text => "\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'bad strong start containing good emphasis' );
}

{
    my $text = <<'EOF';
**bad strong with ``bad code and *indirectly bad em*
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "**bad strong with ``bad code and *indirectly bad em*\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'bad strong and code start containing good emphasis' );
}

{
    my $text = <<'EOF';
**bad strong with *good em* and ``bad code
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => '**bad strong with ',
            },
            { type => 'emphasis' },
            [
                {
                    type => 'text',
                    text => 'good em',
                },
            ], {
                type => 'text',
                text => " and ``bad code\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'bad strong start, good emphasis, then bad code start' );
}

{
    my $text = <<'EOF';
**bad strong with *good em and ``good code``*
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => '**bad strong with ',
            },
            { type => 'emphasis' },
            [
                {
                    type => 'text',
                    text => 'good em and ',
                },
                { type => 'code' },
                [
                    {
                        type => 'text',
                        text => 'good code',
                    },
                ],
            ], {
                type => 'text',
                text => "\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'bad strong start, good emphasis containing good code' );
}

{
    my $text = <<'EOF';
**good strong with *bad ``em and good* code``**
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            { type => 'strong' },
            [
                {
                    type => 'text',
                    text => 'good strong with *bad ',
                },
                { type => 'code' },
                [
                    {
                        type => 'text',
                        text => 'em and good* code',
                    },
                ],
            ], {
                type => 'text',
                text => "\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'good strong start, good emphasis interleaving bad code' );
}
