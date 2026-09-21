/*
    SPDX-FileCopyrightText: 2011 Martin Gräßlin <mgraesslin@kde.org>
    SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2015-2018 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2021 Mikel Johnson <mikel5764@gmail.com>
    SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import org.kde.ksvg as KSvg
import org.kde.plasma.plasmoid
import org.kde.plasma.workspace.trianglemousefilter

FocusScope {
    id: root

    property real preferredSideBarWidth: implicitSideBarWidth
    property real preferredSideBarHeight: implicitSideBarHeight

    property alias sideBarComponent: sideBarLoader.sourceComponent
    property alias sideBarItem: sideBarLoader.item
    property alias contentAreaComponent: contentAreaLoader.sourceComponent
    property alias contentAreaItem: contentAreaLoader.item

    property alias implicitSideBarWidth: sideBarLoader.implicitWidth
    property alias implicitSideBarHeight: sideBarLoader.implicitHeight

    implicitWidth: preferredSideBarWidth + separator.implicitWidth + contentAreaLoader.implicitWidth
    implicitHeight: Math.max(preferredSideBarHeight, contentAreaLoader.implicitHeight)

    TriangleMouseFilter {
        id: sideBarFilter
        active: Plasmoid.configuration.switchCategoryOnHover
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        LayoutMirroring.enabled: mosLauncher.sideBarOnRight
        implicitWidth: root.preferredSideBarWidth
        implicitHeight: root.preferredSideBarHeight
        edge: mosLauncher.sideBarOnRight ? Qt.LeftEdge : Qt.RightEdge
        blockFirstEnter: true
        Loader {
            id: sideBarLoader
            anchors.fill: parent
            // When positioned after the content area, Tab should go to the start of the footer focus chain
            Keys.onTabPressed: event => {
                (mosLauncher.paneSwap ? mosLauncher.footer.nextItemInFocusChain() : contentAreaLoader)
                    .forceActiveFocus(Qt.TabFocusReason);
            }
            Keys.onBacktabPressed: event => {
                (mosLauncher.paneSwap ? contentAreaLoader : mosLauncher.header.pinButton)
                    .forceActiveFocus(Qt.BacktabFocusReason);
            }
            Keys.onLeftPressed: event => {
                if (mosLauncher.sideBarOnRight) {
                    contentAreaLoader.forceActiveFocus();
                }
            }
            Keys.onRightPressed: event => {
                if (!mosLauncher.sideBarOnRight) {
                    contentAreaLoader.forceActiveFocus();
                }
            }
            Keys.onUpPressed: event => {
                mosLauncher.header.nextItemInFocusChain()
                    .forceActiveFocus(Qt.BacktabFocusReason);
            }
            Keys.onDownPressed: event => {
                (mosLauncher.paneSwap ? mosLauncher.footer.leaveButtons.nextItemInFocusChain() : mosLauncher.footer.tabBar)
                    .forceActiveFocus(Qt.TabFocusReason);
            }
        }
    }
    KSvg.SvgItem {
        id: separator
        anchors {
            top: parent.top
            left: sideBarFilter.right
            bottom: parent.bottom
        }
        LayoutMirroring.enabled: mosLauncher.sideBarOnRight
        implicitWidth: naturalSize.width
        implicitHeight: implicitWidth
        elementId: "vertical-line"
        svg: MosSingleton.lineSvg
    }
    Loader {
        id: contentAreaLoader
        focus: true
        anchors {
            top: parent.top
            left: separator.right
            right: parent.right
            bottom: parent.bottom
        }
        LayoutMirroring.enabled: mosLauncher.sideBarOnRight
        // When positioned after the sidebar, Tab should go to the start of the footer focus chain
        Keys.onTabPressed: event => {
            (mosLauncher.paneSwap ? sideBarLoader : mosLauncher.footer.nextItemInFocusChain())
                .forceActiveFocus(Qt.TabFocusReason)
        }
        Keys.onBacktabPressed: event => {
            (mosLauncher.paneSwap ? mosLauncher.header.avatar : sideBarLoader)
                .forceActiveFocus(Qt.BacktabFocusReason)
        }
        Keys.onLeftPressed: event => {
            if (!mosLauncher.sideBarOnRight) {
                sideBarLoader.forceActiveFocus();
            }
        }
        Keys.onRightPressed: event => {
            if (mosLauncher.sideBarOnRight) {
                sideBarLoader.forceActiveFocus();
            }
        }
        Keys.onUpPressed: event => {
            mosLauncher.searchField.forceActiveFocus(Qt.BacktabFocusReason);
        }
        Keys.onDownPressed: event => {
            (mosLauncher.paneSwap ? mosLauncher.footer.tabBar : mosLauncher.footer.leaveButtons.nextItemInFocusChain())
                .forceActiveFocus(Qt.TabFocusReason)
        }
    }
}
