import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Page {
    id: page

    title: qsTr("Cinema Image")

    padding: 20


    property alias comboBoxoption: comboBoxoption
    property alias comboBoxgenre: comboBoxgenre
    property alias comboBoxcountry: comboBoxcountry
    property alias comboBoxdesign: comboBoxdesign

    //property alias publishTimeStamp : publishStamp;
    GridLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        columns: 2
        rows: 5
        rowSpacing: 5
        columnSpacing: 5

        Label {
            text: qsTr("Option")
        }

        StringXmlResourceComboBox {
            id: comboBoxoption
            Layout.preferredWidth: 200
            attributeName: "cinemaViewSpinnerArray"
        }

        Label {
            text: qsTr("Genre")
        }

        ExtendedComboBox {
            id: comboBoxgenre
            Layout.preferredWidth: 200
            model: StringXmlResourceModel {
                attributeName: "cinemaGenreSpinnerArray"
            }
            // TODO must be a checkable combo box
            //            delegate: CheckBox {
            //            }
            Component.onCompleted: currentIndex = 0
        }

        Label {
            Layout.columnSpan: 2
            id: labelCheckedGenres
        }

        Label {
            text: qsTr("Country")
        }

        StringXmlResourceComboBox {
            id: comboBoxcountry
            Layout.preferredWidth: 200
            attributeName: "countrySpinnerArray"
        }

        Label {
            text: qsTr("Design")
        }

        StringXmlResourceComboBox {
            id: comboBoxdesign
            Layout.preferredWidth: 200
            attributeName: "cinemaDesignSpinnerArray"
        }
    }
}
