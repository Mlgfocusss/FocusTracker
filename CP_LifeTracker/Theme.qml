import QtQuick 2.15

QtObject {
    id: theme

    property int themeIndex: SettingsManager.themeIndex
    property string currentTheme: themeNames[themeIndex]

    property var themeNames: ["light", "dark", "colorful"]

    property var baseColors: [
        {
            background: "#F8F9FC",
            backgroundSecondary: "#EEF2F6",
            card: "#FFFFFF",
            cardSelected: "#F0F4FA",
            text: "#2D3748",
            textSecondary: "#718096",
            accent: "#3B82F6",
            accentGradientStart: "#4F46E5",
            accentGradientEnd: "#3B82F6",
            shadow: "#18000000",
            border: "#E2E8F0"
        },
        {
            background: "#121418",
            backgroundSecondary: "#1E2029",
            card: "#252A35",
            cardSelected: "#323845",
            text: "#E2E8F0",
            textSecondary: "#A0AEC0",
            accent: "#60A5FA",
            accentGradientStart: "#60A5FA",
            accentGradientEnd: "#4F46E5",
            shadow: "#40000000",
            border: "#383F4E"
        },
        {
            background: "#171923",
            backgroundSecondary: "#1F2230",
            card: "#252A3C",
            cardSelected: "#303B54",
            text: "#F7FAFC",
            textSecondary: "#CBD5E0",
            accent: "#38B2AC",
            accentGradientStart: "#38B2AC",
            accentGradientEnd: "#319795",
            shadow: "#40000000",
            border: "#2D3748"
        }
    ]

    property var buttonColors: [
        {
            primary: "#3B82F6",
            secondary: "#64748B",
            success: "#10B981",
            danger: "#EF4444",
            warning: "#F59E0B",
            info: "#06B6D4",
            textLight: "#FFFFFF",
            textDark: "#1E293B",
            border: "#E2E8F0",
            disabled: "#E9ECEF"
        },
        {
            primary: "#60A5FA",
            secondary: "#94A3B8",
            success: "#34D399",
            danger: "#F87171",
            warning: "#FBBF24",
            info: "#22D3EE",
            textLight: "#F1F5F9",
            textDark: "#1E293B",
            border: "#383F4E",
            disabled: "#363B49"
        },
        {
            primary: "#38B2AC",
            secondary: "#ED8936",
            success: "#68D391",
            danger: "#F56565",
            warning: "#ECC94B",
            info: "#4FD1C5",
            textLight: "#F7FAFC",
            textDark: "#171923",
            border: "#2D3748",
            disabled: "#2D3748"
        }
    ]

    property var inputColors: [
        {
            background: "#FFFFFF",
            border: "#CBD5E0",
            borderFocus: "#3B82F6",
            text: "#2D3748",
            placeholder: "#94A3B8",
            selection: "#3B82F633"
        },
        {
            background: "#2A303C",
            border: "#434C5E",
            borderFocus: "#60A5FA",
            text: "#E2E8F0",
            placeholder: "#94A3B8",
            selection: "#60A5FA33"
        },
        {
            background: "#2A313F",
            border: "#38414D",
            borderFocus: "#38B2AC",
            text: "#F7FAFC",
            placeholder: "#A0AEC0",
            selection: "#38B2AC33"
        }
    ]

    property var navigationColors: [
        {
            background: "#FFFFFF",
            border: "#E2E8F0",
            active: "#3B82F6",
            inactive: "#64748B",
            hover: "#F1F5F9"
        },
        {
            background: "#252A35",
            border: "#383F4E",
            active: "#60A5FA",
            inactive: "#94A3B8",
            hover: "#323845"
        },
        {
            background: "#252A3C",
            border: "#2D3748",
            active: "#38B2AC",
            inactive: "#A0AEC0",
            hover: "#303B54"
        }
    ]

    property var taskPriorityColors: [
        {
            low: "#10B981",
            medium: "#F59E0B",
            high: "#F97316",
            urgent: "#EF4444"
        },
        {
            low: "#34D399",
            medium: "#FBBF24",
            high: "#FB923C",
            urgent: "#F87171"
        },
        {
            low: "#68D391",
            medium: "#ECC94B",
            high: "#ED8936",
            urgent: "#F56565"
        }
    ]

    property var statusColors: [
        {
            completed: "#10B981",
            inProgress: "#3B82F6",
            pending: "#F59E0B",
            overdue: "#EF4444"
        },
        {
            completed: "#34D399",
            inProgress: "#60A5FA",
            pending: "#FBBF24",
            overdue: "#F87171"
        },
        {
            completed: "#68D391",
            inProgress: "#38B2AC",
            pending: "#ECC94B",
            overdue: "#F56565"
        }
    ]

    property var dialogColors: [
        {
            background: "#FFFFFF",
            text: "#2D3748",
            headerText: "#FFFFFF",
            footerBackground: "#EEF2F6",
            buttonText: "#2D3748"
        },
        {
            background: "#252A35",
            text: "#E2E8F0",
            headerText: "#FFFFFF",
            footerBackground: "#1E2029",
            buttonText: "#E2E8F0"
        },
        {
            background: "#252A3C",
            text: "#F7FAFC",
            headerText: "#FFFFFF",
            footerBackground: "#1F2230",
            buttonText: "#F7FAFC"
        }
    ]

    property color backgroundColor: baseColors[themeIndex].background
    property color backgroundSecondaryColor: baseColors[themeIndex].backgroundSecondary
    property color cardColor: baseColors[themeIndex].card
    property color cardSelectedColor: baseColors[themeIndex].cardSelected
    property color textColor: baseColors[themeIndex].text
    property color textSecondaryColor: baseColors[themeIndex].textSecondary
    property color accentColor: baseColors[themeIndex].accent
    property color accentGradientStartColor: baseColors[themeIndex].accentGradientStart
    property color accentGradientEndColor: baseColors[themeIndex].accentGradientEnd
    property color shadowColor: baseColors[themeIndex].shadow
    property color borderColor: baseColors[themeIndex].border

    property color buttonPrimaryColor: buttonColors[themeIndex].primary
    property color buttonSecondaryColor: buttonColors[themeIndex].secondary
    property color buttonSuccessColor: buttonColors[themeIndex].success
    property color buttonDangerColor: buttonColors[themeIndex].danger
    property color buttonWarningColor: buttonColors[themeIndex].warning
    property color buttonInfoColor: buttonColors[themeIndex].info
    property color buttonTextLightColor: buttonColors[themeIndex].textLight
    property color buttonTextDarkColor: buttonColors[themeIndex].textDark
    property color buttonBorderColor: buttonColors[themeIndex].border
    property color buttonDisabledColor: buttonColors[themeIndex].disabled

    property color inputBackgroundColor: inputColors[themeIndex].background
    property color inputBorderColor: inputColors[themeIndex].border
    property color inputBorderFocusColor: inputColors[themeIndex].borderFocus
    property color inputTextColor: inputColors[themeIndex].text
    property color inputPlaceholderColor: inputColors[themeIndex].placeholder
    property color inputSelectionColor: inputColors[themeIndex].selection

    property color navBackgroundColor: navigationColors[themeIndex].background
    property color navBorderColor: navigationColors[themeIndex].border
    property color navActiveColor: navigationColors[themeIndex].active
    property color navInactiveColor: navigationColors[themeIndex].inactive
    property color navHoverColor: navigationColors[themeIndex].hover

    property color priorityLowColor: taskPriorityColors[themeIndex].low
    property color priorityMediumColor: taskPriorityColors[themeIndex].medium
    property color priorityHighColor: taskPriorityColors[themeIndex].high
    property color priorityUrgentColor: taskPriorityColors[themeIndex].urgent

    property color statusCompletedColor: statusColors[themeIndex].completed
    property color statusInProgressColor: statusColors[themeIndex].inProgress
    property color statusPendingColor: statusColors[themeIndex].pending
    property color statusOverdueColor: statusColors[themeIndex].overdue

    property color dialogBackgroundColor: dialogColors[themeIndex].background
    property color dialogTextColor: dialogColors[themeIndex].text
    property color dialogHeaderTextColor: dialogColors[themeIndex].headerText
    property color dialogFooterBackgroundColor: dialogColors[themeIndex].footerBackground
    property color dialogButtonTextColor: dialogColors[themeIndex].buttonText

    property color errorColor: buttonDangerColor
    property color successColor: buttonSuccessColor
    property color warningColor: buttonWarningColor
    property color infoColor: buttonInfoColor

    property color textColorDim: textSecondaryColor
    property color windowColor: backgroundColor

    property var accentGradient: Gradient {
        GradientStop { position: 0.0; color: accentGradientStartColor }
        GradientStop { position: 1.0; color: accentGradientEndColor }
    }

    Behavior on backgroundColor { ColorAnimation { duration: 200 } }
    Behavior on backgroundSecondaryColor { ColorAnimation { duration: 200 } }
    Behavior on cardColor { ColorAnimation { duration: 200 } }
    Behavior on cardSelectedColor { ColorAnimation { duration: 200 } }
    Behavior on textColor { ColorAnimation { duration: 200 } }
    Behavior on textSecondaryColor { ColorAnimation { duration: 200 } }
    Behavior on accentColor { ColorAnimation { duration: 200 } }
    Behavior on accentGradientStartColor { ColorAnimation { duration: 200 } }
    Behavior on accentGradientEndColor { ColorAnimation { duration: 200 } }
    Behavior on shadowColor { ColorAnimation { duration: 200 } }
    Behavior on borderColor { ColorAnimation { duration: 200 } }

    Behavior on buttonPrimaryColor { ColorAnimation { duration: 200 } }
    Behavior on buttonSecondaryColor { ColorAnimation { duration: 200 } }
    Behavior on buttonSuccessColor { ColorAnimation { duration: 200 } }
    Behavior on buttonDangerColor { ColorAnimation { duration: 200 } }
    Behavior on buttonWarningColor { ColorAnimation { duration: 200 } }
    Behavior on buttonInfoColor { ColorAnimation { duration: 200 } }
    Behavior on buttonTextLightColor { ColorAnimation { duration: 200 } }
    Behavior on buttonTextDarkColor { ColorAnimation { duration: 200 } }
    Behavior on buttonBorderColor { ColorAnimation { duration: 200 } }
    Behavior on buttonDisabledColor { ColorAnimation { duration: 200 } }

    Behavior on inputBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on inputBorderColor { ColorAnimation { duration: 200 } }
    Behavior on inputBorderFocusColor { ColorAnimation { duration: 200 } }
    Behavior on inputTextColor { ColorAnimation { duration: 200 } }
    Behavior on inputPlaceholderColor { ColorAnimation { duration: 200 } }
    Behavior on inputSelectionColor { ColorAnimation { duration: 200 } }

    Behavior on navBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on navBorderColor { ColorAnimation { duration: 200 } }
    Behavior on navActiveColor { ColorAnimation { duration: 200 } }
    Behavior on navInactiveColor { ColorAnimation { duration: 200 } }
    Behavior on navHoverColor { ColorAnimation { duration: 200 } }

    Behavior on priorityLowColor { ColorAnimation { duration: 200 } }
    Behavior on priorityMediumColor { ColorAnimation { duration: 200 } }
    Behavior on priorityHighColor { ColorAnimation { duration: 200 } }
    Behavior on priorityUrgentColor { ColorAnimation { duration: 200 } }

    Behavior on statusCompletedColor { ColorAnimation { duration: 200 } }
    Behavior on statusInProgressColor { ColorAnimation { duration: 200 } }
    Behavior on statusPendingColor { ColorAnimation { duration: 200 } }
    Behavior on statusOverdueColor { ColorAnimation { duration: 200 } }

    Behavior on dialogBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on dialogTextColor { ColorAnimation { duration: 200 } }
    Behavior on dialogHeaderTextColor { ColorAnimation { duration: 200 } }
    Behavior on dialogFooterBackgroundColor { ColorAnimation { duration: 200 } }
    Behavior on dialogButtonTextColor { ColorAnimation { duration: 200 } }

    Behavior on errorColor { ColorAnimation { duration: 200 } }
    Behavior on successColor { ColorAnimation { duration: 200 } }
    Behavior on warningColor { ColorAnimation { duration: 200 } }
    Behavior on infoColor { ColorAnimation { duration: 200 } }

    function setTheme(newIndex) {
        SettingsManager.setThemeIndex(newIndex);
    }

    function getThemeName(index) {
        return themeNames[index];
    }

    function getAvailableThemes() {
        return themeNames;
    }
}
