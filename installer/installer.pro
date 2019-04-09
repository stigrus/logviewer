TEMPLATE = aux

INSTALLER = NovosLogViewer

INPUT = $$PWD/config/config.xml $$PWD/packages
logviewer.input = INPUT
logviewer.output = $$INSTALLER
logviewer.commands = $(QT_INSTALLER_FRAMEWORK)/bin/binarycreator -c $$PWD/config/config.xml -p $$PWD/packages ${QMAKE_FILE_OUT}
logviewer.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += logviewer

OTHER_FILES = README
