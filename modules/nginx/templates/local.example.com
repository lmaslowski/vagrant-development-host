server {
	listen   80; ## listen for ipv4; this line is default and implied
	listen   [::]:80 default_server ipv6only=on; ## listen for ipv6

	root /home/local.example.com/web;
	index app.php;

	# Make site accessible from http://localhost/
	server_name local.example.com;

        error_log /var/log/nginx/local.example.com.error.log;
        access_log /var/log/nginx/local.example.com.access.log;

        location / {
          index app.php;
          if (-f $request_filename) {
            break;
          }
          rewrite ^(.*)$ /app.php last;
        }


	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
        location ~ (app|app_dev).php {
	        try_files $uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
	
		# With php5-cgi alone:
	#	fastcgi_pass 127.0.0.1:9000;
		# With php5-fpm:
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index app.php;
		include fastcgi_params;
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
		deny all;
	}
}
