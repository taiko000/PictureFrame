import QtQuick 2.0
import pictureframecompany.core 1.0
import "DateUtil.js" as DateUtil

CalendarMainPageForm
{
    StringXmlResourceModel
    {
        attributeName : "imageSpinnerArray"
        id : pictureTypeModel

        // cannot populate in onCompleted because XmlListModel loads asynchronously
        onStatusChanged: {
            if(status === StringXmlResourceModel.Ready)
            {
                calendarImage = get(1).text
                weatherImage= get(2).text
                newsImage= get(3).text
                footballImage= get(4).text
                cinemaImage= get(5).text
                imageFile= get(6).text

                 populate()
            }
        }

        property string calendarImage
        property string weatherImage
        property string newsImage
        property string footballImage
        property string cinemaImage
        property string imageFile
    }


    function populate()
    {

        var footballImages = DeviceAccessor.controllerDataContainer.footballImages
        footballImages.forEach(function(img)
        {
            insertSortedIntoListModel({"pictureType":pictureTypeModel.footballImage,
                                 "displayTimeInSeconds":img.displayTimeInSeconds,
                                 "formData":img})
             // {"":0,"":0} causes qml to store an QVariantList placeholder, which we can later overwrite
        })

        var newsImages = DeviceAccessor.controllerDataContainer.newsImages
        newsImages.forEach(function(img)
        {
            insertSortedIntoListModel({"pictureType":pictureTypeModel.newsImage,
                                 "displayTimeInSeconds":img.displayTimeInSeconds,
                             "formData":img})
        })

        var imageFileImages = DeviceAccessor.controllerDataContainer.imageFileImages
        imageFileImages.forEach(function(img)
        {
            insertSortedIntoListModel({"pictureType":pictureTypeModel.imageFile,
                                 "displayTimeInSeconds":img.displayTimeInSeconds,
                             "formData":img})
        })

        var calendarImages = DeviceAccessor.controllerDataContainer.calendarImages
        calendarImages.forEach(function(img)
        {
            insertSortedIntoListModel({"pictureType":pictureTypeModel.calendarImage,
                                 "displayTimeInSeconds":img.displayTimeInSeconds,
                             "formData":img})
        })

        var weatherImages = DeviceAccessor.controllerDataContainer.weatherImages
        weatherImages.forEach(function(img)
        {
            insertSortedIntoListModel({"pictureType":pictureTypeModel.weatherImage,
                                 "displayTimeInSeconds":img.displayTimeInSeconds,
                             "formData":img})
        })

        var cinemaImages = DeviceAccessor.controllerDataContainer.cinemaImages
        cinemaImages.forEach(function(img)
        {
            insertSortedIntoListModel({"pictureType":pictureTypeModel.cinemaImage,
                                 "displayTimeInSeconds":img.displayTimeInSeconds,
                             "formData":img})
        })

        if(listModel.count === 0)
        {


        listModel.append({"pictureType":qsTr("Nothing Selected"),"displayTimeInSeconds":0})
        }
    }

    // uses insertion sort algo and the index from the formData to insert it into the list
    // so that the list items' order corresponds to the formData.index indices
    function insertSortedIntoListModel(json)
    {

        var inputIndex = json.formData.index;
        for(var i = 0; i< listModel.count; ++i)
        {
            if(listModel.get(i).formData.index >= inputIndex)
            {
                listModel.insert(i,json);
                return;
            }
        }
        listModel.append(json);
    }

    onListIndexClicked: {
        var item = listModel.get(index);

        openPage(item.pictureType,
                 index,
                 item.formData)

    }

    buttonAddMorePictures.onClicked:
    {

        dialog.open();

    }



    PictureTypeSelectionDialog
    {
        id : dialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2


        onAccepted: {
            openPage(tumbler.currentItem.text,
                     -1,
                     {"":0})
        }
    }

    function openPage(pictureType, index, formData)
    {
        var pageToOpen = "";
        switch(pictureType) {
            case pictureTypeModel.calendarImage:
                pageToOpen = "CalendarImagePage.qml"
                break;
            case pictureTypeModel.weatherImage:
                pageToOpen = "WeatherImagePage.qml"
                break;
            case pictureTypeModel.cinemaImage:
                pageToOpen = "CinemaImagePage.qml"
                break;
            case pictureTypeModel.newsImage:
                pageToOpen = "NewsImagePage.qml"
                break;
            case pictureTypeModel.footballImage:
                pageToOpen = "FootballImagePage.qml"
                break;
            case pictureTypeModel.imageFile:
                LoggingFilter.setFilterRules("qt.qml.binding.removal.info=false");
                pageToOpen = "DynamicPicturePage.qml"
                break;
            default:
                console.error("No corresponding Page qml file found for picture Type " + pictureType)
                return;
        }

        var pushedPage =  stackView.push(pageToOpen,{"formData":formData});
        pushedPage.finished.connect(onPageFinished);
        // properties seems to be invisible in debugger
        Object.defineProperty(pushedPage,'index',{value:index});
        Object.defineProperty(pushedPage,'pictureType',{value:pictureType});
    }

    function onPageFinished(formData)
    {
        var currentPage = stackView.pop();
        currentPage.finished.disconnect(onPageFinished);

        // newly created page
        if(currentPage.index === -1)
        {
            listModel.append({"pictureType":currentPage.pictureType,
                                 "displayTimeInSeconds":20,
                                 "formData":{"":0,"":0}})
            var item = listModel.get(listModel.count -1);
            item.formData = formData;
            listModel.set(listModel.count -1,item); // setProperty would not work here because it takes a variant
        }
        else
        {
            var item = listModel.get(currentPage.index)
            item.formData = formData;
            listModel.set(currentPage.index,item); // setProperty would not work here because it takes a variant
        }

        // list model item is now of the following structure
        // {
        //      displayTimeInSeconds : 20
        //      formData : {
        //                  design : "someDesign"
        //                      ...
        //                  }
        //      pictureType : calendarImage
        // }

    }

     function onDoneClicked() {

        DeviceAccessor.clearLocalImageCache();

         var functionArray = [];
         var argumentArray = [];

        for(var i = 0; i < listModel.count; ++i)
        {
            var formData = listModel.get(i).formData;
            var jsonObject = {};

            // write form data (image type specific properties) into jsonObject
            for (var prop in formData) {
                if (formData.hasOwnProperty(prop))
                {
                    jsonObject[prop] = formData[prop]
                }
            }
            jsonObject.displayTimeInSeconds = listModel.get(i).displayTimeInSeconds;
            jsonObject.totalImageCount = listModel.count;
            jsonObject.index = i;
            jsonObject.publishTimeStamp = DateUtil.toShortISOString(new Date());
            jsonObject.clientID = "test_client42" // FIXME client id added by controllerConnectionManager


            switch(listModel.get(i).pictureType)
            {
                case pictureTypeModel.calendarImage:
                    argumentArray.push(jsonObject);
                    functionArray.push(function(arg)
                    {DeviceAccessor.sendCalendarImage(arg);})
                    break;
                case pictureTypeModel.weatherImage :
                    argumentArray.push(jsonObject);
                    functionArray.push(function(arg)
                    {DeviceAccessor.sendWeatherImage(arg);})
                    break;
                case pictureTypeModel.newsImage    :
                    argumentArray.push(jsonObject);
                    functionArray.push(function(arg)
                    {DeviceAccessor.sendNewsImage(arg);})
                    break;
                case pictureTypeModel.footballImage:
                    argumentArray.push(jsonObject);
                    functionArray.push(function(arg)
                    {DeviceAccessor.sendFootballImage(arg);})
                    break;
                case pictureTypeModel.cinemaImage  :
                    argumentArray.push(jsonObject);
                    functionArray.push(function(arg)
                    {DeviceAccessor.sendCinemaImage(arg);})
                    break;
                case pictureTypeModel.imageFile    :
                    argumentArray.push(jsonObject);
                    functionArray.push(function(arg)
                    {DeviceAccessor.sendImageFile(arg);})
                    break;
            }
        }
        sendDialog.sendArguments = argumentArray; // the function arguments
        sendDialog.sendFunctions = functionArray;
        sendDialog.open();


        // FIXME, transaction when storing images? should not overwrite old ControllerDataContainer immediately but only part of it
        // 2 possibilities: use SQLite in memory :memory: database or overwrite old instance of ControllerDataContainer with new one
        // when the transaction finished (simpler)
    }

    MultiSendDialog
    {
        id : sendDialog
        modal : true
        onClosed: {
            listModel.clear();
            stackView.pop();
        }
    }

}
