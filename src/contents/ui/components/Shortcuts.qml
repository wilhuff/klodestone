import QtQuick
import org.kde.kwin

Item {

    // Thirds
    signal moveToLeftThird()
    signal moveToCenterThird()
    signal moveToRightThird()

    // Two-thirds
    signal moveToLeftTwoThirds()
    signal moveToRightTwoThirds()

    // Halves (horizontal)
    signal moveToLeftHalf()
    signal moveToRightHalf()

    // Halves (vertical)
    signal moveToTopHalf()
    signal moveToBottomHalf()

    // Quarters
    signal moveToTopLeftQuarter()
    signal moveToTopRightQuarter()
    signal moveToBottomLeftQuarter()
    signal moveToBottomRightQuarter()

    // Thirds shortcuts
    ShortcutHandler {
        name: "KLodestone: Move to left third"
        text: "KLodestone: Move to left third"
        sequence: "Ctrl+Alt+D"
        onActivated: moveToLeftThird()
    }

    ShortcutHandler {
        name: "KLodestone: Move to center third"
        text: "KLodestone: Move to center third"
        sequence: "Ctrl+Alt+F"
        onActivated: moveToCenterThird()
    }

    ShortcutHandler {
        name: "KLodestone: Move to right third"
        text: "KLodestone: Move to right third"
        sequence: "Ctrl+Alt+G"
        onActivated: moveToRightThird()
    }

    // Two-thirds shortcuts
    ShortcutHandler {
        name: "KLodestone: Move to left two-thirds"
        text: "KLodestone: Move to left two-thirds"
        sequence: "Ctrl+Alt+E"
        onActivated: moveToLeftTwoThirds()
    }

    ShortcutHandler {
        name: "KLodestone: Move to right two-thirds"
        text: "KLodestone: Move to right two-thirds"
        sequence: "Ctrl+Alt+T"
        onActivated: moveToRightTwoThirds()
    }

    // Halves shortcuts (horizontal)
    ShortcutHandler {
        name: "KLodestone: Move to left half"
        text: "KLodestone: Move to left half"
        sequence: "Ctrl+Alt+H"
        onActivated: moveToLeftHalf()
    }

    ShortcutHandler {
        name: "KLodestone: Move to right half"
        text: "KLodestone: Move to right half"
        sequence: "Ctrl+Alt+L"
        onActivated: moveToRightHalf()
    }

    // Halves shortcuts (vertical)
    ShortcutHandler {
        name: "KLodestone: Move to top half"
        text: "KLodestone: Move to top half"
        sequence: "Ctrl+Alt+K"
        onActivated: moveToTopHalf()
    }

    ShortcutHandler {
        name: "KLodestone: Move to bottom half"
        text: "KLodestone: Move to bottom half"
        sequence: "Ctrl+Alt+J"
        onActivated: moveToBottomHalf()
    }

    // Quarters shortcuts
    ShortcutHandler {
        name: "KLodestone: Move to top-left quarter"
        text: "KLodestone: Move to top-left quarter"
        sequence: "Ctrl+Alt+U"
        onActivated: moveToTopLeftQuarter()
    }

    ShortcutHandler {
        name: "KLodestone: Move to top-right quarter"
        text: "KLodestone: Move to top-right quarter"
        sequence: "Ctrl+Alt+I"
        onActivated: moveToTopRightQuarter()
    }

    ShortcutHandler {
        name: "KLodestone: Move to bottom-left quarter"
        text: "KLodestone: Move to bottom-left quarter"
        sequence: "Ctrl+Alt+N"
        onActivated: moveToBottomLeftQuarter()
    }

    ShortcutHandler {
        name: "KLodestone: Move to bottom-right quarter"
        text: "KLodestone: Move to bottom-right quarter"
        sequence: "Ctrl+Alt+M"
        onActivated: moveToBottomRightQuarter()
    }
}
