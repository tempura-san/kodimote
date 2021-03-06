/*****************************************************************************
 * Copyright: 2011-2013 Michael Zanetti <michael_zanetti@gmx.net>            *
 *            2014      Robert Meijers <robert.meijers@gmail.com>            *
 *                                                                           *
 * This file is part of Kodiremote                                           *
 *                                                                           *
 * Kodiremote is free software: you can redistribute it and/or modify        *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, either version 3 of the License, or         *
 * (at your option) any later version.                                       *
 *                                                                           *
 * Kodiremote is distributed in the hope that it will be useful,             *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU General Public License for more details.                              *
 *                                                                           *
 * You should have received a copy of the GNU General Public License         *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                           *
 ****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaListView {
        id: listView
        anchors.fill: parent
        model: kodiMenuModel

        header: PageHeader {
            title: qsTr("Kodi on %1").arg(kodi.connectedHostName)
        }

        delegate: ListItem {
            id: listItem

            contentHeight: Theme.itemSizeExtraLarge

            onClicked: kodiMenuModel.click(index)

            Image {
                id: img
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter

                source: icon
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: img.right
                anchors.right: parent.right
                anchors.leftMargin: 14

                Label {
                    id: mainText
                    text: listView.model.title(index)
                    font.weight: Font.Bold
                    font.pixelSize: Theme.fontSizeLarge
                }
            }
        }

        ListModel {
            id: kodiMenuModelTemplate
            ListElement {
                icon: "image://theme/icon-l-people"
                target: "changeUser"
            }
            ListElement {
                icon: "image://theme/icon-l-dismiss"
                target: "quit"
            }
            ListElement {
                icon: "image://theme/icon-l-power"
                target: "shutdown"
            }
            ListElement {
                icon: "../icons/icon-l-reboot.png"
                target: "reboot"
            }
            ListElement {
                icon: "../icons/icon-l-suspend.png"
                target: "suspend"
            }
            ListElement {
                icon: "../icons/icon-l-hibernate.png"
                target: "hibernate"
            }
        }

        ListModel {
            id: kodiMenuModel
            // workaround: its not possible to have qsTr() in ListElements for now...
            function title(index) {
                var item = kodiMenuModel.get(index);

                if (item) {
                    var target = kodiMenuModel.get(index).target;
                    if (target === "changeUser") {
                        return qsTr("Change user");
                    }
                    if (target === "quit") {
                        return qsTr("Quit");
                    }
                    if (target === "shutdown") {
                        return qsTr("Shutdown");
                    }
                    if (target === "reboot") {
                        return qsTr("Reboot");
                    }
                    if (target === "suspend") {
                        return qsTr("Suspend");
                    }
                    if (target === "hibernate") {
                        return qsTr("Hibernate");
                    }
                }
                return "";
            }

            function click(index) {
                var item = kodiMenuModel.get(index);

                if (!item) {
                    return;
                }

                var target = kodiMenuModel.get(index).target;
                if (target === "changeUser") {
                    pageStack.push("ProfileSelectionDialog.qml");
                }
                else if (target === "quit") {
                    kodi.quit();
                }
                else if (target === "shutdown") {
                    kodi.shutdown();
                }
                else if (target === "reboot") {
                    kodi.reboot();
                }
                else if (target === "suspend") {
                    kodi.suspend();
                }
                else if (target === "hibernate") {
                    kodi.hibernate();
                }
            }
        }
    }

    function populateKodiMenu() {
        kodiMenuModel.clear();
        if (kodi.profiles().count > 1) {
            kodiMenuModel.append(kodiMenuModelTemplate.get(0));
        }
        kodiMenuModel.append(kodiMenuModelTemplate.get(1));
        if (kodi.canShutdown) {
            kodiMenuModel.append(kodiMenuModelTemplate.get(2));
        }
        if (kodi.canReboot) {
            kodiMenuModel.append(kodiMenuModelTemplate.get(3));
        }
        if (kodi.canShutdown) {
            kodiMenuModel.append(kodiMenuModelTemplate.get(4));
        }
        if (kodi.canHibernate) {
            kodiMenuModel.append(kodiMenuModelTemplate.get(5));
        }
    }

    Component.onCompleted: {
        populateKodiMenu();
    }

    Connections {
        target: kodi
        onSystemPropertiesChanged: populateKodiMenu();
    }

    Connections {
        target: kodi.profiles()
        onCountChanged: populateKodiMenu();
    }
}
