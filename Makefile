-include config.Makefile

.PHONY: all install doc clean veryclean clobber mrproper distclean

all: tools lib/einarc/build-config.rb
#all: ext/lsi_mpt.so

BIN_FILES=\
	bin/einarc \
	bin/einarc-install \
	bin/raid-wizard-passthrough \
	bin/raid-wizard-optimal \
	bin/raid-wizard-clear

install:
	if [ -z "$(EINARC_LIB_DIR)" ]; then echo 'Run ./configure first!'; false; fi
	mkdir -p \
		$(DESTDIR)$(BIN_DIR) \
		$(DESTDIR)$(RUBY_SHARE_DIR)/einarc \
		$(DESTDIR)$(RUBY_SHARE_DIR)/einarc/extensions \
		$(DESTDIR)$(EINARC_VAR_DIR) \
		$(DESTDIR)$(EINARC_LIB_DIR)
	install -m755 $(BIN_FILES) $(DESTDIR)$(BIN_DIR)
	cp lib/*.rb $(DESTDIR)$(RUBY_SHARE_DIR)
	cp lib/einarc/*.rb proprietary.Makefile $(DESTDIR)$(RUBY_SHARE_DIR)/einarc
	cp lib/einarc/extensions/*.rb $(DESTDIR)$(RUBY_SHARE_DIR)/einarc/extensions
	if test -r config.rb; then cp config.rb $(DESTDIR)$(EINARC_VAR_DIR); fi
	if test -r proprietary/agreed; then mkdir -p $(DESTDIR)$(EINARC_VAR_DIR)/proprietary && cp proprietary/agreed $(DESTDIR)$(EINARC_VAR_DIR)/proprietary; fi
	if test -d tools; then cp -r tools/* $(DESTDIR)$(EINARC_LIB_DIR); fi
	if test -d tools/lsi_megacli; then ln -s $(DESTDIR)$(EINARC_LIB_DIR)/lsi_megacli/cli $(BIN_DIR)/megacli; fi
	if test -d tools/lsi_megacli; then ln -s $(DESTDIR)$(EINARC_LIB_DIR)/lsi_megacli/cli.bin $(BIN_DIR)/cli.bin; fi
	if test -d tools/lsi_megarc; then ln -s $(DESTDIR)$(EINARC_LIB_DIR)/lsi_megarc/cli $(BIN_DIR)/mpt-status; fi
	if test -d tools/amcc; then ln -s $(DESTDIR)$(EINARC_LIB_DIR)/amcc/cli $(BIN_DIR)/tw_cli; fi
	if test -d tools; then ln -s $(DESTDIR)$(EINARC_LIB_DIR) /opt/RAID; fi
#	if File.exists?('ext/lsi_mpt.so')
#		mkdir_p INSTALL_DIR_PREFIX + LIB_DIR
#		cp 'ext/lsi_mpt.so', INSTALL_DIR_PREFIX + LIB_DIR
#	end

doc:
	$(MAKE) -C $@

clean:
	rm -rf tools
	rm -f ext/lsi_mpt.o ext/lsi_mpt.so

veryclean: clean
	rm -rf proprietary config.Makefile lib/einarc/build-config.rb config.rb doc/xhtml doc/man

# Several aliases for veryclean
clobber: veryclean

mrproper: veryclean

distclean: veryclean

include proprietary.Makefile
