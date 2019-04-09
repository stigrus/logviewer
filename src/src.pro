QT += quick
QT += quickcontrols2

CONFIG += c++11
#CONFIG += qtquickcompiler

TARGET = $$qtLibraryTarget(novos_logviewer)

DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    logmodel.h

SOURCES += main.cpp \
    logmodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

message($${DESTDIR})
copydata.commands  = $${QMAKE_COPY} $$shell_path("$(QTDIR)/bin/Qt5Core.dll") $$shell_path(".")

first.depends = $(first) copydata
QMAKE_EXTRA_TARGETS += first copydata

