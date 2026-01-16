import QtQuick
import QtQuick.Layouts
import org.kde.kwin
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore

import "components" as Components

PlasmaCore.Dialog {

    // api documentation
    // https://api.kde.org/frameworks/plasma-framework/html/classPlasmaQuick_1_1Dialog.html
    // https://api.kde.org/frameworks/plasma-framework/html/classPlasma_1_1Types.html
    // https://develop.kde.org/docs/getting-started/kirigami/style-colors/

    id: mainDialog

    // properties
    property bool shown: false
    property bool moving: false
    property bool moved: false
    property var clientArea: ({})
    property var cachedClientArea: ({})
    property var displaySize: ({})
    property var activeScreen: null
    property var config: ({})
    property string highlightedPosition: ""

    // Track window positions for screen cycling (maps client.internalId -> positionName)
    property var windowPositions: ({})

    // Fixed position presets (percentages)
    readonly property var positions: ({
        // Thirds
        "leftThird":       { x: 0,     y: 0, width: 33.33, height: 100, edge: "left", name: "Left Third" },
        "centerThird":     { x: 33.33, y: 0, width: 33.34, height: 100, edge: null, name: "Center Third" },
        "rightThird":      { x: 66.67, y: 0, width: 33.33, height: 100, edge: "right", name: "Right Third" },
        // Two-thirds overlaps
        "leftTwoThirds":   { x: 0,     y: 0, width: 66.67, height: 100, edge: "left", name: "Left Two Thirds" },
        "rightTwoThirds":  { x: 33.33, y: 0, width: 66.67, height: 100, edge: "right", name: "Right Two Thirds" },
        // Horizontal halves
        "leftHalf":        { x: 0,  y: 0, width: 50, height: 100, edge: "left", name: "Left Half" },
        "rightHalf":       { x: 50, y: 0, width: 50, height: 100, edge: "right", name: "Right Half" },
        // Vertical halves
        "topHalf":         { x: 0, y: 0,  width: 100, height: 50, edge: "top", name: "Top Half" },
        "bottomHalf":      { x: 0, y: 50, width: 100, height: 50, edge: "bottom", name: "Bottom Half" },
        // Quarters
        "topLeftQuarter":     { x: 0,  y: 0,  width: 50, height: 50, edge: "left", name: "Top Left" },
        "topRightQuarter":    { x: 50, y: 0,  width: 50, height: 50, edge: "right", name: "Top Right" },
        "bottomLeftQuarter":  { x: 0,  y: 50, width: 50, height: 50, edge: "left", name: "Bottom Left" },
        "bottomRightQuarter": { x: 50, y: 50, width: 50, height: 50, edge: "right", name: "Bottom Right" }
    })

    title: "KLodestone"
    location: PlasmaCore.Types.Desktop
    type: PlasmaCore.Dialog.OnScreenDisplay
    backgroundHints: PlasmaCore.Types.NoBackground
    flags: Qt.BypassWindowManagerHint | Qt.FramelessWindowHint | Qt.Popup
    hideOnWindowDeactivate: true
    visible: false
    outputOnly: true
    opacity: 1
    width: displaySize.width
    height: displaySize.height

    function loadConfig() {
        config = {
            // enable edge snapping
            enableEdgeSnapping: KWin.readConfig("enableEdgeSnapping", true),
            // distance from the edge of the screen to trigger the edge snapping
            edgeSnappingTriggerDistance: KWin.readConfig("edgeSnappingTriggerDistance", 1),
            // remember window geometries before snapping, and restore them when the window is removed
            rememberWindowGeometries: KWin.readConfig("rememberWindowGeometries", true),
            // show osd messages
            showOsdMessages: KWin.readConfig("showOsdMessages", true),
            // filter mode
            filterMode: KWin.readConfig("filterMode", 0),
            // filter list
            filterList: KWin.readConfig("filterList", ""),
            // polling rate in milliseconds
            pollingRate: KWin.readConfig("pollingRate", 100),
            // enable debug logging
            enableDebugLogging: KWin.readConfig("enableDebugLogging", false)
        };

        log("Config loaded: " + JSON.stringify(config));
    }

    function log(message) {
        if (!config.enableDebugLogging) return;
        console.log("KLodestone: " + message);
    }

    function show() {
        log("Show");
        mainDialog.shown = true;
        mainDialog.visible = true;
        mainDialog.setWidth(Workspace.virtualScreenSize.width);
        mainDialog.setHeight(Workspace.virtualScreenSize.height);
        refreshClientArea();
    }

    function hide() {
        mainDialog.shown = false;
        mainDialog.visible = false;
        highlightedPosition = "";
    }

    function refreshClientArea() {
        activeScreen = Workspace.activeScreen;
        clientArea = Workspace.clientArea(KWin.FullScreenArea, activeScreen, Workspace.currentDesktop);
        displaySize = Workspace.virtualScreenSize;
    }

    function checkFilter(client) {
        if (!client) return false;
        if (!client.normalWindow) return false;
        if (client.popupWindow) return false;
        if (client.skipTaskbar) return false;

        const filter = config.filterList.split(/\r?\n/);
        if (config.filterList.length > 0) {
            if (config.filterMode == 0) {
                // include
                return filter.includes(client.resourceClass.toString());
            }
            if (config.filterMode == 1) {
                // exclude
                return !filter.includes(client.resourceClass.toString());
            }
        }
        return true;
    }

    function moveClientToPosition(client, positionName) {
        if (!checkFilter(client)) return;

        const position = positions[positionName];
        if (!position) {
            log("Unknown position: " + positionName);
            return;
        }

        log("Moving client " + client.resourceClass.toString() + " to position " + positionName);

        refreshClientArea();

        // Calculate geometry from percentage-based position
        const newGeometry = Qt.rect(
            Math.round(clientArea.x + (position.x / 100) * clientArea.width),
            Math.round(clientArea.y + (position.y / 100) * clientArea.height),
            Math.round((position.width / 100) * clientArea.width),
            Math.round((position.height / 100) * clientArea.height)
        );

        // Save old geometry if this is the first snap
        if (config.rememberWindowGeometries && !windowPositions[client.internalId]) {
            client.oldGeometry = {
                x: client.frameGeometry.x,
                y: client.frameGeometry.y,
                width: client.frameGeometry.width,
                height: client.frameGeometry.height
            };
        }

        log("New geometry: " + JSON.stringify(newGeometry));
        client.setMaximize(false, false);
        client.frameGeometry = newGeometry;

        // Track position for screen cycling
        windowPositions[client.internalId] = positionName;

        // Show OSD
        osdDbus.exec(position.name);
    }

    function getAdjacentScreen(currentOutput, direction) {
        const screens = Workspace.screens;
        if (screens.length <= 1) return null;

        const currentGeo = currentOutput.geometry;
        const currentCenterX = currentGeo.x + currentGeo.width / 2;
        const currentCenterY = currentGeo.y + currentGeo.height / 2;

        let bestScreen = null;
        let bestDistance = Infinity;

        for (let i = 0; i < screens.length; i++) {
            const screen = screens[i];
            if (screen === currentOutput) continue;

            const geo = screen.geometry;
            const centerX = geo.x + geo.width / 2;
            const centerY = geo.y + geo.height / 2;

            let isInDirection = false;
            let distance = Infinity;

            if (direction === "right" && centerX > currentCenterX) {
                isInDirection = true;
                distance = centerX - currentCenterX;
            } else if (direction === "left" && centerX < currentCenterX) {
                isInDirection = true;
                distance = currentCenterX - centerX;
            } else if (direction === "bottom" && centerY > currentCenterY) {
                isInDirection = true;
                distance = centerY - currentCenterY;
            } else if (direction === "top" && centerY < currentCenterY) {
                isInDirection = true;
                distance = currentCenterY - centerY;
            }

            if (isInDirection && distance < bestDistance) {
                bestDistance = distance;
                bestScreen = screen;
            }
        }

        return bestScreen;
    }

    function moveClientToPositionOnScreen(client, positionName, targetScreen) {
        if (!checkFilter(client)) return;

        const position = positions[positionName];
        if (!position) {
            log("Unknown position: " + positionName);
            return;
        }

        log("Moving client " + client.resourceClass.toString() + " to position " + positionName + " on screen " + targetScreen.name);

        const targetClientArea = Workspace.clientArea(KWin.FullScreenArea, targetScreen, Workspace.currentDesktop);
        log("Target client area: " + JSON.stringify({x: targetClientArea.x, y: targetClientArea.y, width: targetClientArea.width, height: targetClientArea.height}));
        log("Position config: " + JSON.stringify(position));

        // Calculate geometry from percentage-based position on target screen
        const newGeometry = Qt.rect(
            Math.round(targetClientArea.x + (position.x / 100) * targetClientArea.width),
            Math.round(targetClientArea.y + (position.y / 100) * targetClientArea.height),
            Math.round((position.width / 100) * targetClientArea.width),
            Math.round((position.height / 100) * targetClientArea.height)
        );
        log("Calculated new geometry: " + JSON.stringify({x: newGeometry.x, y: newGeometry.y, width: newGeometry.width, height: newGeometry.height}));

        // Save old geometry if this is the first snap
        if (config.rememberWindowGeometries && !windowPositions[client.internalId]) {
            client.oldGeometry = {
                x: client.frameGeometry.x,
                y: client.frameGeometry.y,
                width: client.frameGeometry.width,
                height: client.frameGeometry.height
            };
        }

        log("New geometry: " + JSON.stringify(newGeometry));
        client.setMaximize(false, false);

        // First move the window to the target screen using KWin's API
        Workspace.sendClientToScreen(client, targetScreen);

        // Then apply the geometry on the target screen
        client.frameGeometry = newGeometry;

        // Track position for screen cycling
        windowPositions[client.internalId] = positionName;

        // Show OSD
        osdDbus.exec(position.name);
    }

    function moveClientToPositionOrCycleScreen(client, positionName) {
        if (!checkFilter(client)) return;

        const position = positions[positionName];
        if (!position) return;

        const currentPos = windowPositions[client.internalId];

        // If already at this position on current screen, try cycling to adjacent screen
        if (currentPos === positionName && position.edge) {
            const adjacentScreen = getAdjacentScreen(client.output, position.edge);

            if (adjacentScreen) {
                log("Moving to adjacent screen: " + adjacentScreen.name);
                // Clear tracked position so it gets set fresh on new screen
                delete windowPositions[client.internalId];
                // Move directly to position on the target screen
                moveClientToPositionOnScreen(client, positionName, adjacentScreen);
                return;
            }
            // At boundary - no adjacent screen in that direction
            log("At screen boundary, staying in place");
            return;
        }

        // First press or different position - apply it
        moveClientToPosition(client, positionName);
    }

    function detectEdgePosition() {
        const triggerDistance = (config.edgeSnappingTriggerDistance + 1) * 10;
        const x = Workspace.cursorPos.x;
        const y = Workspace.cursorPos.y;

        const nearLeft = x <= clientArea.x + triggerDistance;
        const nearRight = x >= clientArea.x + clientArea.width - triggerDistance;
        const nearTop = y <= clientArea.y + triggerDistance;
        const nearBottom = y >= clientArea.y + clientArea.height - triggerDistance;

        // Corners first (most specific)
        if (nearLeft && nearTop) return "topLeftQuarter";
        if (nearRight && nearTop) return "topRightQuarter";
        if (nearLeft && nearBottom) return "bottomLeftQuarter";
        if (nearRight && nearBottom) return "bottomRightQuarter";

        // Edges
        if (nearLeft) return "leftHalf";
        if (nearRight) return "rightHalf";
        if (nearTop) return "topHalf";
        if (nearBottom) return "bottomHalf";

        return "";  // Not near any edge
    }

    function connectSignals(client) {
        if (!checkFilter(client)) return;

        log("Connecting signals for client " + client.resourceClass.toString());

        client.onInteractiveMoveResizeStarted.connect(onInteractiveMoveResizeStarted);
        client.onInteractiveMoveResizeStepped.connect(onInteractiveMoveResizeStepped);
        client.onInteractiveMoveResizeFinished.connect(onInteractiveMoveResizeFinished);

        function onInteractiveMoveResizeStarted() {
            log("Interactive move/resize started for client " + client.resourceClass.toString());
            if (client.resizeable && checkFilter(client)) {
                if (client.move && checkFilter(client)) {
                    cachedClientArea = clientArea;

                    // Restore old geometry when starting to move a snapped window
                    if (config.rememberWindowGeometries && windowPositions[client.internalId]) {
                        if (client.oldGeometry) {
                            const geometry = client.oldGeometry;
                            const newGeometry = Qt.rect(
                                Math.round(Workspace.cursorPos.x - geometry.width / 2),
                                Math.round(client.frameGeometry.y),
                                Math.round(geometry.width),
                                Math.round(geometry.height)
                            );
                            client.frameGeometry = newGeometry;
                        }
                    }

                    moving = true;
                    moved = false;
                    log("Move start " + client.resourceClass.toString());

                    if (config.enableEdgeSnapping) {
                        mainDialog.show();
                    }
                }
            }
        }

        function onInteractiveMoveResizeStepped() {
            if (client.resizeable) {
                if (moving && checkFilter(client)) {
                    moved = true;
                }
            }
        }

        function onInteractiveMoveResizeFinished() {
            log("Interactive move/resize finished for client " + client.resourceClass.toString());

            if (moving) {
                log("Move end " + client.resourceClass.toString());
                if (moved && config.enableEdgeSnapping && highlightedPosition) {
                    moveClientToPosition(client, highlightedPosition);
                } else if (moved) {
                    // Window was moved but not snapped - clear its tracked position
                    delete windowPositions[client.internalId];
                }
                hide();
            }
            moving = false;
            moved = false;
        }
    }

    Components.Shortcuts {
        // Thirds
        onMoveToLeftThird: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "leftThird")
        onMoveToCenterThird: moveClientToPosition(Workspace.activeWindow, "centerThird")  // No cycling for center
        onMoveToRightThird: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "rightThird")

        // Two-thirds
        onMoveToLeftTwoThirds: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "leftTwoThirds")
        onMoveToRightTwoThirds: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "rightTwoThirds")

        // Halves
        onMoveToLeftHalf: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "leftHalf")
        onMoveToRightHalf: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "rightHalf")
        onMoveToTopHalf: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "topHalf")
        onMoveToBottomHalf: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "bottomHalf")

        // Quarters
        onMoveToTopLeftQuarter: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "topLeftQuarter")
        onMoveToTopRightQuarter: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "topRightQuarter")
        onMoveToBottomLeftQuarter: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "bottomLeftQuarter")
        onMoveToBottomRightQuarter: moveClientToPositionOrCycleScreen(Workspace.activeWindow, "bottomRightQuarter")
    }

    Component.onCompleted: {
        refreshClientArea();
        mainDialog.loadConfig();

        // Connect signals for existing windows
        for (let i = 0; i < Workspace.stackingOrder.length; i++) {
            connectSignals(Workspace.stackingOrder[i]);
        }
    }

    Item {
        id: mainItem

        // Polling timer for edge snapping detection during window drag
        Timer {
            id: timer

            triggeredOnStart: true
            interval: config.pollingRate
            running: shown && moving && config.enableEdgeSnapping
            repeat: true

            onTriggered: {
                refreshClientArea();

                const detectedPosition = detectEdgePosition();

                if (detectedPosition !== highlightedPosition) {
                    log("Edge position: " + (detectedPosition || "none"));
                    highlightedPosition = detectedPosition;
                }
            }
        }

        DBusCall {
            id: osdDbus

            service: "org.kde.plasmashell"
            path: "/org/kde/osdService"
            method: "showText"

            function exec(text, icon = "preferences-desktop-virtual") {
                if (!config.showOsdMessages) return;
                this.arguments = [icon, text];
                this.call();
            }
        }

        Item {
            x: clientArea.x || 0
            y: clientArea.y || 0
            width: clientArea.width || 0
            height: clientArea.height || 0
            clip: true

            Components.Debug {
                info: ({
                    activeWindow: {
                        caption: Workspace.activeWindow?.caption,
                        resourceClass: Workspace.activeWindow?.resourceClass?.toString(),
                        frameGeometry: {
                            x: Workspace.activeWindow?.frameGeometry?.x,
                            y: Workspace.activeWindow?.frameGeometry?.y,
                            width: Workspace.activeWindow?.frameGeometry?.width,
                            height: Workspace.activeWindow?.frameGeometry?.height
                        },
                        position: windowPositions[Workspace.activeWindow?.internalId]
                    },
                    highlightedPosition: highlightedPosition,
                    moving: moving,
                    oldGeometry: Workspace.activeWindow?.oldGeometry,
                    activeScreen: activeScreen?.name
                })
                config: mainDialog.config
            }
        }

        // Workspace connection for new windows
        Connections {
            target: Workspace

            function onWindowAdded(client) {
                connectSignals(client);
            }
        }

        // Options connection
        Connections {
            target: Options

            function onConfigChanged() {
                log("Config changed");
                mainDialog.loadConfig();
            }
        }
    }
}
