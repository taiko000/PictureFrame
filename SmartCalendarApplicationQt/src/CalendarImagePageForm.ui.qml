import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3


ConfirmationPage
{
    id: page    

    title: qsTr("Calendar Image")
    property alias comboBoxoption: comboBoxoption
    property alias comboBoxTimeView: comboBoxTimeView
    property alias comboBoxDesign: comboBoxDesign
    property alias comboBoxWeekType : comboBoxWeekType

    property alias spinBoxAdditionalNumberOfDays: spinBoxAdditionalNumberOfDays

    property alias spinBoxStartTime: spinBoxStartTime
    property alias spinBoxEndTime: spinBoxEndTime
    property alias buttonStartDate: buttonStartDate
    property alias comboBoxMonth: comboBoxMonth


    property bool isDayViewOption3 : comboBoxTimeView.currentIndex === 0 && comboBoxoption.currentIndex === 2;

    property bool isWeekViewOption1 : comboBoxTimeView.currentIndex === 1 && comboBoxoption.currentIndex === 0;
    property bool isWeekViewOption2 : comboBoxTimeView.currentIndex === 1 && comboBoxoption.currentIndex === 1;
    property bool isWeekViewOption3 : comboBoxTimeView.currentIndex === 1 && comboBoxoption.currentIndex === 2;

    property bool isMonthViewOption1 : comboBoxTimeView.currentIndex === 2 && comboBoxoption.currentIndex === 0;
    property bool isMonthViewOption2 : comboBoxTimeView.currentIndex === 2 && comboBoxoption.currentIndex === 1;


    GridLayout {
        anchors.left : parent.left
        anchors.right: parent.right
        anchors.top : parent.top
        columns: 3
        rows: 6
        rowSpacing: 5
        columnSpacing: 5

        Label
        {
            text : "Appearance"
        }

        StringXmlResourceComboBox
        {
            Layout.columnSpan: 2
            attributeName: "timeViewSpinnerArray"
            id : comboBoxTimeView

        }

        Label {
            text: qsTr("Option")
        }

        StringXmlResourceComboBox
        {
            id : comboBoxoption
            Layout.columnSpan: 2
            attributeName:  "formatViewSpinnerArray"
        }

        Label
        {
            text : qsTr("Start")
            id : labelStart
            visible: isDayViewOption3
        }

        SpinBox
        {
            visible: isDayViewOption3
            id : spinBoxStartTime
            up.indicator.enabled: spinBoxEndTime.value > value
            from : 0
            to : 24
            value : 8
        }

        Label
        {
            text : qsTr("In 24 hours")
            visible: isDayViewOption3
        }

        Label
        {
            text : qsTr("End")
            visible: isDayViewOption3
        }

        SpinBox
        {
            visible: isDayViewOption3
            id : spinBoxEndTime
            down.indicator.enabled: spinBoxStartTime.value < value
            from : 0
            to : 24
            value : 12
        }

        Label
        {
            text : qsTr("In 24 hours")
            visible: isDayViewOption3
        }

        Label
        {
            text : qsTr("Appearance")
            visible: isWeekViewOption1
        }

        ComboBox
        {
            visible: isWeekViewOption1
            id : comboBoxWeekType
            model : [qsTr("Work Week"),qsTr("Week")]
            Layout.columnSpan: 2
        }

        Label
        {
            visible: isWeekViewOption3 || isMonthViewOption2
            text : qsTr("Time Interval")
            Layout.columnSpan: isWeekViewOption3 ? 3 : 1 // displayed as heading for week, but on the right for month
        }

        Label
        {
            visible: isWeekViewOption3
            text : qsTr("Start Date")
        }

        Button
        {
            visible: isWeekViewOption3
            id : buttonStartDate
            Layout.columnSpan: 2
        }

        Label
        {
            visible: isWeekViewOption2 || isWeekViewOption3
            text : qsTr("Additional number of days")
        }

        SpinBox
        {
            id : spinBoxAdditionalNumberOfDays
            visible: isWeekViewOption2 || isWeekViewOption3
            Layout.columnSpan: 2
            from : 0
            to : 6
        }

        ComboBox
        {
            visible: isMonthViewOption2
            id : comboBoxMonth
            Layout.columnSpan : 2
            model : ListModel {}
            textRole : "name"
        }


        Label {
            text: qsTr("Design")
        }

        ComboBox {
            Layout.columnSpan: 2
            id : comboBoxDesign
        }

    }

}

