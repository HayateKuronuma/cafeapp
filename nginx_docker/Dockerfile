FROM nginx:1.20.2

RUN rm -f /etc/nginx/conf.d/*

ADD /nginx_docker/nginx.conf /etc/nginx/conf.d/cafeapp.conf

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
