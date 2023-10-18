PORTNAME=	curl
PORTVERSION=	8.4.0
CATEGORIES=	ftp net www
MASTER_SITES=	https://curl.se/download/ \
		https://github.com/curl/curl/releases/download/curl-${PORTVERSION:S|.|_|g}/

MAINTAINER=	sunpoet@FreeBSD.org
COMMENT=	Command line tool and library for transferring data with URLs
WWW=		https://curl.se/ \
		https://github.com/curl/curl

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/COPYING

USES=		cpe libtool localbase pathfix perl5 shebangfix tar:xz
USE_PERL5=	build

CONFIGURE_ARGS=	--disable-werror \
		--enable-dateparse \
		--enable-dnsshuffle \
		--enable-headers-api \
		--enable-hsts \
		--enable-http-auth \
		--enable-mime \
		--enable-netrc \
		--enable-openssl-auto-load-config \
		--enable-progress-meter \
		--with-fish-functions-dir=${LOCALBASE}/share/fish/completions \
		--with-zsh-functions-dir=${LOCALBASE}/share/zsh/site-functions \
		--without-ca-bundle \
		--without-ca-path
CONFIGURE_ENV=	LOCALBASE=${LOCALBASE} \
		ac_cv_func_SSLv2_client_method=no
GNU_CONFIGURE=	yes
INSTALL_TARGET=	install-strip
TEST_TARGET=	test
USE_LDCONFIG=	yes

CPE_VENDOR=	haxx

SHEBANG_FILES=	*/*.pl

OPTIONS_DEFINE=	ALTSVC BROTLI COOKIES CURL_DEBUG DEBUG DOCS EXAMPLES IDN IPV6 NTLM PROXY PSL STATIC TLS_SRP ZSTD
OPTIONS_GROUP=	PROTOCOL
OPTIONS_RADIO=	SSL
OPTIONS_SINGLE=	GSSAPI RESOLV
OPTIONS_GROUP_PROTOCOL=	DICT FTP GOPHER HTTP HTTP2 IMAP LDAP LDAPS LIBSSH LIBSSH2 MQTT POP3 RTMP RTSP SMB SMTP TELNET TFTP WEBSOCKET
OPTIONS_RADIO_SSL=	GNUTLS OPENSSL WOLFSSL
OPTIONS_SINGLE_GSSAPI=	GSSAPI_BASE GSSAPI_HEIMDAL GSSAPI_MIT GSSAPI_NONE
OPTIONS_SINGLE_RESOLV=	CARES THREADED_RESOLVER
OPTIONS_DEFAULT=ALTSVC COOKIES GSSAPI_${${SSL_DEFAULT} == base :?BASE :NONE} DICT FTP GOPHER HTTP HTTP2 IMAP LIBSSH2 NTLM OPENSSL POP3 PROXY PSL RTSP SMTP STATIC TELNET TFTP THREADED_RESOLVER TLS_SRP
OPTIONS_SUB=	yes

ALTSVC_DESC=	HTTP Alternative Services support
COOKIES_DESC=	Cookies support
CURL_DEBUG_DESC=cURL debug memory tracking
DICT_DESC=	DICT (RFC 2229) support
HTTP_DESC=	HTTP/HTTPS support
HTTP2_DESC=	HTTP/2 support (requires HTTP)
HTTP2_IMPLIES=	HTTP
IMAP_DESC=	IMAP/IMAPS support
LDAPS_IMPLIES=	LDAP
LIBSSH_DESC=	SCP/SFTP support via libssh (requires OPENSSL)
LIBSSH_IMPLIES=	OPENSSL
LIBSSH2_DESC=	SCP/SFTP support via libssh2 (requires OPENSSL)
LIBSSH2_IMPLIES=OPENSSL
MQTT_DESC=	MQTT support
POP3_DESC=	POP3/POP3S support
PROXY_IMPLIES=	HTTP
RESOLV_DESC=	DNS resolving options
RTSP_IMPLIES=	HTTP
SMB_DESC=	SMB/CIFS support
SMTP_DESC=	SMTP/SMTPS support
THREADED_RESOLVER_DESC=	Threaded DNS resolver
TLS_SRP_DESC=	TLS-SRP (Secure Remote Password) support
WEBSOCKET_DESC=	WebSocket support (experimental)

ALTSVC_CONFIGURE_ENABLE=alt-svc
BROTLI_CONFIGURE_WITH=	brotli
BROTLI_LIB_DEPENDS=	libbrotlidec.so:archivers/brotli
CARES_CONFIGURE_ENABLE=	ares
CARES_LIB_DEPENDS=	libcares.so:dns/c-ares
CARES_USES=		pkgconfig
COOKIES_CONFIGURE_ENABLE=	cookies
CURL_DEBUG_CONFIGURE_ENABLE=	curldebug
DEBUG_CONFIGURE_ENABLE=	debug
DICT_CONFIGURE_ENABLE=	dict
FTP_CONFIGURE_ENABLE=	ftp
GNUTLS_CONFIGURE_ON=	--with-ca-fallback
GNUTLS_CONFIGURE_WITH=	gnutls
GNUTLS_LIB_DEPENDS=	libgnutls.so:security/gnutls \
			libnettle.so:security/nettle
GOPHER_CONFIGURE_ENABLE=gopher
GSSAPI_BASE_CONFIGURE_ON=	--with-gssapi=${GSSAPIBASEDIR} ${GSSAPI_CONFIGURE_ARGS}
GSSAPI_BASE_CPPFLAGS=	${GSSAPICPPFLAGS}
GSSAPI_BASE_LDFLAGS=	${GSSAPILDFLAGS}
GSSAPI_BASE_LIBS=	${GSSAPILIBS}
GSSAPI_BASE_USES=	gssapi
GSSAPI_HEIMDAL_CONFIGURE_ON=	--with-gssapi=${GSSAPIBASEDIR} ${GSSAPI_CONFIGURE_ARGS}
GSSAPI_HEIMDAL_CPPFLAGS=${GSSAPICPPFLAGS}
GSSAPI_HEIMDAL_LDFLAGS=	${GSSAPILDFLAGS}
GSSAPI_HEIMDAL_LIBS=	${GSSAPILIBS}
GSSAPI_HEIMDAL_USES=	gssapi:heimdal
GSSAPI_MIT_CONFIGURE_ON=--with-gssapi=${GSSAPIBASEDIR} ${GSSAPI_CONFIGURE_ARGS}
GSSAPI_MIT_CPPFLAGS=	${GSSAPICPPFLAGS}
GSSAPI_MIT_LDFLAGS=	${GSSAPILDFLAGS}
GSSAPI_MIT_LIBS=	${GSSAPILIBS}
GSSAPI_MIT_USES=	gssapi:mit
GSSAPI_NONE_CONFIGURE_ON=	--without-gssapi
HTTP_CONFIGURE_ENABLE=	http
HTTP2_CONFIGURE_WITH=	nghttp2
HTTP2_LIB_DEPENDS=	libnghttp2.so:www/libnghttp2
HTTP2_USES=		pkgconfig
IDN_CONFIGURE_WITH=	libidn2
IDN_LIB_DEPENDS=	libidn2.so:dns/libidn2
IMAP_CONFIGURE_ENABLE=	imap
IPV6_CONFIGURE_ENABLE=	ipv6
LDAP_CONFIGURE_ENABLE=	ldap
LDAP_USES=		ldap
LDAPS_CONFIGURE_ENABLE=	ldaps
LIBSSH_CONFIGURE_WITH=	libssh
LIBSSH_LIB_DEPENDS=	libssh.so:security/libssh
LIBSSH2_CONFIGURE_WITH=	libssh2
LIBSSH2_LIB_DEPENDS=	libssh2.so:security/libssh2
MQTT_CONFIGURE_ENABLE=	mqtt
NTLM_CONFIGURE_ENABLE=	ntlm
OPENSSL_CONFIGURE_ON=	--with-ca-fallback
OPENSSL_CONFIGURE_WITH=	openssl=${OPENSSLBASE}
OPENSSL_CPPFLAGS=	-I${OPENSSLINC}
OPENSSL_LDFLAGS=	-L${OPENSSLLIB}
OPENSSL_USES=		ssl
POP3_CONFIGURE_ENABLE=	pop3
PROXY_CONFIGURE_ENABLE=	proxy
PSL_CONFIGURE_WITH=	libpsl
PSL_LIB_DEPENDS=	libpsl.so:dns/libpsl
RTMP_CONFIGURE_WITH=	librtmp
RTMP_LIB_DEPENDS=	librtmp.so:multimedia/librtmp
RTMP_USES=		pkgconfig
RTSP_CONFIGURE_ENABLE=	rtsp
SMB_CONFIGURE_ENABLE=	smb
SMTP_CONFIGURE_ENABLE=	smtp
#
# Add logic to detect poudriere install as it needs static build.
# search for poudriere install as well as poudriere/work directory,
# either will auto-set static, but can be manually set as well.
#
STATIC_CONFIGURE_ENABLE=static
TELNET_CONFIGURE_ENABLE=telnet
TFTP_CONFIGURE_ENABLE=	tftp
THREADED_RESOLVER_CONFIGURE_ENABLE=	pthreads threaded-resolver
TLS_SRP_CONFIGURE_ENABLE=	tls-srp
WEBSOCKET_CONFIGURE_ENABLE=	websockets
WOLFSSL_CONFIGURE_WITH=	wolfssl
WOLFSSL_LIB_DEPENDS=	libwolfssl.so:security/wolfssl
ZSTD_CONFIGURE_WITH=	zstd
ZSTD_LIB_DEPENDS=	libzstd.so:archivers/zstd

.include <bsd.port.pre.mk>

.if ((!${PORT_OPTIONS:MGNUTLS} && !${PORT_OPTIONS:MOPENSSL}) || (${PORT_OPTIONS:MOPENSSL} && ${SSL_DEFAULT:Mlibressl*})) && ${PORT_OPTIONS:MTLS_SRP}
IGNORE=		only supports TLS-SRP with either OpenSSL or GnuTLS
.endif

.if ${PORT_OPTIONS:MLDAPS} && !${PORT_OPTIONS:MGNUTLS} && !${PORT_OPTIONS:MOPENSSL} && !${PORT_OPTIONS:MWOLFSSL}
IGNORE=		only supports LDAPS with SSL
.endif

post-install:
	${INSTALL_DATA} ${WRKSRC}/docs/libcurl/libcurl.m4 ${STAGEDIR}${PREFIX}/share/aclocal/

post-install-DOCS-on:
	${MKDIR} ${STAGEDIR}${DOCSDIR}/ ${STAGEDIR}${DOCSDIR}/libcurl/
	cd ${WRKSRC}/docs/ && ${INSTALL_DATA} FAQ INSTALL KNOWN_BUGS MAIL-ETIQUETTE THANKS TODO options-in-versions *.md ${STAGEDIR}${DOCSDIR}/
	cd ${WRKSRC}/docs/libcurl/ && ${INSTALL_DATA} ABI.md libcurl.m4 *.pl symbols-in-versions ${STAGEDIR}${DOCSDIR}/libcurl/

post-install-EXAMPLES-on:
	${MKDIR} ${STAGEDIR}${EXAMPLESDIR}/
	cd ${WRKSRC}/docs/examples/ && ${INSTALL_DATA} Makefile.example Makefile.mk README.md *.c *.cpp ${STAGEDIR}${EXAMPLESDIR}/

.include <bsd.port.post.mk>
