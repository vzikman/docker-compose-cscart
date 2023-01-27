ARG PHP_VER="7.3"
FROM php:$PHP_VER-fpm-alpine

ARG XHPROF=1
ARG REDIS_VER=5.3.2
ARG GD_PARAMS="--with-png-dir=/usr --with-jpeg-dir=/usr"
ARG PHP_MOD_INSTALL="mysqli pdo_mysql intl json curl soap exif zip sockets opcache gd"

RUN apk add --no-cache --virtual \
	.build-deps \
	$PHPIZE_DEPS

RUN if [ "$XHPROF" = "1" ]; then \
	pecl install xhprof && \
	docker-php-ext-enable xhprof; \
	fi

RUN	apk add --no-cache \
    git \
	bash \
	mysql-client \
	openssh-client \
	oniguruma \
	imagemagick6-dev \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	icu-dev \
	curl-dev \
	libxml2-dev \
	libzip-dev \
	libgomp \
	terminus-font \
	graphviz && \
	pecl install Imagick && \
	pecl install -o -f redis-"$REDIS_VER" && \
	docker-php-ext-enable imagick && \
	docker-php-ext-enable redis && \
	docker-php-ext-configure gd $GD_PARAMS && \
	docker-php-ext-install -j$(nproc) $PHP_MOD_INSTALL && \
	apk del .build-deps \