cmake_minimum_required(VERSION 3.16)
project(FocusTracker VERSION 0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS LinguistTools)
find_package(Qt6 REQUIRED COMPONENTS Sql)

set(TS_FILES
    ${CMAKE_SOURCE_DIR}/translations/focustracker_ru.ts
    ${CMAKE_SOURCE_DIR}/translations/focustracker_en.ts
)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appFocusTracker
    main.cpp
)

# Define translation output directory
set(QM_OUTPUT_DIR ${CMAKE_BINARY_DIR}/translations)

# Generate .qm files
qt_add_translations(appFocusTracker
    TS_FILES ${TS_FILES}
    QM_FILES_OUTPUT_VARIABLE QM_FILES
    QM_FILES_OUTPUT_LOCATION ${QM_OUTPUT_DIR}
)

qt_add_qml_module(appFocusTracker
    URI FocusTracker
    VERSION 1.0
    QML_FILES
        Main.qml
        SidePanel.qml
        AddHabitWindow.qml
        StatsView.qml
        ProfileButton.qml
        NavButton.qml
        NavIconButton.qml
        SectionDivider.qml
        CustomScrollBar.qml
        Settings.qml
        SettingsButton.qml
        WindowHeader.qml
        SidebarArea.qml
        ContentArea.qml
        AccountTab.qml
        GeneralTab.qml
        CustomRectButton.qml
        SettingSection.qml
        CustomComboBox.qml
        CustomSwitch.qml
        TasksView.qml
        NotesView.qml
    SOURCES
        habitsmodel.h
        habitsmodel.cpp
        SettingsManager.h
        SettingsManager.cpp
        tasksmodel.h
        tasksmodel.cpp
        notesmodel.h
        notesmodel.cpp
    RESOURCES
        translations.qrc
        QML_FILES AppearanceTab.qml
        QML_FILES Theme.qml
        SOURCES
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES TaskItem.qml
        QML_FILES
        QML_FILES AddNoteDialog.qml
        QML_FILES NoteCard.qml
        QML_FILES AuthWindow.qml
        QML_FILES
        SOURCES authmanager.h authmanager.cpp
        QML_FILES HabitView.qml
        QML_FILES LeftPanel.qml
        QML_FILES WelcomePanel.qml
        QML_FILES AuthForm.qml
        QML_FILES HabitItem.qml
        SOURCES eventsmodel.h eventsmodel.cpp
        QML_FILES CalendarView.qml
        QML_FILES AddEventDialog.qml
        QML_FILES EditEventDialog.qml
)

# Create translations directory in build
add_custom_command(
    TARGET appFocusTracker
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/translations
)

# Copy QM files to binary directory
add_custom_command(
    TARGET appFocusTracker
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${QM_FILES}
        ${CMAKE_BINARY_DIR}/translations/
)

# Ensure SQL plugins are copied to the build directory
add_custom_command(
    TARGET appFocusTracker
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/sqldrivers
    COMMENT "Creating sqldrivers directory"
)

if(WIN32)
    add_custom_command(
        TARGET appFocusTracker
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $ENV{QTDIR}/plugins/sqldrivers/qsqlite$<$<CONFIG:Debug>:d>.dll
            ${CMAKE_BINARY_DIR}/sqldrivers/
        COMMENT "Copying SQLite driver to build directory"
    )
elseif(APPLE)
    add_custom_command(
        TARGET appFocusTracker
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $ENV{QTDIR}/plugins/sqldrivers/libqsqlite$<$<CONFIG:Debug>:_debug>.dylib
            ${CMAKE_BINARY_DIR}/sqldrivers/
        COMMENT "Copying SQLite driver to build directory"
    )
else()
    add_custom_command(
        TARGET appFocusTracker
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            $ENV{QTDIR}/plugins/sqldrivers/libqsqlite.so
            ${CMAKE_BINARY_DIR}/sqldrivers/
        COMMENT "Copying SQLite driver to build directory"
    )
endif()

add_custom_target(copy_resources ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_SOURCE_DIR}/resources
    ${CMAKE_BINARY_DIR}/resources
    COMMENT "Copying resources to build directory"
)

add_dependencies(appFocusTracker copy_resources)

target_link_libraries(appFocusTracker
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
)

set_target_properties(appFocusTracker PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS appFocusTracker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/translations
)

# Install SQL drivers
if(WIN32)
    install(FILES $ENV{QTDIR}/plugins/sqldrivers/qsqlite$<$<CONFIG:Debug>:d>.dll
        DESTINATION ${CMAKE_INSTALL_BINDIR}/sqldrivers)
elseif(APPLE)
    install(FILES $ENV{QTDIR}/plugins/sqldrivers/libqsqlite$<$<CONFIG:Debug>:_debug>.dylib
        DESTINATION ${CMAKE_INSTALL_BINDIR}/sqldrivers)
else()
    install(FILES $ENV{QTDIR}/plugins/sqldrivers/libqsqlite.so
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/sqldrivers)
endif()
