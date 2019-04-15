<%@ Page Title="WNV | Interactive Globe" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InteractiveGlobe.aspx.cs" Inherits="WNV._InteractiveMap" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MapContent" runat="server">
    <script src="/Scripts/Cesium/Build/Cesium/Cesium.js" type="text/javascript"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
    
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
                <div class="bg-dark p-3">
                    <div class="row">
                        <div class="col-lg-4">
                            <h3 class="text-white">Control Panel</h3>
                        </div>
                        <div class="col-lg-8">
                            <div class="row mb-2">
                                <div class="col-lg-12 text-white mb-0">
                                    <div class="cesium-button controlPanel-section-header m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlControlPanelSettings" aria-expanded="false" aria-controls="pnlControlPanelSettings" onclick="toggleDropdownCaret(this);">
                                        Control Panel Settings<span class="dropdown-caret"></span>
                                    </div>
                                </div>
                                <div id="pnlControlPanelSettings" class="controlPanel-section mb-0 w-100 mr-3 ml-3 collapse">
                                    <div class="row mb-2">
                                        <div class="col-lg-6">
                                            <div class="text-light">
                                                Control Panel Opacity
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="text-light">
                                                Control Panel Width
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mb-1">
                                        <div class="col-lg-6">
                                            <div class="slideContainer" onmouseover="document.getElementById('valCtrlPnlOpacity')">
                                                <input id="rngCtrlPnlOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="2" onchange="valCtrlPnlOpacity.value=value;adjustOpacity(value,'controlContainer');" onmouseover="toggleTooltip('valCtrlPnlOpacity');" onmouseout="toggleTooltip('valCtrlPnlOpacity');" onmousemove="updateSlideOutputLive(this,'valCtrlPnlOpacity');"/>
                                                <output class="tooltip-hide cesium-button text-white p-1 m-0 text-center" id="valCtrlPnlOpacity">100</output>
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="slideContainer">
                                                <input id="rngCtrlPnlWidth" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="40" min="25" max="50" step="1" onchange="valCtrlPnlWidth.value=value;adjustWidth(value,'controlContainer');" onmouseover="toggleTooltip('valCtrlPnlWidth');" onmouseout="toggleTooltip('valCtrlPnlWidth');" onmousemove="updateSlideOutputLive(this,'valCtrlPnlWidth');"/>
                                                <output id="valCtrlPnlWidth" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">35</output>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12 text-white mb-0">
                            <div class="cesium-button controlPanel-section-header m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlParameters" aria-expanded="false" aria-controls="pnlParameters" onclick="toggleDropdownCaret(this);">
                                Parameters<span class="dropdown-caret"></span>
                            </div>
                        </div>
                    </div>
                    <div id="pnlParameters" class="controlPanel-section mb-0 collapse">
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
                                <asp:DropDownList ID="ddlVisType" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%" onchange="toggleParameterPanel(this);" ClientIDMode="Static">
                                    <asp:ListItem Value="1" Text="Univariate County Heatmap" ></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Univariate County Extrusion" ></asp:ListItem>
                                    <%--<asp:ListItem Value="3" Text="Bivariate County Extrusion" ></asp:ListItem>--%>
                                    <asp:ListItem Value="4" Text="Pearson's Correlation County Heatmap" ></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Univariate State Heatmap" ></asp:ListItem>
                                    <asp:ListItem Value="6" Text="Univariate State Extrusion" ></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-lg-3">
                                <%--<asp:DropDownList ID="ddlState" runat="server" CssClass="dropdown-item cesium-button p-0 m-0 aspnet-width-fix"></asp:DropDownList>--%>
                                <select id="ddlState" runat="server" class="cesium-button p-1 m-0 w-100 aspnet-width-fix" disabled="disabled" aria-disabled="true" ClientIDMode="Static" >
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
                                <div class="form-check-inline disabled">
                                    <input id="chkAllStates" runat="server" class="form-check-input aspnet-width-fix" type="checkbox" onchange="toggleStateDDL();" ClientIDMode="Static" disabled/>
                                    <label class="form-check-label" for="chkAllStates">Use All States</label>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-12 text-white mb-0">
                                <div class="m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlVisualization1" aria-expanded="false" aria-controls="pnlVisualization1">
                                </div>
                            </div>
                        </div>
                        <div id="pnlVisualization1" class="mb-0 mt-1 collapse show">
                            <%--<div class="row mb-1">
                                <div class="col-lg-12">
                                    <h6 class="text-white">Mosquito Count Variables</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-4">
                                    <div class="form-check">
                                        <input id="rdoUniHeatAllMosquitoes" name="rdogrpUniHeatVars" class="form-check-input" type="radio" checked="checked" />
                                        <label class="form-check-label text-light" for="rdoUniHeatAllMosquitoes">All</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatMales" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatMales">Males</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatFemales" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatFemales">Females</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatOther" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatOther">Other</label>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="form-check">
                                        <input id="rdoUniHeatAedes" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light" for="rdoUniHeatAedes">Aedes</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatAedesVexans" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatAedesVexans">Aedes Vexans</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatAnopheles" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatAnopheles">Anopheles</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatCulex" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatCulex">Culex</label>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="form-check">
                                        <input id="rdoUniHeatCulexSalinarius" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light" for="rdoUniHeatCulexSalinarius">Culex Salinarius</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatCulexTarsalis" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatCulexTarsalis">Culex Tarsalis</label>
                                    </div>
                                    <div class="form-check">
                                        <input id="rdoUniHeatCuliseta" name="rdogrpUniHeatVars" class="form-check-input" type="radio" />
                                        <label class="form-check-label text-light"for="rdoUniHeatCuliseta">Culiseta</label>
                                    </div>
                                </div>
                            </div>--%>
                            <div class="row mb-1">
                                <div class="col-lg-3">
                                    <h6 class="text-white">Mosquito Vairable</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">Start Year</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">End Year</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">Statistic</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-3">
                                    <select id="ddlUniHeatMosquitoVariable" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="Mosquitoes">All</option>
                                        <option value="Males">Males</option>
                                        <option value="Females">Females</option>
                                        <option value="Other">Other</option>
                                        <option value="Aedes">Aedes</option>
                                        <option value="Aedes Vexans">Aedes Vexans</option>
                                        <option value="Anopheles">Anopheles</option>
                                        <option value="Culex">Culex</option>
                                        <option value="Culex Salinarius">Culex Salinarius</option>
                                        <option value="Culex Tarsalis">Culex Tarsalis</option>
                                        <option value="Culiseta">Culiseta</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlUniHeatStartYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlUniHeatEndYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlUniHeatStat" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%">
                                        <asp:ListItem Value="Mean" Text="Average" ></asp:ListItem>
                                        <asp:ListItem Value="Total" Text="Sum" ></asp:ListItem>
                                    </asp:DropDownList>
                                    <%--<select id="ddlUniHeatStat" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="1" selected="selected">Average</option>
                                        <option value="2">Sum</option>
                                    </select>--%>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-12 text-white mb-0">
                                <div class="m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlVisualization2" aria-expanded="false" aria-controls="pnlVisualization2">
                                </div>
                            </div>
                        </div>
                        <div id="pnlVisualization2" class="mb-0 mt-1 collapse">
                            <div class="row mb-1">
                                <div class="col-lg-3">
                                    <h6 class="text-white">Mosquito Vairable</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">Start Year</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">End Year</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">Statistic</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-3">
                                    <select id="ddlUniExtrMosquitoVariable" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="Mosquitoes">All</option>
                                        <option value="Males">Males</option>
                                        <option value="Females">Females</option>
                                        <option value="Other">Other</option>
                                        <option value="Aedes">Aedes</option>
                                        <option value="Aedes Vexans">Aedes Vexans</option>
                                        <option value="Anopheles">Anopheles</option>
                                        <option value="Culex">Culex</option>
                                        <option value="Culex Salinarius">Culex Salinarius</option>
                                        <option value="Culex Tarsalis">Culex Tarsalis</option>
                                        <option value="Culiseta">Culiseta</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlUniExtrStartYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlUniExtrEndYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlUniExtrStat" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%">
                                        <asp:ListItem Value="Mean" Text="Average" ></asp:ListItem>
                                        <asp:ListItem Value="Total" Text="Sum" ></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="row mb-1">
                                <div class="col-lg-6">
                                    <h6 class="text-white">Extrusion Factor</h6>
                                </div>
                                <div class="col-lg-6">
                                    <h6 class="text-white">Data Opacity</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-6">
                                    <div class="slideContainer">
                                        <input id="rngUniExtrExtrusionFactor" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valUniExtrExtrusionFactor.value=value;" onmouseover="toggleTooltip('valUniExtrExtrusionFactor');" onmouseout="toggleTooltip('valUniExtrExtrusionFactor');" onmousemove="updateSlideOutputLive(this,'valUniExtrExtrusionFactor');"/>
                                        <output id="valUniExtrExtrusionFactor" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">100</output>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="slideContainer">
                                        <input id="rngUniExtrDataOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valUniExtrDataOpacity.value=value;" onmouseover="toggleTooltip('valUniExtrDataOpacity');" onmouseout="toggleTooltip('valUniExtrDataOpacity');" onmousemove="updateSlideOutputLive(this,'valUniExtrDataOpacity');"/>
                                        <output id="valUniExtrDataOpacity" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">100</output>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-12 text-white mb-0">
                                <div class="m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlVisualization3" aria-expanded="false" aria-controls="pnlVisualization3">
                                </div>
                            </div>
                        </div>
                        <div id="pnlVisualization3" class="mb-0 mt-1 collapse">
                            <div class="row mb-1">
                                <div class="col-lg-4">
                                    <h6 class="text-white">Mosquito Vairable</h6>
                                </div>
                                <div class="col-lg-fivehalves">
                                    <h6 class="text-white">Start Year</h6>
                                </div>
                                <div class="col-lg-fivehalves">
                                    <h6 class="text-white">End Year</h6>
                                </div>
                                <div class="col-lg-3">
                                    <h6 class="text-white">Statistic</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-4">
                                    <select id="ddlMultiExtrMosquitoVariable" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="Mosquitoes">All</option>
                                        <option value="Males">Males</option>
                                        <option value="Females">Females</option>
                                        <option value="Other">Other</option>
                                        <option value="Aedes">Aedes</option>
                                        <option value="Aedes Vexans">Aedes Vexans</option>
                                        <option value="Anopheles">Anopheles</option>
                                        <option value="Culex">Culex</option>
                                        <option value="Culex Salinarius">Culex Salinarius</option>
                                        <option value="Culex Tarsalis">Culex Tarsalis</option>
                                        <option value="Culiseta">Culiseta</option>
                                    </select>
                                </div>
                                <div class="col-lg-fivehalves">
                                    <asp:DropDownList ID="ddlMultiExtrStartYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                                <div class="col-lg-fivehalves">
                                    <asp:DropDownList ID="ddlMultiExtrEndYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                                <div class="col-lg-3">
                                    <asp:DropDownList ID="ddlMultiExtrStat" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%">
                                        <asp:ListItem Value="Mean" Text="Average" ></asp:ListItem>
                                        <asp:ListItem Value="Total" Text="Sum" ></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="row mb-1">
                                <div class="col-lg-4">
                                    <h6 class="text-white">Weather Variable</h6>
                                </div>
                                <div class="col-lg-4">
                                    <h6 class="text-white">Extrusion Factor</h6>
                                </div>
                                <div class="col-lg-4">
                                    <h6 class="text-white">Data Opacity</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-4">
                                    <select id="Select1" runat="server" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="Avg Temp">Mean Temp (F&deg;)</option>
                                        <option value="Max Temp">Max Temp (F&deg;)</option>
                                        <option value="Min Temp">Min Temp (F&deg;)</option>
                                        <option value="Bare Soil Temp">Bare Soil Temp (F&deg;)</option>
                                        <option value="Turf Soil Temp">Turf Soil Temp (F&deg;)</option>
                                        <option value="Dew Point">Dew Point (F&deg;)</option>
                                        <option value="Wind Chill">Wind Chill (F&deg;)</option>
                                        <option value="Avg Wind Speed">Mean Wind Speed (mph)</option>
                                        <option value="Max Wind Speed">Max Wind Speed (mph)</option>
                                        <option value="Solar Rad">Solar Radiation (W/m&sup2;)</option>
                                        <option value="Rainfall">Rainfall (in)</option>
                                    </select>
                                </div>
                                <div class="col-lg-4">
                                    <div class="slideContainer">
                                        <input id="rngMultiExtrExtrusionFactor" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valMultiExtrExtrusionFactor.value=value;" onmouseover="toggleTooltip('valMultiExtrExtrusionFactor');" onmouseout="toggleTooltip('valMultiExtrExtrusionFactor');" onmousemove="updateSlideOutputLive(this,'valMultiExtrExtrusionFactor');"/>
                                        <output id="valMultiExtrExtrusionFactor" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">100</output>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="slideContainer">
                                        <input id="rngMultiExtrDataOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valMultiExtrDataOpacity.value=value;" onmouseover="toggleTooltip('valMultiExtrDataOpacity');" onmouseout="toggleTooltip('valMultiExtrDataOpacity');" onmousemove="updateSlideOutputLive(this,'valMultiExtrDataOpacity');"/>
                                        <output id="valMultiExtrDataOpacity" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">100</output>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-12 text-white mb-0">
                                <div class="m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlVisualization4" aria-expanded="false" aria-controls="pnlVisualization4">
                                </div>
                            </div>
                        </div>
                        <div id="pnlVisualization4" class="mb-0 mt-1 collapse">
                            <div class="row mb-1">
                                <div class="col-lg-6">
                                    <h6 class="text-white">Mosquito Vairable</h6>
                                </div>
                                <div class="col-lg-6">
                                    <h6 class="text-white">Mosquito Delay Weeks</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-6">
                                    <select id="ddlPearsonHeatMosquitoVar" runat="server" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="All Mosquitoes">All</option>
                                        <option value="Males">Males</option>
                                        <option value="Females">Females</option>
                                        <option value="Other">Other</option>
                                        <option value="Aedes">Aedes</option>
                                        <option value="Aedes Vexans">Aedes Vexans</option>
                                        <option value="Anopheles">Anopheles</option>
                                        <option value="Culex">Culex</option>
                                        <option value="Culex Salinarius">Culex Salinarius</option>
                                        <option value="Culex Tarsalis">Culex Tarsalis</option>
                                        <option value="Culiseta">Culiseta</option>
                                    </select>
                                </div>
                                <div class="col-lg-6">
                                    <asp:UpdatePanel ID="upnlPearsonDelayWeeks" runat="server">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="ddlPearsonHeatDelayWeeks" /> 
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:DropDownList ID="ddlPearsonHeatDelayWeeks" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddlPearsonHeatDelayWeeks_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="0" ></asp:ListItem>
                                                <asp:ListItem Value="1" Text="1" ></asp:ListItem>
                                                <asp:ListItem Value="2" Text="2" ></asp:ListItem>
                                                <asp:ListItem Value="3" Text="3" ></asp:ListItem>
                                                <asp:ListItem Value="4" Text="4" ></asp:ListItem>
                                            </asp:DropDownList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                            <div class="row mb-1">
                                <div class="col-lg-6">
                                    <h6 class="text-white">Weather Vairable</h6>
                                </div>
                                <div class="col-lg-6">
                                    <h6 class="text-white">Week Of Summer</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-6">
                                    <select id="ddlPearsonHeatWeatherVar" runat="server" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                        <option value="Avg Temp">Mean Temp (F&deg;)</option>
                                        <option value="Max Temp">Max Temp (F&deg;)</option>
                                        <option value="Min Temp">Min Temp (F&deg;)</option>
                                        <option value="Bare Soil Temp">Bare Soil Temp (F&deg;)</option>
                                        <option value="Turf Soil Temp">Turf Soil Temp (F&deg;)</option>
                                        <option value="Dew Point">Dew Point (F&deg;)</option>
                                        <option value="Wind Chill">Wind Chill (F&deg;)</option>
                                        <option value="Avg Wind Speed">Mean Wind Speed (mph)</option>
                                        <option value="Max Wind Speed">Max Wind Speed (mph)</option>
                                        <option value="Solar Rad">Solar Radiation (W/m&sup2;)</option>
                                        <option value="Rainfall">Rainfall (in)</option>
                                    </select>
                                </div>
                                <div class="col-lg-6">
                                    <asp:UpdatePanel ID="upnlPearsonWeekOfInterest" runat="server">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="ddlPearsonHeatWeekOfInterest" /> 
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:DropDownList ID="ddlPearsonHeatWeekOfInterest" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddlPearsonHeatWeekOfInterest_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="1" ></asp:ListItem>
                                                <asp:ListItem Value="2" Text="2" ></asp:ListItem>
                                                <asp:ListItem Value="3" Text="3" ></asp:ListItem>
                                                <asp:ListItem Value="4" Text="4" ></asp:ListItem>
                                                <asp:ListItem Value="5" Text="5" ></asp:ListItem>
                                                <asp:ListItem Value="6" Text="6" ></asp:ListItem>
                                                <asp:ListItem Value="7" Text="7" ></asp:ListItem>
                                                <asp:ListItem Value="8" Text="8" ></asp:ListItem>
                                                <asp:ListItem Value="9" Text="9" ></asp:ListItem>
                                                <asp:ListItem Value="10" Text="10" ></asp:ListItem>
                                                <asp:ListItem Value="11" Text="11" ></asp:ListItem>
                                                <asp:ListItem Value="12" Text="12" ></asp:ListItem>
                                                <asp:ListItem Value="13" Text="13" ></asp:ListItem>
                                                <asp:ListItem Value="14" Text="14" ></asp:ListItem>
                                            </asp:DropDownList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-12 text-white mb-0">
                                <div class="m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlVisualization5" aria-expanded="false" aria-controls="pnlVisualization5">
                                </div>
                            </div>
                        </div>
                        <div id="pnlVisualization5" class="mb-0 mt-1 collapse">
                            <div class="row mb-1">
                                <div class="col-lg-4">
                                    <h6 class="text-white">Case Vairable</h6>
                                </div>
                                <div class="col-lg-4">
                                    <h6 class="text-white">Start Year</h6>
                                </div>
                                <div class="col-lg-4">
                                    <h6 class="text-white">End Year</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-4">
                                    <asp:DropDownList ID="ddlUniHeatStateCaseVariable" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%" ClientIDMode="Static">
                                        <asp:ListItem Value="Cases" Text="WNV Cases" ></asp:ListItem>
                                        <asp:ListItem Value="Deaths" Text="WNV Deaths" ></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <asp:DropDownList ID="ddlUniHeatStateCaseStartYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%" DataTextFormatString="{0:yyyy}"></asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <asp:DropDownList ID="ddlUniHeatStateCaseEndYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%" DataTextFormatString="{0:yyyy}"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-12 text-white mb-0">
                                <div class="m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlVisualization6" aria-expanded="false" aria-controls="pnlVisualization6">
                                </div>
                            </div>
                        </div>
                        <div id="pnlVisualization6" class="mb-0 mt-1 collapse">
                            <div class="row mb-1">
                                <div class="col-lg-4">
                                    <h6 class="text-white">Case Vairable</h6>
                                </div>
                                <div class="col-lg-4">
                                    <h6 class="text-white">Start Year</h6>
                                </div>
                                <div class="col-lg-4">
                                    <h6 class="text-white">End Year</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-4">
                                    <asp:DropDownList ID="ddlUniExtrStateCaseVariable" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%" ClientIDMode="Static">
                                        <asp:ListItem Value="Cases" Text="WNV Cases" ></asp:ListItem>
                                        <asp:ListItem Value="Deaths" Text="WNV Deaths" ></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <asp:DropDownList ID="ddlUniExtrStateCaseStartYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%" DataTextFormatString="{0:yyyy}"></asp:DropDownList>
                                </div>
                                <div class="col-lg-4">
                                    <asp:DropDownList ID="ddlUniExtrStateCaseEndYear" runat="server" CssClass="cesium-button p-1 m-0 w-100 aspnet-width-fix" Width="100%" DataTextFormatString="{0:yyyy}"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row mb-1">
                                <div class="col-lg-6">
                                    <h6 class="text-white">Extrusion Factor</h6>
                                </div>
                                <div class="col-lg-6">
                                    <h6 class="text-white">Data Opacity</h6>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-lg-6">
                                    <div class="slideContainer">
                                        <input id="rngUniExtrStateExtrusionFactor" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valUniExtrStateExtrusionFactor.value=value;" onmouseover="toggleTooltip('valUniExtrStateExtrusionFactor');" onmouseout="toggleTooltip('valUniExtrStateExtrusionFactor');" onmousemove="updateSlideOutputLive(this,'valUniExtrStateExtrusionFactor');"/>
                                        <output id="valUniExtrStateExtrusionFactor" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">100</output>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="slideContainer">
                                        <input id="rngUniExtrStateDataOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valUniExtrStateDataOpacity.value=value;" onmouseover="toggleTooltip('valUniExtrStateDataOpacity');" onmouseout="toggleTooltip('valUniExtrStateDataOpacity');" onmousemove="updateSlideOutputLive(this,'valUniExtrStateDataOpacity');"/>
                                        <output id="valUniExtrStateDataOpacity" class="tooltip-hide cesium-button text-white p-1 m-0 text-center">100</output>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12 text-white mb-0">
                            <div class="cesium-button controlPanel-section-header m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlRenderSettings" aria-expanded="false" aria-controls="pnlRenderSettings" onclick="toggleDropdownCaret(this);">
                                Render Settings<span class="dropdown-caret"></span>
                            </div>
                        </div>
                    </div>
                    <div id="pnlRenderSettings" class="controlPanel-section mb-0 collapse">
                        <div class="row mb-1">
                            <div class="col-lg-4">
                                <h6 class="text-white">County Border Quality</h6>
                            </div>
                            <div class="col-lg-offset-onehalf">
                            </div>
                            <div class="col-lg-7">
                                <h6 class="text-white">Outline Color</h6>
                            </div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-lg-threehalves">
                                <div class="form-check-inline">
                                    <input id="rdoCountyLowQual" name="rdoCountyQuality" class="form-check-input" type="radio" checked="checked" />
                                    <label class="form-check-label text-light" for="rdoCountyLowQual">Low</label>
                                </div>
                            </div>
                            <div class="col-lg-threehalves">
                                <div class="form-check-inline">
                                    <input id="rdoCountyMedQual" name="rdoCountyQuality" class="form-check-input" type="radio" />
                                    <label class="form-check-label text-light"for="rdoCountyMedQual">Med</label>
                                </div>
                            </div>
                            <div class="col-lg-threehalves">
                                <div class="form-check-inline">
                                    <input id="rdoCountyHighQual" name="rdoCountyQuality" class="form-check-input" type="radio" />
                                    <label class="form-check-label text-light"for="rdoCountyHighQual">High</label>
                                </div>
                            </div>
                            <div class="col-lg-fivehalves">
                                <select id="ddlOutlineColor" class="cesium-button p-1 m-0 w-100 aspnet-width-fix">
                                    <option value="01" selected="selected">None</option>
                                    <option value="02">Black</option>
                                    <option value="03">Red</option>
                                    <option value="04">Green</option>
                                    <option value="05">Blue</option>
                                    <option value="06">Yellow</option>
                                </select>
                            </div>
                            <div class="col-lg-fivehalves">
                                <div class="form-check-inline">
                                    <input id="chkShowLabels" type="checkbox" class="form-check-input" checked="checked" onclick="showLabels();" />
                                    <label class="form-check-label text-light" for="chkShowLabels">Show Labels</label>
                                </div>
                            </div>
                            <div class="col-lg-fivehalves">
                                <div class="form-check-inline">
                                    <input id="chkShowTraps" type="checkbox" class="form-check-input" onclick="showTraps();" />
                                    <label class="form-check-label text-light " for="chkShowTraps">Show Traps</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-1">
                        <div class="col-lg-12 text-white mb-0">
                            <div class="cesium-button controlPanel-section-header m-0 dropdown-toggle" data-toggle="collapse" data-target="#pnlActions" aria-expanded="false" aria-controls="pnlActions" onclick="toggleDropdownCaret(this);">
                                Actions
                                <span class="dropdown-caret"></span>
                            </div>
                        </div>
                    </div>
                    <div id="pnlActions" class="controlPanel-section mb-0 collapse">
                        <div class="row mb-2">
                            <div class="col-lg-4">
                                <asp:UpdatePanel ID="upnlbtnRender" runat="server">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="btnRender" /> 
                                    </Triggers>
                                    <ContentTemplate>
                                        <asp:Button ID="btnRender" runat="server" CssClass="cesium-button m-0 w-100 aspnet-width-fix" Text="Render" OnClick="btnRender_Click" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="col-lg-4">
                                <button id="btnHide" class="cesium-button m-0 w-100" type="button" >Hide</button>
                            </div>
                            <div class="col-lg-4">
                                <button id="btnClear" class="cesium-button m-0 w-100" type="button" >Clear</button>
                            </div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-lg-6">
                                <button id="btnResetView" class="cesium-button m-0 w-100" type="button" >Reset View</button>
                            </div>
                            <div class="col-lg-6">
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
       <script type="text/javascript" src="/Scripts/interactiveGlobe.js"></script>
    </div>
</asp:Content>
