# vi:filetype=perl

use lib 'lib';
use Test::Nginx::LWP;

plan tests => repeat_each() * 2 * blocks() - 1;
$ENV{TEST_NGINX_BACKENDS_PORT} ||= "www.taobao.com:80";
no_root_location();

#no_diff;

run_tests();

__DATA__

=== TEST 1: the "regex with captures substitution" command
--- main_config
    load_module /etc/nginx/modules/ngx_http_subs_filter_module.so;

--- http_config

    upstream backends {
        server $TEST_NGINX_BACKENDS_PORT;
    }

--- config

    location / {
        subs_filter 'taobao.(com)' 'yaoweibin.$1' ir;
        proxy_pass http://yaoweibin.net:8080/test/subs/taobao.htm;
    }
--- request
    GET /
--- response_body_unlike: ^(.*)taobao.com(.*)$
