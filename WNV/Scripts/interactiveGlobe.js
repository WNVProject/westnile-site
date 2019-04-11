document.getElementById('rngCtrlPnlOpacity').value = 100;
document.getElementById('rngCtrlPnlWidth').value = 40;

var CesiumAPIKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NjhhNWVlOS0yYThiLTQ3M2YtOTBiNC03ZWY0YmFhMDZiNzgiLCJpZCI6NDA4NCwic2NvcGVzIjpbImFzbCIsImFzciIsImFzdyIsImdjIl0sImlhdCI6MTUzOTg1MDc4N30.jQhxjgKS3zpd5MKaks7_oSddnE_jtCC6fFSsfFufwj8";
Cesium.Ion.defaultAccessToken = CesiumAPIKey;

var viewer = new Cesium.Viewer('cesiumContainer');
var trapGeoEntities;
var countyGeoEntitiesValues;
var globalRefCountyDataSource;
var globalRefTrapDataSource;
var maxColumnValue;
var minColumnValue;
var columnOfInterest;
var infoBoxMessage;
var mosquitoVariable;
var jsonToRender;
var mapType;
var btnHide;
var currentColumnValue;

function renderCountyPolygons(jsonString) {

    var jsonToRender = JSON.parse(jsonString);
    columnOfInterest = "Total Mosquitoes";
    var currentColumnValue;

    for (var i = 0; i < jsonToRender.length; i++) {
        var mosquitoDataRow = jsonToRender[i];
        for (var key in mosquitoDataRow) {

            currentColumnValue = mosquitoDataRow[columnOfInterest];
            if (!minColumnValue && !maxColumnValue) {
                minColumnValue = currentColumnValue;
                maxColumnValue = currentColumnValue;
            } else if (minColumnValue > currentColumnValue) {
                minColumnValue = currentColumnValue;
            } else if (maxColumnValue < currentColumnValue) {
                maxColumnValue = currentColumnValue;
            }

        }
    }
    var btnHide = document.getElementById("btnHide");
    if (btnHide.innerHTML == "Show") {
        btnHide.click();
    }


    if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        viewer.dataSources.remove(globalRefCountyDataSource, false);
    }

    var countyGeoJson = renderQuality();

    countyGeoJson.then(function (countyDataSource) {

        var chkAllStates = document.getElementById("chkAllStates").checked;
        var ddlState = document.getElementById("ddlState");
        var ddlOutlineColor = document.getElementById("ddlOutlineColor");
        var chkShowLabels = document.getElementById("chkShowLabels").checked;

        var countyGeoEntities = countyDataSource.entities;
        if (!chkAllStates) {
            var countyGeoEntitiesValues = countyGeoEntities.values;
            for (var i = 0; i < countyGeoEntitiesValues.length; i++) {
                var countyEntity = countyGeoEntitiesValues[i];
                if (countyEntity.properties.State != ddlState.options[ddlState.selectedIndex].value) {
                    countyGeoEntities.remove(countyEntity);
                }
            }
        }

        countyGeoEntitiesValues = countyGeoEntities.values;
        for (var i = 0; i < countyGeoEntitiesValues.length; i++) {

            var countyEntity = countyGeoEntitiesValues[i];
            var name = countyEntity.name;

            if (countyEntity.properties.State == ddlState.options[ddlState.selectedIndex].value || chkAllStates) {

                //Remove the outlines.
                ddlOutlineColor.value == "01" ? countyEntity.polygon.outline = false : countyEntity.polygon.outline = true;
                if (countyEntity.polygon.outline) {
                    if (ddlOutlineColor.value == "02") {
                        countyEntity.polygon.outlineColor = Cesium.Color.BLACK;
                    } else if (ddlOutlineColor.value == "03") {
                        countyEntity.polygon.outlineColor = Cesium.Color.RED;
                    } else if (ddlOutlineColor.value == "04") {
                        countyEntity.polygon.outlineColor = Cesium.Color.GREEN;
                    } else if (ddlOutlineColor.value == "05") {
                        countyEntity.polygon.outlineColor = Cesium.Color.BLUE;
                    } else if (ddlOutlineColor.value == "06") {
                        countyEntity.polygon.outlineColor = Cesium.Color.YELLOW;
                    }
                }

                for (var j = 0; j < jsonToRender.length; j++) {

                    var mosquitoDataRow = jsonToRender[j];
                    for (var key in mosquitoDataRow) {
                        var columnHeader = key;
                        var columnValue = mosquitoDataRow[columnHeader];
                        if (columnValue == name) {
                            var columnCountyName = columnValue;
                            var valueOfInterest = mosquitoDataRow[columnOfInterest];
                            countyEntity.polygon.extrudedHeight = valueOfInterest * 500;
                            countyEntity.description =
                                '<h1>' + columnCountyName + ' County</h1>' +
                                '<div class="row">' +
                                '<span>' +
                                columnOfInterest +
                                '&nbsp;:&nbsp;</span>' +
                                '<span>' +
                                valueOfInterest +
                                '</span>' +
                                '</div>'
                                ;

                            var color = new Cesium.Color.fromBytes(
                                255,
                                0,
                                0,
                                Math.floor((valueOfInterest / maxColumnValue) * 255)
                            );
                            countyEntity.polygon.material = color;
                            countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;

                            var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                            var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                            var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                            var countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 4000);
                            countyEntity.position = countyExtrusionHeightOffset;

                            countyEntity.label = {
                                show: chkShowLabels,
                                text: valueOfInterest + '',
                                font: '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                fillColor: Cesium.Color.WHITE,
                                outlineColor: Cesium.Color.BLACK,
                                outlineWidth: 4,
                                style: Cesium.LabelStyle.FILL_AND_OUTLINE,
                                scale: 1.0,
                                scaleByDistance: new Cesium.NearFarScalar(1.0e2, 1.3, 1.0e7, 0.1)
                            };
                        }
                    }
                }

            } else {
                countyEntity.polygon.show = false;
                countyEntity.polygon.outline = false;
            }
        }

        zoomToRenderedMap(countyDataSource);

    }).otherwise(function (error) {
        //Display any errrors encountered while loading.
        window.alert(error);
    });
}

function renderUnivariateHeatmap(jsonString, statType) {

    jsonToRender = JSON.parse(jsonString);
    mosquitoVariable = document.getElementById("ddlUniHeatMosquitoVariable").value; //mosquito type taken from the dropdown menu in the control panel
    columnOfInterest = statType + " " + mosquitoVariable;
    infoBoxMessage = "";
    mapType = 1;
    currentColumnValue;
    var mosquitoDataRow;

    //infobox message header
    if (statType == "Mean") {
        infoBoxMessage = columnOfInterest + "";
    } else if (statType == "Total") {
        infoBoxMessage = columnOfInterest + "";
    }


    for (var i = 0; i < jsonToRender.length; i++) {
        mosquitoDataRow = jsonToRender[i];
        for (var key in mosquitoDataRow) {

            currentColumnValue = mosquitoDataRow[columnOfInterest];
            if (!minColumnValue && !maxColumnValue) {
                minColumnValue = currentColumnValue;
                maxColumnValue = currentColumnValue;
            } else if (minColumnValue > currentColumnValue) {
                minColumnValue = currentColumnValue;
            } else if (maxColumnValue < currentColumnValue) {
                maxColumnValue = currentColumnValue;
            }

        }
    }

    btnHide = document.getElementById("btnHide");
    if (btnHide.innerHTML == "Show") {
        btnHide.click();
    }

    if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        viewer.dataSources.remove(globalRefCountyDataSource, false);
    }

    //determine what rendering quality should be used
    var countyGeoJson = renderQuality();

    //render map function
    renderMap(countyGeoJson, mapType, jsonToRender, columnOfInterest, maxColumnValue, infoBoxMessage, minColumnValue);

}
function renderUnivariateExtrusion(jsonString, statType) {

    jsonToRender = JSON.parse(jsonString);
    mosquitoVariable = document.getElementById("ddlUniExtrMosquitoVariable").value;
    columnOfInterest = statType + " " + mosquitoVariable;
    infoBoxMessage = "";
    mapType = 2;

    if (statType == "Mean") {
        infoBoxMessage = columnOfInterest + "";
    } else if (statType == "Total") {
        infoBoxMessage = columnOfInterest + "";
    }

    for (var i = 0; i < jsonToRender.length; i++) {
        var mosquitoDataRow = jsonToRender[i];
        for (var key in mosquitoDataRow) {

            currentColumnValue = mosquitoDataRow[columnOfInterest];
            if (!minColumnValue && !maxColumnValue) {
                minColumnValue = currentColumnValue;
                maxColumnValue = currentColumnValue;
            } else if (minColumnValue > currentColumnValue) {
                minColumnValue = currentColumnValue;
            } else if (maxColumnValue < currentColumnValue) {
                maxColumnValue = currentColumnValue;
            }

        }
    }

    btnHide = document.getElementById("btnHide");
    if (btnHide.innerHTML == "Show") {
        btnHide.click();
    }

    if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        viewer.dataSources.remove(globalRefCountyDataSource, false);
    }

    var countyGeoJson = renderQuality();

    //call render map
    renderMap(countyGeoJson, mapType, jsonToRender, columnOfInterest, maxColumnValue, infoBoxMessage, minColumnValue);
}

function renderMap(countyGeoJson, mapType, jsonToRender, columnOfInterest, maxColumnValue, infoBoxMessage, minColumnValue) {

    countyGeoJson.then(function (countyDataSource) {

        var chkAllStates;
        var ddlState;
        var ddlOutlineColor;
        var chkShowLabels;
        var extrusionFactor;
        var dataOpacity;
        var countyGeoEntities;
        var countyEntity;
        var name;
        var color;
        var colorBytes;

        chkAllStates = document.getElementById("chkAllStates").checked;
        ddlState = document.getElementById("ddlState");
        ddlOutlineColor = document.getElementById("ddlOutlineColor");
        chkShowLabels = document.getElementById("chkShowLabels").checked;
        if (mapType == 2) {
            extrusionFactor = document.getElementById("valUniExtrExtrusionFactor").value;
            dataOpacity = document.getElementById("valUniExtrDataOpacity").value;
        }
        countyGeoEntities = countyDataSource.entities;

        //if the all states were not checked then drop the states that were not selected
        if (!chkAllStates) {
            var countyGeoEntitiesValues = countyGeoEntities.values;
            for (var i = 0; i < countyGeoEntitiesValues.length; i++) {
                var countyEntity = countyGeoEntitiesValues[i];
                if (countyEntity.properties.State != ddlState.options[ddlState.selectedIndex].value) {
                    countyGeoEntities.remove(countyEntity);
                }
            }
        }
        countyGeoEntitiesValues = countyGeoEntities.values;


        //render the polygons of the counties for the selected state on the map
        for (var i = 0; i < countyGeoEntitiesValues.length; i++) {
            countyEntity = countyGeoEntitiesValues[i];
            name = countyEntity.name;
            if (countyEntity.properties.State == ddlState.options[ddlState.selectedIndex].value || chkAllStates) {

                var outLineColor = ddlOutlineColor.value;
                outLineColor == "01" ? countyEntity.polygon.outline = false : countyEntity.polygon.outline = true;

                if (countyEntity.polygon.outline) {
                    countyEntity.polygon.outlineColor = determineOutlineColor(outLineColor);
                }

                for (var j = 0; j < jsonToRender.length; j++) {

                    var mosquitoDataRow = jsonToRender[j];
                    for (var key in mosquitoDataRow) {
                        var columnHeader = key;
                        var columnValue = mosquitoDataRow[columnHeader];
                        if (columnValue == name) {
                            var columnCountyName = columnValue;
                            var valueOfInterest = mosquitoDataRow[columnOfInterest];

                            //Set the color of the polygon
                            if (mapType == 1) {
                                countyEntity.polygon.extrudedHeight = 0;
                                color = new Cesium.Color.fromBytes(255, 0, 0, Math.floor((valueOfInterest / maxColumnValue) * 255));
                                colorBytes = color.toBytes();
                            } else if (mapType == 2) {
                                countyEntity.polygon.extrudedHeight = Math.floor((valueOfInterest / maxColumnValue) * ((extrusionFactor / 100) * 200000));
                                color = new Cesium.Color.fromBytes(255, 255 - Math.floor((valueOfInterest / maxColumnValue) * 255), 255 - Math.floor((valueOfInterest / maxColumnValue) * 255), Math.floor((dataOpacity / 100) * 255));
                            }

                            //set the legend offset
                            var valueOfInterestLegendOffsetText = "";
                            var valueOfInterestLegendOffsetValue = Math.round(((maxColumnValue - valueOfInterest) / maxColumnValue) * 298);
                            if (!valueOfInterestLegendOffsetValue == 0) {
                                valueOfInterestLegendOffsetText = '<div class="row" style="height:' + valueOfInterestLegendOffsetValue + 'px"><div class="col-xs-12"></div></div>';
                            }

                            //polygon position 
                            var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                            var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                            var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                            var countyExtrusionHeightOffset;

                            //set countyEntity properties
                            countyEntity.polygon.material = color;
                            countyEntity.description = generateDescription(mapType, columnCountyName, infoBoxMessage, valueOfInterest, valueOfInterestLegendOffsetText, dataOpacity, maxColumnValue, minColumnValue, colorBytes);
                            countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;

                            if (mapType == 1) {
                                countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 4000);
                                countyEntity.position = countyExtrusionHeightOffset;
                            }
                            if (mapType == 2) {
                                countyEntity.polygon.shadows = Cesium.ShadowMode.CAST_ONLY;
                                countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 10000);
                                countyEntity.position = countyExtrusionHeightOffset;
                            }
                            countyEntity.label = {
                                show: chkShowLabels,
                                text: valueOfInterest + '',
                                font: '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                fillColor: Cesium.Color.WHITE,
                                outlineColor: Cesium.Color.BLACK,
                                outlineWidth: 4,
                                style: Cesium.LabelStyle.FILL_AND_OUTLINE,
                                scale: 1.0,
                                scaleByDistance: new Cesium.NearFarScalar(1.0e2, 1.3, 1.0e7, 0.1)
                            };
                        }
                    }
                }

            } else {
                countyEntity.polygon.show = false;
                countyEntity.polygon.outline = false;
            }
        }

        zoomToRenderedMap(countyDataSource, countyGeoEntitiesValues);
    }).otherwise(function (error) {
        //Display any errrors encountered while loading.
        if (mapType == 1) {
            window.alert(error + " Univariate Heatmap");
        } else if (mapType == 2) {
            window.alert(error + " Univariate Extrusion map");
        }

        
    });

}



function renderPearsonCorrelationHeatmap(jsonString, mosquitoVarOfInterest, weatherVarOfInterest) {
    jsonToRender = JSON.parse(jsonString);
    infoBoxMessage = "Pearson's Coefficient";
    mapType = 3;
    var dataOpacity; //just keep this here
    var maxColumnValue; //just keep this here
    var minColumnValue; //just keep this here
    var colorBytes; //just keep this here
    btnHide = document.getElementById("btnHide");
    if (btnHide.innerHTML == "Show") {
        btnHide.click();
    }
    if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        viewer.dataSources.remove(globalRefCountyDataSource, false);
    }
    var countyGeoJson = renderQuality();

    countyGeoJson.then(function (countyDataSource) {

        var chkAllStates = document.getElementById("chkAllStates").checked;
        var ddlState = document.getElementById("ddlState");
        var ddlOutlineColor = document.getElementById("ddlOutlineColor");
        var chkShowLabels = document.getElementById("chkShowLabels").checked;
        
        var countyGeoEntities = countyDataSource.entities;
        if (!chkAllStates) {
            var countyGeoEntitiesValues = countyGeoEntities.values;
            for (var i = 0; i < countyGeoEntitiesValues.length; i++) {
                var countyEntity = countyGeoEntitiesValues[i];
                if (countyEntity.properties.State != ddlState.options[ddlState.selectedIndex].value) {
                    countyGeoEntities.remove(countyEntity);
                }
            }
        }
        countyGeoEntitiesValues = countyGeoEntities.values;
        for (var i = 0; i < countyGeoEntitiesValues.length; i++) {

            var countyEntity = countyGeoEntitiesValues[i];
            var name = countyEntity.name;

            if (countyEntity.properties.State == ddlState.options[ddlState.selectedIndex].value || chkAllStates) {

                countyEntity.polygon.show = false;
                countyEntity.polygon.outline = false;

                ddlOutlineColor.value == "01" ? countyEntity.polygon.outline = false : countyEntity.polygon.outline = true;
                if (countyEntity.polygon.outline) {
                    if (ddlOutlineColor.value == "02") {
                        countyEntity.polygon.outlineColor = Cesium.Color.BLACK;
                    } else if (ddlOutlineColor.value == "03") {
                        countyEntity.polygon.outlineColor = Cesium.Color.RED;
                    } else if (ddlOutlineColor.value == "04") {
                        countyEntity.polygon.outlineColor = Cesium.Color.GREEN;
                    } else if (ddlOutlineColor.value == "05") {
                        countyEntity.polygon.outlineColor = Cesium.Color.BLUE;
                    } else if (ddlOutlineColor.value == "06") {
                        countyEntity.polygon.outlineColor = Cesium.Color.YELLOW;
                    }
                }

                for (var j = 0; j < jsonToRender.length; j++) {

                    var dataRow = jsonToRender[j];
                    for (var key in dataRow) {
                        var columnHeader = key;
                        var columnValue = dataRow[columnHeader];
                        if (columnValue == name) {
                            countyEntity.polygon.show = true;
                            var columnCountyName = columnValue;
                            var mosquitoVarOfInterest = dataRow["MosquitoVar"];
                            var weatherVarOfInterest = dataRow["WeatherVar"];
                            var valueOfInterest = dataRow["PearsonCoefficient"];
                            countyEntity.polygon.extrudedHeight = 0;
                            var color;
                            if (valueOfInterest <= 0) {
                                color = new Cesium.Color.fromBytes(0, 0, 255, Math.floor((valueOfInterest * -1) * 255));
                            } else if (valueOfInterest == 0) {
                                color = new Cesium.Color.fromBytes(0, 0, 0, 0);
                            } else {
                                color = new Cesium.Color.fromBytes(255, 0, 0, Math.floor((valueOfInterest) * 255));
                            }
                            countyEntity.polygon.material = color;

                            var valueOfInterestLegendOffsetText = "";
                            var valueOfInterestLegendOffsetValue = Math.round(((1 - valueOfInterest) * 298) / 2);
                            if (!valueOfInterestLegendOffsetValue == 0) {
                                valueOfInterestLegendOffsetText = '<div class="row" style="height:' + valueOfInterestLegendOffsetValue + 'px"><div class="col-xs-12"></div></div>';
                            }

                            countyEntity.description = generateDescription(mapType, columnCountyName, infoBoxMessage, valueOfInterest, valueOfInterestLegendOffsetText);
                            countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;
                            countyEntity.polygon.shadows = Cesium.ShadowMode.CAST_ONLY;

                            var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;

                            var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                            var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                            var countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 4000);
                            countyEntity.position = countyExtrusionHeightOffset;

                            countyEntity.label = {
                                show: chkShowLabels,
                                text: valueOfInterest + '',
                                font: '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                fillColor: Cesium.Color.WHITE,
                                outlineColor: Cesium.Color.BLACK,
                                outlineWidth: 4,
                                style: Cesium.LabelStyle.FILL_AND_OUTLINE,
                                scale: 1.0,
                                scaleByDistance: new Cesium.NearFarScalar(1.0e2, 1.3, 1.0e7, 0.1)
                            };
                        }
                    }
                }

            } else {
                countyEntity.polygon.show = false;
                countyEntity.polygon.outline = false;
            }
        }

        zoomToRenderedMap(countyDataSource, countyGeoEntitiesValues);
    }).otherwise(function (error) {
        //Display any errrors encountered while loading.
        window.alert(error + " Pearson Heatmap");
    });
}
function zoomToRenderedMap(countyDataSource, countyGeoEntitiesValues) {
    var heading = Cesium.Math.toRadians(0);
    var pitch = Cesium.Math.toRadians(-90);
    viewer.flyTo(countyGeoEntitiesValues, {
        duration: 2.0,
        offset: new Cesium.HeadingPitchRange(heading, pitch)
    });
    viewer.dataSources.add(countyDataSource);
    globalRefCountyDataSource = countyDataSource;
}

function generateDescription(mapType, columnCountyName, infoBoxMessage, valueOfInterest, valueOfInterestLegendOffsetText, dataOpacity, maxColumnValue, minColumnValue, colorBytes) {
    if (mapType == 1) {
        return '<h2 class="text-center">' + columnCountyName + ' County</h2>' + '<div class="row" style="margin-bottom:20px">' + '<div class="col-xs-6 text-right">' + infoBoxMessage + '</div>' +
            '<div class="col-xs-6">' + valueOfInterest + '</div>' + '</div>' + '<div class="row">' + '<div class="col-xs-4 text-right" style="padding-right:0px">' +
            '<div class="row" style="height:150px"><div class="col-xs-12">' + maxColumnValue + '&nbsp;&nbsp;&mdash;' + '</div></div>' +
            '<div class="row" style="height:150px"><div class="col-xs-12"></div></div>' + '<div class="row" style="height:22px"><div class="col-xs-12">' +
            minColumnValue + '&nbsp;&nbsp;&mdash;' + '</div></div>' + '</div>' + '<div class="col-xs-4" style="margin-top:12px">' +
            '<div style="height:300px;background-image: linear-gradient(rgba(' + colorBytes[0] + ',' + colorBytes[1] + ',' + colorBytes[2] +
            '),rgba(' + colorBytes[0] + ',' + colorBytes[1] + ',' + colorBytes[2] + ',' + (minColumnValue / maxColumnValue) + ')">' +
            '</div>' + '</div>' + '<div class="col-xs-4" style="padding-left:0px">' + valueOfInterestLegendOffsetText +
            '<div class="row"><div class="col-xs-12"><span style="font-size:18px">&larr;</span>&nbsp;&nbsp;' + valueOfInterest + '</div></div>' + '</div>' + '</div>'
            + '<div class="row" style="margin-top:20px">' + '<div class="col-xs-4 text-right">' + infoBoxMessage +
            '</div>' + '<div class="col-xs-4 text-center">' + 'Intensity' + '</div>' + '<div class="col-xs-4 text-left">'
            + columnCountyName + '</div>' + '</div>';
    }
    if (mapType == 2) {
        return '<h2 class="text-center">' + columnCountyName + ' County</h2>' + '<div class="row" style="margin-bottom:20px">' + '<div class="col-xs-6 text-right">' +
            infoBoxMessage + '</div>' + '<div class="col-xs-6">' + valueOfInterest + '</div>' + '</div>' + '<div class="row">' + '<div class="col-xs-4 text-right" style="padding-right:0px">' +
            '<div class="row" style="height:150px"><div class="col-xs-12">' + maxColumnValue + '&nbsp;&nbsp;&mdash;' + '</div></div>' + '<div class="row" style="height:150px"><div class="col-xs-12"></div></div>' +
            '<div class="row" style="height:22px"><div class="col-xs-12">' + minColumnValue + '&nbsp;&nbsp;&mdash;' + '</div></div>' + '</div>' + '<div class="col-xs-4" style="margin-top:12px">' +
            '<div style="height:300px;background-image: linear-gradient(rgba(255,0,0,' + dataOpacity / 100 + '),rgba(255,255,255,' + dataOpacity / 100 + ')">' + '</div>' + '</div>' +
            '<div class="col-xs-4" style="padding-left:0px">' + valueOfInterestLegendOffsetText + '<div class="row"><div class="col-xs-12"><span style="font-size:18px">&larr;</span>&nbsp;&nbsp;' + valueOfInterest + '</div></div>' +
            '</div>' + '</div>' + '<div class="row" style="margin-top:20px">' + '<div class="col-xs-4 text-right">' + infoBoxMessage + '</div>' + '<div class="col-xs-4 text-center">' + 'Intensity' +
            '</div>' + '<div class="col-xs-4 text-left">' + columnCountyName + '</div>' + '</div>';
    }
    if (mapType == 3) {
        return '<h2 class="text-center">' + columnCountyName + ' County</h2>' + '<div class="row" style="margin-bottom:20px">' + '<div class="col-xs-6 text-right">' +
            infoBoxMessage + '</div>' + '<div class="col-xs-6">' + valueOfInterest + '</div>' + '</div>' + '<div class="row">' + '<div class="col-xs-4 text-right" style="padding-right:0px">' +
            '<div class="row" style="height:150px"><div class="col-xs-12">' + "1" + '&nbsp;&nbsp;&mdash;' + '</div></div>' + '<div class="row" style="height:150px"><div class="col-xs-12"></div></div>' +
            '<div class="row" style="height:22px"><div class="col-xs-12">' + "-1" + '&nbsp;&nbsp;&mdash;' + '</div></div>' + '</div>' + '<div class="col-xs-4" style="margin-top:12px">' +
            '<div style="height:300px;background-image: linear-gradient(rgba(255,0,0),rgba(0,0,0,0),rgba(0,0,255))">' + '</div>' + '</div>' + '<div class="col-xs-4" style="padding-left:0px">' +
            valueOfInterestLegendOffsetText + '<div class="row"><div class="col-xs-12"><span style="font-size:18px">&larr;</span>&nbsp;&nbsp;' + valueOfInterest + '</div></div>' +
            '</div>' + '</div>' + '<div class="row" style="margin-top:20px">' + '<div class="col-xs-4 text-right">' + infoBoxMessage + '</div>' + '<div class="col-xs-4 text-center">' + 'Correlation' +
            '</div>' + '<div class="col-xs-4 text-left">' + columnCountyName + '</div>' + '</div>';
    }

}

function determineOutlineColor(outLineColor) {
    if (outLineColor == "02") {
        return Cesium.Color.BLACK;
    } else if (outLineColor == "03") {
        return Cesium.Color.RED;
    } else if (outLineColor == "04") {
        return Cesium.Color.GREEN;
    } else if (outLineColor == "05") {
        return Cesium.Color.BLUE;
    } else if (outLineColor == "06") {
        return Cesium.Color.YELLOW;
    }
}

function renderQuality() {

    var countyGeoJson;

    //grab the render quality values
    var rdoCountyLowQual = document.getElementById("rdoCountyLowQual");
    var rdoCountyMedQual = document.getElementById("rdoCountyMedQual");
    var rdoCountyHighQual = document.getElementById("rdoCountyHighQual");

    if (rdoCountyLowQual.checked) {
        countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/us-statecounties-20m.json');
    } else if (rdoCountyMedQual.checked) {
        countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/us-statecounties-5m.json');
    } else if (rdoCountyHighQual.checked) {
        countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/us-statecounties-500k.json');
    }

    return countyGeoJson;
}

function createTrapLocations(fileToRender) {
    var trapGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/' + fileToRender);
    trapGeoJson.then(function (trapDataSource) {

        viewer.dataSources.add(trapDataSource);
        globalRefTrapDataSource = trapDataSource;
        trapGeoEntities = trapDataSource.entities.values;

        for (var i = 0; i < trapGeoEntities.length; i++) {
            var trapMarker = trapGeoEntities[i];
            var pointFillColor = Cesium.Color.TOMATO;
            var pointOutlineColor = Cesium.Color.BLACK;
            var pointOutlineWidth = 3;
            var pointSize = 10;

            var trapPointPosition = trapMarker.position.getValue(Cesium.JulianDate.now());
            var trapCartographicPosition = Cesium.Cartographic.fromCartesian(trapPointPosition);
            var trapLatitude = Cesium.Math.toDegrees(trapCartographicPosition.latitude);
            var trapLongitude = Cesium.Math.toDegrees(trapCartographicPosition.longitude);
            trapLatitude = trapLatitude.toFixed(6);
            trapLongitude = trapLongitude.toFixed(6);

            trapMarker.billboard = undefined;
            trapMarker.point = new Cesium.PointGraphics({
                color: pointFillColor,
                outlineColor: pointOutlineColor,
                outlineWidth: pointOutlineWidth,
                pixelSize: pointSize
            });
            trapDataSource.clustering.enabled = true;
            trapDataSource.clustering.pixelRange = 10;
            trapDataSource.clustering.minimumClusterSize = 8;
            trapDataSource.clustering.clusterEvent.addEventListener(function (entities, cluster) {
                cluster.label.show = false;
                cluster.point.show = true;
                cluster.point.color = pointFillColor;
                cluster.point.outlineColor = pointOutlineColor;
                cluster.point.outlineWidth = pointOutlineWidth;
                cluster.point.pixelSize = pointSize + 5;
            });


            trapMarker.description =
                '<h2 class="text-center">' + trapMarker.properties.name + '</h2>' +
                '<div class="row" style="margin-bottom:10px">' +
                '<div class="col-xs-6 text-right">' +
                'County' +
                '</div>' +
                '<div class="col-xs-6">' +
                trapMarker.properties.County +
                '</div>' +
                '</div>' +
                '<div class="row" style="margin-bottom:10px">' +
                '<div class="col-xs-6 text-right">' +
                'Latitude' +
                '</div>' +
                '<div class="col-xs-6">' +
                trapLatitude +
                '</div>' +
                '</div>' +
                '<div class="row" style="margin-bottom:10px">' +
                '<div class="col-xs-6 text-right">' +
                'Longitude' +
                '</div>' +
                '<div class="col-xs-6">' +
                trapLongitude +
                '</div>' +
                '</div>'
                ;
        }
        showTraps();
    }).otherwise(function (error) {
        window.alert(error);
    });
}

function showTraps() {
    var chkShowTraps = document.getElementById("chkShowTraps").checked;
    if (chkShowTraps) {
        for (var i = 0; i < trapGeoEntities.length; i++) {
            trapGeoEntities[i].show = true;
        }
    } else {
        for (var i = 0; i < trapGeoEntities.length; i++) {
            trapGeoEntities[i].show = false;
        }
    }
}

function showLabels() {
    var chkShowLabels = document.getElementById("chkShowLabels").checked;
    if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        var countyGeoEntitiesValues = globalRefCountyDataSource.entities.values;
        if (chkShowLabels) {
            for (var i = 0; i < countyGeoEntitiesValues.length; i++) {
                var countyEntity = countyGeoEntitiesValues[i];
                if (Cesium.defined(countyEntity.label)) {
                    countyEntity.label.show = true;
                }
            }
        } else {
            for (var i = 0; i < countyGeoEntitiesValues.length; i++) {
                var countyEntity = countyGeoEntitiesValues[i];
                if (Cesium.defined(countyEntity.label)) {
                    countyEntity.label.show = false;
                }
            }
        }
    }
}


document.getElementById("btnHide").addEventListener("click", function () {
    var dataSources = viewer.dataSources;
    for (var i = 0; i < dataSources.length; i++) {
        if (dataSources.get(i).entities.show == true) {
            dataSources.get(i).entities.show = false;
            document.getElementById("btnHide").innerText = "Show";
        } else {
            dataSources.get(i).entities.show = true;
            document.getElementById("btnHide").innerText = "Hide";
        }
    }
});
document.getElementById("btnClear").addEventListener("click", function () {
    var dataSources = viewer.dataSources;
    if (dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        dataSources.remove(globalRefCountyDataSource);
    }
});
document.getElementById("btnResetCountyInfoBoxPos").addEventListener("click", function () {
    var cesiumInfoBox = document.getElementsByClassName("cesium-infoBox")[0];

    cesiumInfoBox.style.top = "101px";
    cesiumInfoBox.style.right = "5px";
    cesiumInfoBox.style.left = "";
});
document.getElementById("btnResetView").addEventListener("click", function () {
    if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
        var countyGeoEntitiesValues = globalRefCountyDataSource.entities.values;
        var heading = Cesium.Math.toRadians(0);
        var pitch = Cesium.Math.toRadians(-90);

        viewer.flyTo(countyGeoEntitiesValues, {
            duration: 2.0,
            offset: new Cesium.HeadingPitchRange(heading, pitch)
        });
    } else if (viewer.dataSources.get(0)) {
        var trapEntitiesValues = globalRefTrapDataSource.entities.values;
        var heading = Cesium.Math.toRadians(0);
        var pitch = Cesium.Math.toRadians(-90);

        viewer.flyTo(trapEntitiesValues, {
            duration: 2.0,
            offset: new Cesium.HeadingPitchRange(heading, pitch)
        });
    }
});

dragElement(document.getElementsByClassName("cesium-infoBox")[0]);

function dragElement(elmnt) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    if (document.getElementsByClassName("cesium-infoBox-title")[0]) {
        // if present, the header is where you move the DIV from:
        document.getElementsByClassName("cesium-infoBox-title")[0].onmousedown = dragMouseDown;
    } else {
        // otherwise, move the DIV from anywhere inside the DIV:
        elmnt.onmousedown = dragMouseDown;
        document.getElementsByClassName("cesium-infoBox-iframe")[0].onmousedown = dragMouseDown;
        document.getElementsByClassName("cesium-infoBox-description")[0].onmousedown = dragMouseDown;
        document.getElementsByClassName("cesium-infoBox-defaultTable")[0].onmousedown = dragMouseDown;
    }

    function dragMouseDown(e) {
        e = e || window.event;
        e.preventDefault();
        // get the mouse cursor position at startup:
        pos3 = e.clientX;
        if (e.clientY <= 55) {
            pos4 = 55;
        } else if (e.clientY >= window.innerHeight - elmnt.offsetHeight - 27) {
            pos4 = window.innerHeight - elmnt.offsetHeight - 27;
        } else {
            pos4 = e.clientY;
        }
        document.onmouseup = closeDragElement;
        // call a function whenever the cursor moves:
        document.onmousemove = elementDrag;
    }

    function elementDrag(e) {
        e = e || window.event;
        e.preventDefault();
        // calculate the new cursor position:
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        if (e.clientY <= 55) {
            pos4 = 55;
        } else if (e.clientY >= window.innerHeight - elmnt.offsetHeight - 27) {
            pos4 = window.innerHeight - elmnt.offsetHeight - 27;
        } else {
            pos4 = e.clientY;
        }
        // set the element's new position:
        if ((elmnt.offsetTop - pos2) <= 55) {
            elmnt.style.top = 55 + "px";
        } else if ((elmnt.offsetTop - pos2) >= (window.innerHeight - elmnt.offsetHeight - 27)) {
            elmnt.style.top = window.innerHeight - elmnt.offsetHeight - 27 + "px";
        } else {
            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
        }
        elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
    }

    function closeDragElement() {
        // stop moving when mouse button is released:
        document.onmouseup = null;
        document.onmousemove = null;
    }
}

function expandControls() {
    var ctrlContainer = document.getElementById('controlContainer');
    var ctrlNavbar = document.getElementById('controlNavbar');
    if (ctrlContainer.classList.contains("hidden")) {
        ctrlContainer.classList.replace("hidden", "expanded");
        setTimeout(function () { $('#controlNavbar').collapse('show') }, 350);
    } else {
        ctrlContainer.classList.replace("expanded", "hidden");
        $('#controlNavbar').collapse('hide');
    }
}

function adjustOpacity(opacityValue, ctrlID) {
    var ctrl = document.getElementById(ctrlID);
    ctrl.style.opacity = opacityValue * '.01';
}

function adjustWidth(widthValue, ctrlID) {
    var ctrl = document.getElementById(ctrlID);
    ctrl.style.width = widthValue + '%';
}

function toggleTooltip(ctrlID) {
    var ctrl = document.getElementById(ctrlID);
    if (ctrl.classList.contains("tooltip-hide")) {
        ctrl.classList.replace("tooltip-hide", "tooltip-show");
    } else if (ctrl.classList.contains("tooltip-show")) {
        ctrl.classList.replace("tooltip-show", "tooltip-hide");
    }
}

function updateSlideOutputLive(ctrlInput, ctrlOutputID) {
    var ctrlOutputID = document.getElementById(ctrlOutputID);
    ctrlOutputID.innerText = ctrlInput.value;
}

function toggleDropdownCaret(caller) {
    var ctrlChildren = caller.children;
    caller.style.pointerEvents = "none";
    for (var i = 0; i < ctrlChildren.length; i++) {
        if (!ctrlChildren[i].classList.contains("caret-up")) {
            ctrlChildren[i].classList.add("caret-up");
        } else {
            ctrlChildren[i].classList.remove("caret-up");
        }
    }
    setTimeout(function () { caller.style.pointerEvents = "auto"; }, 350);
}

function toggleParameterPanel(caller) {

    $('#pnlVisualization1').collapse('hide');
    $('#pnlVisualization2').collapse('hide');
    $('#pnlVisualization3').collapse('hide');
    $('#pnlVisualization4').collapse('hide');

    if (caller.value == "1") {
        setTimeout(function () { $('#pnlVisualization1').collapse('show') }, 350);
    } else if (caller.value == "2") {
        setTimeout(function () { $('#pnlVisualization2').collapse('show') }, 350);
    } else if (caller.value == "3") {
        setTimeout(function () { $('#pnlVisualization3').collapse('show') }, 350);
    } else if (caller.value == "4") {
        setTimeout(function () { $('#pnlVisualization4').collapse('show') }, 350);
    }
}