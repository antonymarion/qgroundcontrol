/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.MultiVehicleManager
import QGroundControl.ScreenTools
import QGroundControl.Palette

//-------------------------------------------------------------------------
//-- RC RSSI Indicator
Item {
    id:             _root
    width:          rssiRow.width * 1.1
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: _activeVehicle.supportsRadio && _rcRSSIAvailable

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _rcRSSIAvailable:   _activeVehicle ? _activeVehicle.rcRSSI > 0 && _activeVehicle.rcRSSI <= 100 : false

    Component {
        id: rcRSSIInfo

        Rectangle {
            width:  rcrssiCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: rcrssiCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 rcrssiCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(rcrssiGrid.width, rssiLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             rssiLabel
                    text:           _activeVehicle ? (_activeVehicle.rcRSSI !== 255 ? qsTr("RC RSSI Status") : qsTr("RC RSSI Data Unavailable")) : qsTr("N/A", "No data available")
                    font.bold:      true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 rcrssiGrid
                    visible:            _rcRSSIAvailable
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    anchors.horizontalCenter: parent.horizontalCenter

                    QGCLabel { text: qsTr("RSSI:") }
                    QGCLabel { text: _activeVehicle ? (_activeVehicle.rcRSSI + "%") : 0 }
                }
            }
        }
    }

    Row {
        id:             rssiRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth

        QGCColoredImage {
            width:              height
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            sourceSize.height:  height
            source:             "/qmlimages/RC.svg"
            fillMode:           Image.PreserveAspectFit
            opacity:            _rcRSSIAvailable ? 1 : 0.5
            color:              qgcPal.buttonText
        }

        SignalStrength {
            anchors.verticalCenter: parent.verticalCenter
            size:                   parent.height * 0.5
            percent:                _rcRSSIAvailable ? _activeVehicle.rcRSSI : 0
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, rcRSSIInfo)
        }
    }
}
