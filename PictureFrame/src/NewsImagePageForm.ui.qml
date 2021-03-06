import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Page {
    id: page

    title: qsTr("News Image")

    property alias comboBoxoption : comboBoxoption;
    property alias comboBoxsource : comboBoxsource;
    property alias comboBoxdesign : comboBoxdesign;

    GridLayout
    {
        id : gridLayout
        anchors.left : parent.left
        anchors.right: parent.right
        anchors.top : parent.top
        columnSpacing: 5
        rowSpacing: 5
        rows : 3
        columns :2

        Label
        {
            text : qsTr("Option")
        }

        StringXmlResourceComboBox
        {
            id : comboBoxoption
            Layout.preferredWidth: 200
            attributeName: "newsViewSpinnerArray"

        }

        Label
        {
            text : qsTr("Source")

        }

        StringXmlResourceComboBox
        {
            id : comboBoxsource
            Layout.preferredWidth: 200
            attributeName : "newsCategorySpinnerArray"

        }

        Label
        {
            text : qsTr("Design")
        }

        StringXmlResourceComboBox
        {
            id : comboBoxdesign
            Layout.preferredWidth: 200
            attributeName: "newsDesignSpinnerArray"

        }

    }
}
