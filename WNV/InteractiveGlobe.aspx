<%@ Page Title="WNVF | Multivariate Trends by County" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InteractiveGlobe.aspx.cs" Inherits="WNV._InteractiveMap" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MapContent" runat="server">
    <script src="/Scripts/Cesium/Build/Cesium/Cesium.js" type="text/javascript"></script>
    <style>
        @import url(Scripts/Cesium/Build/Cesium/Widgets/widgets.css);
        html, body, #cesiumContainer {
            width:100% !important;
            height:100% !important;
            margin:0 !important;
            padding:0 !important;
            overflow:hidden !important;
        }
    </style>
    <div id="cesiumContainer">
        <div id="controlContainer" class="pos-f-t cesium-button p-0 position-absolute hidden">
            <div class="collapse" id="controlNavbar">
                <div class="bg-dark p-4">
                    <div class="row">
                        <div class="col-lg-4">
                            <h4 class="text-white">Control Panel</h4>
                        </div>
                        <div class="col-lg-4">
                            <div class="text-light slideContainer">
                                Control Panel Opacity
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="text-light slideContainer">
                                Control Panel Width
                            </div>
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-4">
                        </div>
                        <div class="col-lg-4">
                            <div class="slideContainer">
                                <output style="display:none;" id="valOpacity">100</output>
                                <input id="rngOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="40" max="100" step="2" onchange="valOpacity.value=value;adjustOpacity(value,'controlContainer');" />
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="slideContainer">
                                <output style="display:none;" id="valWidth">35</output>
                                <input id="rngWidth" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="35" min="20" max="40" step="1" onchange="valWidth.value=value;adjustWidth(value,'controlContainer');" />
                            </div>
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12">
                            <span class="text-light">Show/Hide ND Counties</span>
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-3">
                            <button id="btnShow" class="cesium-button m-0 w-100" type="button" >Show JSON</button>
                        </div>
                        <div class="col-lg-3">
                            <button id="btnHide" class="cesium-button m-0 w-100" type="button" >Hide JSON</button>
                        </div>
                        <div class="col-lg-6">
                            <button id="btnResetCountyInfoBoxPos" class="cesium-button m-0 w-100" type="button" >Reset County Info Box Position</button>
                        </div>
                    </div>
                </div>
            </div>
            <nav class="navbar navbar-dark bg-dark" style="padding:0; border-radius:3px;" onclick="expandControls();">
                <button class="navbar-toggler cesium-button" style="margin:0px;padding:2px;width:100%;" type="button" data-toggle="collapse" data-target="#controlNavbar" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </nav>
        </div>
        <script>
            document.getElementById('rngOpacity').value = 100;
            document.getElementById('rngWidth').value = 35;

            var CesiumAPIKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NjhhNWVlOS0yYThiLTQ3M2YtOTBiNC03ZWY0YmFhMDZiNzgiLCJpZCI6NDA4NCwic2NvcGVzIjpbImFzbCIsImFzciIsImFzdyIsImdjIl0sImlhdCI6MTUzOTg1MDc4N30.jQhxjgKS3zpd5MKaks7_oSddnE_jtCC6fFSsfFufwj8";
            Cesium.Ion.defaultAccessToken = CesiumAPIKey;
            
            var viewer = new Cesium.Viewer('cesiumContainer');

            document.getElementById("btnShow").addEventListener("click", function(){
                viewer.dataSources.add(Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/ND_Counties.json'));
            });
            document.getElementById("btnHide").addEventListener("click", function () {
                viewer.dataSources.remove(viewer.dataSources.get(0), false);
            });
            document.getElementById("btnResetCountyInfoBoxPos").addEventListener("click", function () {
                var cesiumInfoBox = document.getElementsByClassName("cesium-infoBox")[0];

                cesiumInfoBox.style.top = "101px";
                cesiumInfoBox.style.right = "5px";
                cesiumInfoBox.style.left = "";
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
              }

              function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                // get the mouse cursor position at startup:
                pos3 = e.clientX;
                pos4 = e.clientY;
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
                pos4 = e.clientY;
                // set the element's new position:
                elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
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
                    ctrlNavbar.classList.add("delay-transition");
                } else {
                    ctrlContainer.classList.replace("expanded","hidden");
                    ctrlNavbar.classList.remove("delay-transition");
                }
            }
            
            function adjustOpacity(opacityValue,ctrlID) {
                var ctrl = document.getElementById(ctrlID);
                ctrl.style.opacity = opacityValue * '.01';
            }
            function adjustWidth(widthValue,ctrlID) {
                var ctrl = document.getElementById(ctrlID);
                ctrl.style.width = widthValue + '%';
            }
        </script>
    </div>
</asp:Content>
