TEMPLATE        = subdirs
CONFIG          += c++11
SUBDIRS         =   \
    installer       \
    src

installer.depends = src

#QMAKE_CLEAN += $$shell_path("include/novos/*.h")

#copydata.commands  = $${QMAKE_COPY} $$shell_path("third_party/lib/*.dll") $$shell_path("lib")
#copydata.commands += && $${QMAKE_COPY} $$shell_path("third_party/lib/*.lib") $$shell_path("lib")

#first.depends = $(first) copydata
#QMAKE_EXTRA_TARGETS += first copydata
