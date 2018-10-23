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
                            <h2 class="text-white">Control Panel</h2>
                        </div>
                        <div class="col-lg-4">
                            <div class="text-light">
                                Control Panel Opacity
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="text-light">
                                Control Panel Width
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                        </div>
                        <div class="col-lg-4">
                            <div class="slideContainer" onmouseover="document.getElementById('valOpacity')">
                                <input id="rngOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="40" max="100" step="2" onchange="valOpacity.value=value;adjustOpacity(value,'controlContainer');" onmouseover="toggleTooltip('valOpacity');" onmouseout="toggleTooltip('valOpacity');" onmousemove="updateSlideOutputLive(this,'valOpacity');"/>
                                <output class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center" id="valOpacity">100</output>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="slideContainer">
                                <input id="rngWidth" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="35" min="25" max="40" step="1" onchange="valWidth.value=value;adjustWidth(value,'controlContainer');" onmouseover="toggleTooltip('valWidth');" onmouseout="toggleTooltip('valWidth');" onmousemove="updateSlideOutputLive(this,'valWidth');"/>
                                <output id="valWidth" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">35</output>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-0">
                        <div class="col-lg-12">
                            <hr class="dropdown-divider mb-2 mt-2" />
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12 dropdown-toggle text-white mb-0" data-toggle="collapse" data-target="#pnlParameters" aria-expanded="false" aria-controls="pnlParameters">
                            <span class="text-white controlPanel-section-header">Parameters</span>
                        </div>
                    </div>
                    <div id="pnlParameters" class="mb-0 collapse">
                        <div class="row mb-1">
                            <div class="col-lg-5">
                                <h6 class="text-white">Visualization Type</h6>
                            </div>
                            <div class="col-lg-3">
                                <h6 class="text-white">State</h6>
                            </div>
                        </div>
                        <div class="row mb-1">
                            <div class="col-lg-5">
                                <asp:DropDownList ID="ddlVisType" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%">
                                    <asp:ListItem Value="1" Text="Total Mosquitoes per Trap" ></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Average Mosquitoes per Trap" ></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Mosquitoes vs Weather" ></asp:ListItem>
                                </asp:DropDownList>
                                <%--<select id="ddlVisType" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                    <option value="01">Mosquito</option>
                                </select>--%>
                            </div>
                            <div class="col-lg-3">
                                <%--<asp:DropDownList ID="ddlState" runat="server" CssClass="dropdown-item cesium-button p-0 m-0 aspnet-width-fix"></asp:DropDownList>--%>
                                <select id="ddlState" class="cesium-button p-1 m-0 w-100 aspnet-width-fix" disabled="disabled" aria-disabled="true">
                                    <option value="01">Alabama</option>
                                    <option value="02">Alaska</option>
                                    <option value="03">Arizona</option>
                                    <option value="04">Arkansas</option>
                                    <option value="05">California</option>
                                    <option value="06">Colorado</option>
                                    <option value="07">Connecticut</option>
                                    <option value="08">Delaware</option>
                                    <option value="09">D.C.</option>
                                    <option value="10">Florida</option>
                                    <option value="11">Georgia</option>
                                    <option value="12">Hawaii</option>
                                    <option value="13">Idaho</option>
                                    <option value="14">Illinois</option>
                                    <option value="15">Indiana</option>
                                    <option value="16">Iowa</option>
                                    <option value="17">Kansas</option>
                                    <option value="18">Kentucky</option>
                                    <option value="19">Louisiana</option>
                                    <option value="20">Maine</option>
                                    <option value="21">Maryland</option>
                                    <option value="22">Massachusetts</option>
                                    <option value="23">Michigan</option>
                                    <option value="24">Minnesota</option>
                                    <option value="25">Mississippi</option>
                                    <option value="26">Missouri</option>
                                    <option value="27">Montana</option>
                                    <option value="28">Nebraska</option>
                                    <option value="29">Nevada</option>
                                    <option value="30">New Hampshire</option>
                                    <option value="31">New Jersey</option>
                                    <option value="32">New Mexico</option>
                                    <option value="33">New York</option>
                                    <option value="34">North Carolina</option>
                                    <option selected="selected" value="35">North Dakota</option>
                                    <option value="36">Ohio</option>
                                    <option value="37">Oklahoma</option>
                                    <option value="38">Oregon</option>
                                    <option value="39">Pennsylvania</option>
                                    <option value="40">Rhode Island</option>
                                    <option value="41">South Carolina</option>
                                    <option value="42">South Dakota</option>
                                    <option value="43">Tennessee</option>
                                    <option value="44">Texas</option>
                                    <option value="45">Utah</option>
                                    <option value="46">Vermont</option>
                                    <option value="47">Virginia</option>
                                    <option value="48">Washington</option>
                                    <option value="49">West Virginia</option>
                                    <option value="50">Wisconsin</option>
                                    <option value="51">Wyoming</option>
                                </select>
                            </div>
                            <div class="col-lg-4">
                                <div class="form-check-inline">
                                    <asp:CheckBox ID="chkAllStates" runat="server" CssClass="form-check-input aspnet-width-fix" Enabled="false"/>
                                    <label class="form-check-label text-light disabled" for="<%=chkAllStates.ClientID %>">Use All States</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-0">
                        <div class="col-lg-12">
                            <hr class="dropdown-divider mb-2 mt-2" />
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12 dropdown-toggle text-white mb-0" data-toggle="collapse" data-target="#pnlRenderSettings" aria-expanded="false" aria-controls="pnlRenderSettings">
                            <span class="text-white controlPanel-section-header">Render Settings</span>
                        </div>
                    </div>
                    <div id="pnlRenderSettings" class="mb-0 collapse">
                        <div class="row mb-1">
                            <div class="col-lg-6">
                                <h6 class="text-white">County Border Quality</h6>
                            </div>
                            <div class="col-lg-3">
                                <h6 class="text-white">Data Opacity</h6>
                            </div>
                            <div class="col-lg-3">
                                <h6 class="text-white">Outline Color</h6>
                            </div>
                        </div>
                        <div class="row mb-1">
                            <div class="col-lg-2">
                                <div class="form-check-inline">
                                    <input id="rdoCountyLowQual" name="rdoCountyQuality" class="form-check-input" type="radio" checked="checked" />
                                    <label class="form-check-label text-light" for="rdoCountyLowQual">Lowest</label>
                                </div>
                            </div>
                            <div class="col-lg-2">
                                <div class="form-check-inline">
                                    <input id="rdoCountyMedQual" name="rdoCountyQuality" class="form-check-input" type="radio" />
                                    <label class="form-check-label text-light"for="rdoCountyMedQual">Medium</label>
                                </div>
                            </div>
                            <div class="col-lg-2">
                                <div class="form-check-inline">
                                    <input id="rdoCountyHighQual" name="rdoCountyQuality" class="form-check-input" type="radio" />
                                    <label class="form-check-label text-light"for="rdoCountyHighQual">Highest</label>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <div class="slideContainer">
                                    <input id="rngDataOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="40" max="100" step="2" onchange="valDataOpacity.value=value;" onmouseover="toggleTooltip('valDataOpacity');" onmouseout="toggleTooltip('valDataOpacity');" onmousemove="updateSlideOutputLive(this,'valDataOpacity');"/>
                                    <output id="valDataOpacity" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">100</output>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <select id="ddlOutlineColor" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                    <option value="01" selected="selected">None</option>
                                    <option value="02">Black</option>
                                    <option value="03">Red</option>
                                    <option value="04">Green</option>
                                    <option value="05">Blue</option>
                                    <option value="06">Yellow</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-0">
                        <div class="col-lg-12">
                            <hr class="dropdown-divider mb-2 mt-2" />
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12 dropdown-toggle text-white mb-0" data-toggle="collapse" data-target="#pnlActions" aria-expanded="false" aria-controls="pnlActions">
                            <span class="text-white controlPanel-section-header">Actions</span>
                        </div>
                    </div>
                    <div id="pnlActions" class="mb-0 collapse">
                        <div class="row mb-0">
                            <div class="col-lg-3">
                                <asp:UpdatePanel ID="upnlCesium" runat="server">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnRender" /> 
                                    </Triggers>
                                    <ContentTemplate>
                                        <asp:Button ID="btnRender" runat="server" CssClass="cesium-button m-0 w-100 aspnet-width-fix" Text="Render" OnClick="btnRender_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="col-lg-3">
                                <button id="btnHide" class="cesium-button m-0 w-100" type="button" >Hide</button>
                            </div>
                            <div class="col-lg-3">
                                <button id="btnResetView" class="cesium-button m-0 w-100" type="button" >Reset View</button>
                            </div>
                            <div class="col-lg-3">
                                <button id="btnResetCountyInfoBoxPos" class="cesium-button m-0 w-100" type="button" >Reset Info Box Position</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <nav class="navbar navbar-dark bg-dark" style="padding:0; border-radius:3px;" onclick="expandControls();">
                <button class="navbar-toggler cesium-button" style="margin:0px;padding:2px;width:100%;" type="button" data-target="#controlNavbar" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
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

            function render() {
                var btnHide = document.getElementById("btnHide");
                if (btnHide.innerHTML == "Show") {
                    btnHide.click();
                }

                var rdoCountyLowQual = document.getElementById("rdoCountyLowQual");
                var rdoCountyMedQual = document.getElementById("rdoCountyMedQual");
                var rdoCountyHighQual = document.getElementById("rdoCountyHighQual");
                if (viewer.dataSources.get(0)) {
                    viewer.dataSources.remove(viewer.dataSources.get(0), false);
                }
                Cesium.Math.setRandomNumberSeed(0);
                var countyGeoJson;
                if (rdoCountyLowQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_20m.json');
                } else if (rdoCountyMedQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_5m.json');
                } else if (rdoCountyHighQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_500k.json');
                }
                
                countyGeoJson.then(function (dataSource) {
                    //var countyInfo = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/test.json');
                    //console.log(countyInfo.name);
                    viewer.dataSources.add(dataSource);
                    //viewer.dataSources.add(countyInfo);

                    //Get the array of countyGeoEntities
                    var countyGeoEntities = dataSource.entities.values;
                    //var countyInfoEntities = countyInfo.entities.values;

                    var colorHash = {};
                    for (var i = 0; i < countyGeoEntities.length; i++) {
                        //For each entity, create a random color based on the state name.
                        //Some states have multiple countyGeoEntities, so we store the color in a
                        //hash so that we use the same color for the entire state.
                        var entity = countyGeoEntities[i];
                        var name = entity.name;
                        var ddlState = document.getElementById("ddlState");
                        var ddlOutlineColor = document.getElementById("ddlOutlineColor");
                        var valDataOpacity = document.getElementById("valDataOpacity").value;
                        var chkAllStates = document.getElementById("<%=chkAllStates.ClientID %>").checked;

                        if (entity.properties.State == ddlState.options[ddlState.selectedIndex].value || chkAllStates) {
                            
                            var color = colorHash[name];
                            if (!color) {
                                color = Cesium.Color.fromRandom({
                                    alpha: valDataOpacity * '.01'
                                });
                                colorHash[name] = color;
                            }

                            //Set the polygon material to our random color.
                            entity.polygon.material = color;
                            //Remove the outlines.
                            ddlOutlineColor.value == "01" ? entity.polygon.outline = false : entity.polygon.outline = true;
                            if (entity.polygon.outline) {
                                if (ddlOutlineColor.value == "02") {
                                    entity.polygon.outlineColor = Cesium.Color.BLACK;
                                } else if (ddlOutlineColor.value == "03") {
                                    entity.polygon.outlineColor = Cesium.Color.RED;
                                } else if (ddlOutlineColor.value == "04") {
                                    entity.polygon.outlineColor = Cesium.Color.GREEN;
                                } else if (ddlOutlineColor.value == "05") {
                                    entity.polygon.outlineColor = Cesium.Color.BLUE;
                                } else if (ddlOutlineColor.value == "06") {
                                    entity.polygon.outlineColor = Cesium.Color.YELLOW;
                                }
                            }

                            //Extrude the polygon based on the state's population.  Each entity
                            //stores the properties for the GeoJSON feature it was created from
                            //Since the population is a huge number, we divide by 50.

                            //for (var i = 0; i < countyInfoEntities.length; i++) {
                            //    var infoEntity = countyInfoEntities[i];
                            //    console.log(infoEntity.properties.TrapName);
                            //}
                            entity.polygon.extrudedHeight = entity.properties.County * 1000;
                        } else {
                            entity.polygon.show = false;
                            entity.polygon.outline = false;
                        }

                        var heading = Cesium.Math.toRadians(0);
                        var pitch = Cesium.Math.toRadians(-90);

                        viewer.flyTo(countyGeoEntities, {
                            duration: 2.0,
                            offset: new Cesium.HeadingPitchRange(heading, pitch)
                        });
                    }
                }).otherwise(function(error){
                    //Display any errrors encountered while loading.
                    window.alert(error);
                });






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
            document.getElementById("btnResetCountyInfoBoxPos").addEventListener("click", function () {
                var cesiumInfoBox = document.getElementsByClassName("cesium-infoBox")[0];

                cesiumInfoBox.style.top = "101px";
                cesiumInfoBox.style.right = "5px";
                cesiumInfoBox.style.left = "";
            });
            document.getElementById("btnResetView").addEventListener("click", function () {
                if (viewer.dataSources.get(0)) {
                    var countyGeoEntities = viewer.dataSources.get(0).entities.values;
                    var heading = Cesium.Math.toRadians(0);
                    var pitch = Cesium.Math.toRadians(-90);

                    viewer.flyTo(countyGeoEntities, {
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
                    setTimeout(function () { $('#controlNavbar').collapse('show') }, 350);
                } else {
                    ctrlContainer.classList.replace("expanded","hidden");
                    $('#controlNavbar').collapse('hide');
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
            function toggleTooltip(ctrlID) {
                var ctrl = document.getElementById(ctrlID);
                if (ctrl.classList.contains("tooltip-hide")) {
                    ctrl.classList.replace("tooltip-hide", "tooltip-show");
                } else if (ctrl.classList.contains("tooltip-show")) {
                    ctrl.classList.replace("tooltip-show", "tooltip-hide");
                }
            }
            function updateSlideOutputLive(ctrlInput,ctrlOutputID) {
                var ctrlOutputID = document.getElementById(ctrlOutputID);
                ctrlOutputID.innerText = ctrlInput.value;
            }
        </script>
    </div>
</asp:Content>
