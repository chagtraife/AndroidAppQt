QT += quick
QT += androidextras
QT += sensors

CONFIG += c++11

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
SOURCES += \
        MainMenu/MainMenu.cpp \
        Sensor/Sensor.cpp \
        domain/domain.cpp \
        main.cpp \
        BasicSetting/basicsetting.cpp

OTHER_FILES += \
    android-sources/src/org/qtproject/trackingapp/OrientationChanger.java \
    android-sources/AndroidManifest.xml

RESOURCES += qml.qrc \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#DISTFILES += \
#    main.qml

HEADERS += \
    BasicSetting/BasicSetting.hpp \
    MainMenu/MainMenu.hpp \
    Sensor/Sensor.hpp \
    domain/domain.hpp

#target.path = $$PWD
#INSTALLS += target

DISTFILES += \
    android-sources/AndroidManifest.xml \
    android-sources/build.gradle \
    android-sources/build.gradle \
    android-sources/gradle/wrapper/gradle-wrapper.jar \
    android-sources/gradle/wrapper/gradle-wrapper.jar \
    android-sources/gradle/wrapper/gradle-wrapper.properties \
    android-sources/gradle/wrapper/gradle-wrapper.properties \
    android-sources/gradlew \
    android-sources/gradlew \
    android-sources/gradlew.bat \
    android-sources/gradlew.bat \
    android-sources/res/values/libs.xml \
    android-sources/res/values/libs.xml \

