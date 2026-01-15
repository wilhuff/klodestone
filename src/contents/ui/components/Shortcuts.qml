import QtQuick
import org.kde.kwin

Item {

    signal cycleLayouts()

    ShortcutHandler {
        name: "KLodestone: Cycle layouts"
        text: "KLodestone: Cycle layouts"
        sequence: "Ctrl+Alt+D"
        onActivated: {
            cycleLayouts();
        }
    }

    signal cycleLayoutsReversed()

    ShortcutHandler {
        name: "KLodestone: Cycle layouts (reversed)"
        text: "KLodestone: Cycle layouts (reversed)"
        sequence: "Ctrl+Alt+Shift+D"
        onActivated: {
            cycleLayoutsReversed();
        }
    }

    signal moveActiveWindowToNextZone()

    ShortcutHandler {
        name: "KLodestone: Move active window to next zone"
        text: "KLodestone: Move active window to next zone"
        sequence: "Ctrl+Alt+Right"
        onActivated: {
            moveActiveWindowToNextZone()
        }
    }

    signal moveActiveWindowToPreviousZone()

    ShortcutHandler {
        name: "KLodestone: Move active window to previous zone"
        text: "KLodestone: Move active window to previous zone"
        sequence: "Ctrl+Alt+Left"
        onActivated: {
            moveActiveWindowToPreviousZone()
        }
    }

    signal toggleZoneOverlay()

    ShortcutHandler {
        name: "KLodestone: Toggle zone overlay"
        text: "KLodestone: Toggle zone overlay"
        sequence: "Ctrl+Alt+C"
        onActivated: {
            toggleZoneOverlay();
        }
    }

    signal switchToNextWindowInCurrentZone()

    ShortcutHandler {
        name: "KLodestone: Switch to next window in current zone"
        text: "KLodestone: Switch to next window in current zone"
        sequence: "Ctrl+Alt+Up"
        onActivated: {
            switchToNextWindowInCurrentZone()
        }
    }

    signal switchToPreviousWindowInCurrentZone()

    ShortcutHandler {
        name: "KLodestone: Switch to previous window in current zone"
        text: "KLodestone: Switch to previous window in current zone"
        sequence: "Ctrl+Alt+Down"
        onActivated: {
            switchToPreviousWindowInCurrentZone()
        }
    }

    signal moveActiveWindowToZone(int zone)

    Repeater {
        model: [1, 2, 3, 4, 5, 6, 7, 8, 9]
        delegate: Item {
            ShortcutHandler {
                name: "KLodestone: Move active window to zone " + modelData
                text: "KLodestone: Move active window to zone " + modelData
                sequence: "Ctrl+Alt+Num+" + modelData
                onActivated: {
                    moveActiveWindowToZone(modelData - 1)
                }
            }
        }
    }

    signal activateLayout(int layout)

    Repeater {
        model: [1, 2, 3, 4, 5, 6, 7, 8, 9]
        delegate: Item {
            ShortcutHandler {
                name: "KLodestone: Activate layout " + modelData
                text: "KLodestone: Activate layout " + modelData
                sequence: "Meta+Num+" + modelData
                onActivated: {
                    activateLayout(modelData - 1)
                }
            }
        }
    }

    signal moveActiveWindowUp()

    ShortcutHandler {
        name: "KLodestone: Move active window up"
        text: "KLodestone: Move active window up"
        sequence: "Meta+Up"
        onActivated: {
            moveActiveWindowUp()
        }
    }

    signal moveActiveWindowDown()

    ShortcutHandler {
        name: "KLodestone: Move active window down"
        text: "KLodestone: Move active window down"
        sequence: "Meta+Down"
        onActivated: {
            moveActiveWindowDown()
        }
    }

    signal moveActiveWindowLeft()

    ShortcutHandler {
        name: "KLodestone: Move active window left"
        text: "KLodestone: Move active window left"
        sequence: "Meta+Left"
        onActivated: {
            moveActiveWindowLeft()
        }
    }

    signal moveActiveWindowRight()

    ShortcutHandler {
        name: "KLodestone: Move active window right"
        text: "KLodestone: Move active window right"
        sequence: "Meta+Right"
        onActivated: {
            moveActiveWindowRight()
        }
    }

    signal snapActiveWindow()

    ShortcutHandler {
        name: "KLodestone: Snap active window"
        text: "KLodestone: Snap active window"
        sequence: "Meta+Shift+Space"
        onActivated: {
            snapActiveWindow()
        }
    }

    signal snapAllWindows()

    ShortcutHandler {
        name: "KLodestone: Snap all windows"
        text: "KLodestone: Snap all windows"
        sequence: "Meta+Space"
        onActivated: {
            snapAllWindows()
        }
    }
}