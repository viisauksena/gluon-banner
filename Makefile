include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-banner
PKG_VERSION:=1
PKG_RELEASE:=$(GLUON_VERSION).$(GLUON_SITE_CODE)-$(GLUON_RELEASE).$(GLUON_CONFIG_VERSION)

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/gluon-banner
  SECTION:=FFFr
  CATEGORY:=Customization
  TITLE:=Banner file replacement
  DEPENDS:=+gluon-core +busybox
  MAINTAINER:=FFFr freiburg.freifunk.net fuzzle
  URL:=https://github.com/viisauksena/gluon-banner
  SOURCE:=https://github.com/viisauksena/gluon-banner.git
endef

define Package/gluon-banner/description
	Banner file replacement - with plenty of information on login
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/gluon-banner/preinst
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
if [ -h "./banner" ] ; then
	/bin/rm "./banner"
elif [ -f "./banner" ] ; then
	/bin/mv "./banner" "./banner.openwrt"
fi
/bin/ln -s "./banner.openwrt" "./banner"

if [ -h "./profile" ] ; then
	/bin/rm "./profile"
elif [ -f "./profile" ] ; then
	/bin/mv "./profile" "./profile.openwrt"
fi
/bin/ln -s "./profile.gluon" "./profile"
exit 0
endef

define Package/gluon-banner/postinst
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
[ -h "./banner" ] && /bin/rm -f "./banner"
/bin/ln -s "./banner.gluon" "./banner"
[ -h "./profile" ] && /bin/rm -f "./profile"
/bin/ln -s "./profile.gluon" "./profile"
exit $$?
endef

define Package/gluon-banner/prerm
#!/bin/sh
cd "$${IPKG_INSTROOT}/etc/"
if [ -h "./banner" ] ; then
	[[ "$$(readlink -n ./banner)" == "./banner.gluon" ]] && \
	/bin/rm -f "./banner" && \
	[ -f "./banner.openwrt" ] && \
	/bin/ln -s "./banner.openwrt" "./banner"
fi
if [ -h "./profile" ] ; then
	[[ "$$(readlink -n ./profile)" == "./profile.gluon" ]] && \
	/bin/rm -f "./profile" && \
	[ -f "./profile.openwrt" ] && \
	/bin/ln -s "./profile.openwrt" "./profile"
fi
exit 0
endef

define Package/gluon-banner/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DATA) ./files/etc/banner.gluon $(1)/etc/
	$(CP) ./files/* $(1)/
endef


$(eval $(call BuildPackage,gluon-banner))
