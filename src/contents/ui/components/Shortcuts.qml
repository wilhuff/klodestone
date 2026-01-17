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

    // Halves shortcuts (horizontal)
    ShortcutHandler {
        name: "KLodestone: Halves - Move Left"
        text: "KLodestone: Halves - Move Left"
        sequence: "Ctrl+Alt+H"
        onActivated: moveToLeftHalf()
    }

    ShortcutHandler {
        name: "KLodestone: Halves - Move Right"
        text: "KLodestone: Halves - Move Right"
        sequence: "Ctrl+Alt+L"
        onActivated: moveToRightHalf()
    }

    // Halves shortcuts (vertical)
    ShortcutHandler {
        name: "KLodestone: Halves - Move Top"
        text: "KLodestone: Halves - Move Top"
        sequence: "Ctrl+Alt+K"
        onActivated: moveToTopHalf()
    }

    ShortcutHandler {
        name: "KLodestone: Halves - Move Bottom"
        text: "KLodestone: Halves - Move Bottom"
        sequence: "Ctrl+Alt+J"
        onActivated: moveToBottomHalf()
    }

    // Quarters shortcuts
    ShortcutHandler {
        name: "KLodestone: Quarters - Move Top Left"
        text: "KLodestone: Quarters - Move Top Left"
        sequence: "Ctrl+Alt+U"
        onActivated: moveToTopLeftQuarter()
    }

    ShortcutHandler {
        name: "KLodestone: Quarters - Move Top Right"
        text: "KLodestone: Quarters - Move Top Right"
        sequence: "Ctrl+Alt+I"
        onActivated: moveToTopRightQuarter()
    }

    ShortcutHandler {
        name: "KLodestone: Quarters - Move Bottom Left"
        text: "KLodestone: Quarters - Move Bottom Left"
        sequence: "Ctrl+Alt+N"
        onActivated: moveToBottomLeftQuarter()
    }

    ShortcutHandler {
        name: "KLodestone: Quarters - Move Bottom Right"
        text: "KLodestone: Quarters - Move Bottom Right"
        sequence: "Ctrl+Alt+M"
        onActivated: moveToBottomRightQuarter()
    }

    // Thirds shortcuts
    ShortcutHandler {
        name: "KLodestone: Thirds - Move Left"
        text: "KLodestone: Thirds - Move Left"
        sequence: "Ctrl+Alt+D"
        onActivated: moveToLeftThird()
    }

    ShortcutHandler {
        name: "KLodestone: Thirds - Move Center"
        text: "KLodestone: Thirds - Move Center"
        sequence: "Ctrl+Alt+F"
        onActivated: moveToCenterThird()
    }

    ShortcutHandler {
        name: "KLodestone: Thirds - Move Right"
        text: "KLodestone: Thirds - Move Right"
        sequence: "Ctrl+Alt+G"
        onActivated: moveToRightThird()
    }

    // Two Thirds shortcuts
    ShortcutHandler {
        name: "KLodestone: Two Thirds - Move Left"
        text: "KLodestone: Two Thirds - Move Left"
        sequence: "Ctrl+Alt+E"
        onActivated: moveToLeftTwoThirds()
    }

    ShortcutHandler {
        name: "KLodestone: Two Thirds - Move Right"
        text: "KLodestone: Two Thirds - Move Right"
        sequence: "Ctrl+Alt+T"
        onActivated: moveToRightTwoThirds()
    }
}
