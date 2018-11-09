﻿<%@ Page Title="WNVF | Interactive Globe" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InteractiveGlobe.aspx.cs" Inherits="WNV._InteractiveMap" %>

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
                                                <output class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center" id="valCtrlPnlOpacity">100</output>
                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <div class="slideContainer">
                                                <input id="rngCtrlPnlWidth" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="40" min="25" max="50" step="1" onchange="valCtrlPnlWidth.value=value;adjustWidth(value,'controlContainer');" onmouseover="toggleTooltip('valCtrlPnlWidth');" onmouseout="toggleTooltip('valCtrlPnlWidth');" onmousemove="updateSlideOutputLive(this,'valCtrlPnlWidth');"/>
                                                <output id="valCtrlPnlWidth" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">35</output>
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
                                <asp:DropDownList ID="ddlVisType" runat="server" CssClass="cesium-button p-1 m-0 aspnet-width-fix" Width="100%" onchange="toggleParameterPanel(this);">
                                    <asp:ListItem Value="1" Text="Univariate County Heatmap" ></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Univariate County Extrusion" ></asp:ListItem>
                                    <%--<asp:ListItem Value="3" Text="Bivariate County Extrusion" ></asp:ListItem>--%>
                                    <asp:ListItem Value="4" Text="Pearson's Correlation County Heatmap" ></asp:ListItem>
                                </asp:DropDownList>
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
                                <div class="form-check-inline disabled">
                                    <input id="chkAllStates" class="form-check-input aspnet-width-fix" type="checkbox" disabled/>
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
                                        <output id="valUniExtrExtrusionFactor" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">100</output>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="slideContainer">
                                        <input id="rngUniExtrDataOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valUniExtrDataOpacity.value=value;" onmouseover="toggleTooltip('valUniExtrDataOpacity');" onmouseout="toggleTooltip('valUniExtrDataOpacity');" onmousemove="updateSlideOutputLive(this,'valUniExtrDataOpacity');"/>
                                        <output id="valUniExtrDataOpacity" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">100</output>
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
                                        <output id="valMultiExtrExtrusionFactor" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">100</output>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="slideContainer">
                                        <input id="rngMultiExtrDataOpacity" class="ctrlSlider cesium-button p-3 m-0 w-100" type="range" value="100" min="10" max="100" step="1" onchange="valMultiExtrDataOpacity.value=value;" onmouseover="toggleTooltip('valMultiExtrDataOpacity');" onmouseout="toggleTooltip('valMultiExtrDataOpacity');" onmousemove="updateSlideOutputLive(this,'valMultiExtrDataOpacity');"/>
                                        <output id="valMultiExtrDataOpacity" class="tooltip-hide cesium-button text-white p-1 m-0 w-100 text-center">100</output>
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
        <script>

            document.getElementById('rngCtrlPnlOpacity').value = 100;
            document.getElementById('rngCtrlPnlWidth').value = 40;

            var CesiumAPIKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NjhhNWVlOS0yYThiLTQ3M2YtOTBiNC03ZWY0YmFhMDZiNzgiLCJpZCI6NDA4NCwic2NvcGVzIjpbImFzbCIsImFzciIsImFzdyIsImdjIl0sImlhdCI6MTUzOTg1MDc4N30.jQhxjgKS3zpd5MKaks7_oSddnE_jtCC6fFSsfFufwj8";
            Cesium.Ion.defaultAccessToken = CesiumAPIKey;
            
            var viewer = new Cesium.Viewer('cesiumContainer');
            var trapGeoEntities;
            var countyGeoEntitiesValues;
            var globalRefCountyDataSource;
            var globalRefTrapDataSource;

            function renderCountyPolygons(jsonString) {

                var jsonToRender = JSON.parse(jsonString);
                var columnOfInterest = "Total Mosquitoes";
                var maxColumnValue;
                var minColumnValue;
                var currentColumnValue;

                for (var i = 0; i < jsonToRender.length; i++){
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

                var rdoCountyLowQual = document.getElementById("rdoCountyLowQual");
                var rdoCountyMedQual = document.getElementById("rdoCountyMedQual");
                var rdoCountyHighQual = document.getElementById("rdoCountyHighQual");
                if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
                    viewer.dataSources.remove(globalRefCountyDataSource, false);
                }
                
                var countyGeoJson;
                if (rdoCountyLowQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_20m.json');
                } else if (rdoCountyMedQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_5m.json');
                } else if (rdoCountyHighQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_500k.json');
                }
                
                countyGeoJson.then(function (countyDataSource) {
                    
                    var chkAllStates = document.getElementById("chkAllStates").checked;
                    var ddlState = document.getElementById("ddlState");
                    var ddlOutlineColor = document.getElementById("ddlOutlineColor");
                    var chkShowLabels = document.getElementById("chkShowLabels").checked;
                    var valDataOpacity = document.getElementById("valDataOpacity").value;
                    
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
                    var colorHash = {};
                    
                    var date0 = new Date();
                    var time0 = date0.getTime();
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

                            for (var j = 0; j < jsonToRender.length; j++){
                                
                                var mosquitoDataRow = jsonToRender[j];
                                for (var key in mosquitoDataRow){
                                    var columnHeader = key;
                                    var columnValue = mosquitoDataRow[columnHeader];
                                    if (columnValue == name) {
                                        var columnCountyName = columnValue;
                                        var valueOfInterest = mosquitoDataRow[columnOfInterest];
                                        countyEntity.polygon.extrudedHeight = valueOfInterest * 500;
                                        countyEntity.description =
                                            '<h1>' + columnCountyName + ' County</h1>' +
                                            '<div class="row">'+
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
                                            Math.floor((valueOfInterest/maxColumnValue) * 255)
                                        );
                                        countyEntity.polygon.material = color;
                                        countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;

                                        var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                                        //var countyCenter = Cesium.BoundingSphere.fromPoints(countyPolygonPositions).center;
                                        //countyEntity.position = countyCenter;

                                        var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                                        var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                                        var countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 4000);
                                        countyEntity.position = countyExtrusionHeightOffset;
                                        
                                        countyEntity.label = {
                                            show: chkShowLabels,
                                            text : valueOfInterest + '',
                                            font : '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                            fillColor : Cesium.Color.WHITE,
                                            outlineColor : Cesium.Color.BLACK,
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
                    
                    var heading = Cesium.Math.toRadians(0);
                    var pitch = Cesium.Math.toRadians(-90);
                    viewer.flyTo(countyGeoEntitiesValues, {
                        duration: 2.0,
                        offset: new Cesium.HeadingPitchRange(heading, pitch)
                    });
                    viewer.dataSources.add(countyDataSource);
                    globalRefCountyDataSource = countyDataSource;

                    
                    var date1 = new Date();
                    var time1 = date1.getTime();
                    console.log("Retrieving the data took " + (time1 - time0) + " milliseconds.");

                }).otherwise(function(error){
                    //Display any errrors encountered while loading.
                    window.alert(error);
                });
            }












            function renderUnivariateHeatmap(jsonString,statType) {

                var jsonToRender = JSON.parse(jsonString);
                var mosquitoVariable = document.getElementById("ddlUniHeatMosquitoVariable").value;
                var columnOfInterest = statType + " " + mosquitoVariable;
                var infoBoxMessage = "";
                if (statType == "Mean") {
                    infoBoxMessage = columnOfInterest + "";
                } else if (statType == "Total") {
                    infoBoxMessage = columnOfInterest + "";
                }
                var maxColumnValue;
                var minColumnValue;
                var currentColumnValue;

                for (var i = 0; i < jsonToRender.length; i++){
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

                var rdoCountyLowQual = document.getElementById("rdoCountyLowQual");
                var rdoCountyMedQual = document.getElementById("rdoCountyMedQual");
                var rdoCountyHighQual = document.getElementById("rdoCountyHighQual");
                if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
                    viewer.dataSources.remove(globalRefCountyDataSource, false);
                }
                
                var countyGeoJson;
                if (rdoCountyLowQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_20m.json');
                } else if (rdoCountyMedQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_5m.json');
                } else if (rdoCountyHighQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_500k.json');
                }
                
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
                    var colorHash = {};
                    
                    var date0 = new Date();
                    var time0 = date0.getTime();
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

                            for (var j = 0; j < jsonToRender.length; j++){
                                
                                var mosquitoDataRow = jsonToRender[j];
                                for (var key in mosquitoDataRow){
                                    var columnHeader = key;
                                    var columnValue = mosquitoDataRow[columnHeader];
                                    if (columnValue == name) {
                                        var columnCountyName = columnValue;
                                        var valueOfInterest = mosquitoDataRow[columnOfInterest];
                                        countyEntity.polygon.extrudedHeight = 0;
                                        var color = new Cesium.Color.fromBytes(
                                            255,
                                            0,
                                            0,
                                            Math.floor((valueOfInterest/maxColumnValue) * 255)
                                        );
                                        countyEntity.polygon.material = color;
                                        var colorBytes = color.toBytes();

                                        var valueOfInterestLegendOffsetText = "";
                                        var valueOfInterestLegendOffsetValue = Math.round(((maxColumnValue - valueOfInterest) / maxColumnValue) * 298);
                                        if (!valueOfInterestLegendOffsetValue == 0) {
                                            valueOfInterestLegendOffsetText = '<div class="row" style="height:' + valueOfInterestLegendOffsetValue + 'px"><div class="col-xs-12"></div></div>';
                                        }
                                        

                                        countyEntity.description =
                                            '<h2 class="text-center">' + columnCountyName + ' County</h2>' +
                                            '<div class="row" style="margin-bottom:20px">'+
                                                '<div class="col-xs-6 text-right">' +
                                                    infoBoxMessage +
                                                '</div>' +
                                                '<div class="col-xs-6">' +
                                                    valueOfInterest +
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row">'+
                                                '<div class="col-xs-4 text-right" style="padding-right:0px">' +
                                                    '<div class="row" style="height:150px"><div class="col-xs-12">'+maxColumnValue + '&nbsp;&nbsp;&mdash;'+'</div></div>'+
                                                    '<div class="row" style="height:150px"><div class="col-xs-12"></div></div>'+
                                                    '<div class="row" style="height:22px"><div class="col-xs-12">'+minColumnValue + '&nbsp;&nbsp;&mdash;'+'</div></div>'+
                                                '</div>' +
                                                '<div class="col-xs-4" style="margin-top:12px">' +
                                                    '<div style="height:300px;background-image: linear-gradient(rgba('+colorBytes[0]+','+colorBytes[1]+','+colorBytes[2]+'),rgba('+colorBytes[0]+','+colorBytes[1]+','+colorBytes[2]+','+(minColumnValue/maxColumnValue)+')">' +
                                                        
                                                    '</div>' +
                                                '</div>' +
                                                '<div class="col-xs-4" style="padding-left:0px">' +
                                                    valueOfInterestLegendOffsetText +
                                                    '<div class="row"><div class="col-xs-12"><span style="font-size:18px">&larr;</span>&nbsp;&nbsp;' + valueOfInterest +'</div></div>'+
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row" style="margin-top:20px">'+
                                                '<div class="col-xs-4 text-right">' +
                                                    infoBoxMessage +
                                                '</div>' +
                                                '<div class="col-xs-4 text-center">' +
                                                    'Intensity' +
                                                '</div>' +
                                                '<div class="col-xs-4 text-left">' +
                                                    columnCountyName +
                                                '</div>' +
                                            '</div>' 
                                            ;
                                        
                                        countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;

                                        var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                                        //var countyCenter = Cesium.BoundingSphere.fromPoints(countyPolygonPositions).center;
                                        //countyEntity.position = countyCenter;

                                        var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                                        var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                                        var countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 4000);
                                        countyEntity.position = countyExtrusionHeightOffset;
                                        
                                        countyEntity.label = {
                                            show: chkShowLabels,
                                            text : valueOfInterest + '',
                                            font : '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                            fillColor : Cesium.Color.WHITE,
                                            outlineColor : Cesium.Color.BLACK,
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
                    
                    var heading = Cesium.Math.toRadians(0);
                    var pitch = Cesium.Math.toRadians(-90);
                    viewer.flyTo(countyGeoEntitiesValues, {
                        duration: 2.0,
                        offset: new Cesium.HeadingPitchRange(heading, pitch)
                    });
                    viewer.dataSources.add(countyDataSource);
                    globalRefCountyDataSource = countyDataSource;

                    
                    var date1 = new Date();
                    var time1 = date1.getTime();
                    //console.log("Retrieving the data took " + (time1 - time0) + " milliseconds.");

                }).otherwise(function(error){
                    //Display any errrors encountered while loading.
                    window.alert(error + " Univariate Heatmap");
                });
            }























            function renderUnivariateExtrusion(jsonString,statType) {

                var jsonToRender = JSON.parse(jsonString);
                var mosquitoVariable = document.getElementById("ddlUniExtrMosquitoVariable").value;
                var columnOfInterest = statType + " " + mosquitoVariable;
                var infoBoxMessage = "";
                if (statType == "Mean") {
                    infoBoxMessage = columnOfInterest + "";
                } else if (statType == "Total") {
                    infoBoxMessage = columnOfInterest + "";
                }
                var maxColumnValue;
                var minColumnValue;
                var currentColumnValue;

                for (var i = 0; i < jsonToRender.length; i++){
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

                var rdoCountyLowQual = document.getElementById("rdoCountyLowQual");
                var rdoCountyMedQual = document.getElementById("rdoCountyMedQual");
                var rdoCountyHighQual = document.getElementById("rdoCountyHighQual");
                if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
                    viewer.dataSources.remove(globalRefCountyDataSource, false);
                }
                
                var countyGeoJson;
                if (rdoCountyLowQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_20m.json');
                } else if (rdoCountyMedQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_5m.json');
                } else if (rdoCountyHighQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_500k.json');
                }
                
                countyGeoJson.then(function (countyDataSource) {
                    
                    var chkAllStates = document.getElementById("chkAllStates").checked;
                    var ddlState = document.getElementById("ddlState");
                    var ddlOutlineColor = document.getElementById("ddlOutlineColor");
                    var chkShowLabels = document.getElementById("chkShowLabels").checked;
                    var extrusionFactor = document.getElementById("valUniExtrExtrusionFactor").value;
                    var dataOpacity = document.getElementById("valUniExtrDataOpacity").value;
                    
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
                    var colorHash = {};
                    
                    var date0 = new Date();
                    var time0 = date0.getTime();
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
                            

                            for (var j = 0; j < jsonToRender.length; j++){
                                
                                var mosquitoDataRow = jsonToRender[j];
                                for (var key in mosquitoDataRow){
                                    var columnHeader = key;
                                    var columnValue = mosquitoDataRow[columnHeader];
                                    if (columnValue == name) {
                                        var columnCountyName = columnValue;
                                        var valueOfInterest = mosquitoDataRow[columnOfInterest];
                                        countyEntity.polygon.extrudedHeight = Math.floor((valueOfInterest / maxColumnValue) * ((extrusionFactor / 100) * 200000));
                                        var color = new Cesium.Color.fromBytes(
                                            255,
                                            255 - Math.floor((valueOfInterest/maxColumnValue) * 255),
                                            255 - Math.floor((valueOfInterest/maxColumnValue) * 255),
                                            Math.floor((dataOpacity/100) * 255)
                                        );
                                        countyEntity.polygon.material = color;
                                        
                                        var valueOfInterestLegendOffsetText = "";
                                        var valueOfInterestLegendOffsetValue = Math.round(((maxColumnValue - valueOfInterest) / maxColumnValue) * 298);
                                        if (!valueOfInterestLegendOffsetValue == 0) {
                                            valueOfInterestLegendOffsetText = '<div class="row" style="height:' + valueOfInterestLegendOffsetValue + 'px"><div class="col-xs-12"></div></div>';
                                        }

                                        countyEntity.description =
                                            '<h2 class="text-center">' + columnCountyName + ' County</h2>' +
                                            '<div class="row" style="margin-bottom:20px">'+
                                                '<div class="col-xs-6 text-right">' +
                                                    infoBoxMessage +
                                                '</div>' +
                                                '<div class="col-xs-6">' +
                                                    valueOfInterest +
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row">'+
                                                '<div class="col-xs-4 text-right" style="padding-right:0px">' +
                                                    '<div class="row" style="height:150px"><div class="col-xs-12">'+maxColumnValue + '&nbsp;&nbsp;&mdash;'+'</div></div>'+
                                                    '<div class="row" style="height:150px"><div class="col-xs-12"></div></div>'+
                                                    '<div class="row" style="height:22px"><div class="col-xs-12">'+minColumnValue + '&nbsp;&nbsp;&mdash;'+'</div></div>'+
                                                '</div>' +
                                                '<div class="col-xs-4" style="margin-top:12px">' +
                                                    '<div style="height:300px;background-image: linear-gradient(rgba(255,0,0,'+dataOpacity/100+'),rgba(255,255,255,'+dataOpacity/100+')">' +
                                                        
                                                    '</div>' +
                                                '</div>' +
                                                '<div class="col-xs-4" style="padding-left:0px">' +
                                                    valueOfInterestLegendOffsetText +
                                                    '<div class="row"><div class="col-xs-12"><span style="font-size:18px">&larr;</span>&nbsp;&nbsp;' + valueOfInterest +'</div></div>'+
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row" style="margin-top:20px">'+
                                                '<div class="col-xs-4 text-right">' +
                                                    infoBoxMessage +
                                                '</div>' +
                                                '<div class="col-xs-4 text-center">' +
                                                    'Intensity' +
                                                '</div>' +
                                                '<div class="col-xs-4 text-left">' +
                                                    columnCountyName +
                                                '</div>' +
                                            '</div>' 
                                            ;
                                        
                                        countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;
                                        countyEntity.polygon.shadows = Cesium.ShadowMode.CAST_ONLY;

                                        var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                                        //var countyCenter = Cesium.BoundingSphere.fromPoints(countyPolygonPositions).center;
                                        //countyEntity.position = countyCenter;

                                        var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                                        var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                                        var countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 10000);
                                        countyEntity.position = countyExtrusionHeightOffset;
                                        
                                        countyEntity.label = {
                                            show: chkShowLabels,
                                            text : valueOfInterest + '',
                                            font : '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                            fillColor : Cesium.Color.WHITE,
                                            outlineColor : Cesium.Color.BLACK,
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
                    
                    var heading = Cesium.Math.toRadians(0);
                    var pitch = Cesium.Math.toRadians(-90);
                    viewer.flyTo(countyGeoEntitiesValues, {
                        duration: 2.0,
                        offset: new Cesium.HeadingPitchRange(heading, pitch)
                    });
                    viewer.dataSources.add(countyDataSource);
                    globalRefCountyDataSource = countyDataSource;

                    
                    var date1 = new Date();
                    var time1 = date1.getTime();
                    //console.log("Retrieving the data took " + (time1 - time0) + " milliseconds.");

                }).otherwise(function(error){
                    //Display any errrors encountered while loading.
                    window.alert(error + " Univariate Extr");
                });
            }












            function renderPearsonCorrelationHeatmap(jsonString, mosquitoVarOfInterest, weatherVarOfInterest) {

                
                var jsonToRender = JSON.parse(jsonString);
                var btnHide = document.getElementById("btnHide");
                if (btnHide.innerHTML == "Show") {
                    btnHide.click();
                }

                var rdoCountyLowQual = document.getElementById("rdoCountyLowQual");
                var rdoCountyMedQual = document.getElementById("rdoCountyMedQual");
                var rdoCountyHighQual = document.getElementById("rdoCountyHighQual");
                if (viewer.dataSources.get(viewer.dataSources.indexOf(globalRefCountyDataSource))) {
                    viewer.dataSources.remove(globalRefCountyDataSource, false);
                }
                var infoBoxMessage = "Pearson's Coefficient";
                
                var countyGeoJson;
                if (rdoCountyLowQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_20m.json');
                } else if (rdoCountyMedQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_5m.json');
                } else if (rdoCountyHighQual.checked) {
                    countyGeoJson = Cesium.GeoJsonDataSource.load('/Scripts/GeoJSON/gz_2010_us_050_00_500k.json');
                }
                
                countyGeoJson.then(function (countyDataSource) {
                    
                    var chkAllStates = document.getElementById("chkAllStates").checked;
                    var ddlState = document.getElementById("ddlState");
                    var ddlOutlineColor = document.getElementById("ddlOutlineColor");
                    var chkShowLabels = document.getElementById("chkShowLabels").checked;
                    //var extrusionFactor = document.getElementById("valUniExtrExtrusionFactor").value;
                    //var dataOpacity = document.getElementById("valUniExtrDataOpacity").value;
                    
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
                    
                    var date0 = new Date();
                    var time0 = date0.getTime();
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

                            for (var j = 0; j < jsonToRender.length; j++){
                                
                                var dataRow = jsonToRender[j];
                                for (var key in dataRow){
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
                                            color = new Cesium.Color.fromBytes(
                                                0,
                                                0,
                                                255,
                                                Math.floor((valueOfInterest*-1) * 255)
                                            );
                                        } else if (valueOfInterest == 0) {
                                            color = new Cesium.Color.fromBytes(
                                                0,
                                                0,
                                                0,
                                                0
                                            );
                                        } else {
                                            color = new Cesium.Color.fromBytes(
                                                255,
                                                0,
                                                0,
                                                Math.floor((valueOfInterest) * 255)
                                            );
                                        }
                                        countyEntity.polygon.material = color;
                                        
                                        var valueOfInterestLegendOffsetText = "";
                                        var valueOfInterestLegendOffsetValue = Math.round(((1 - valueOfInterest) * 298)/2);
                                        if (!valueOfInterestLegendOffsetValue == 0) {
                                            valueOfInterestLegendOffsetText = '<div class="row" style="height:' + valueOfInterestLegendOffsetValue + 'px"><div class="col-xs-12"></div></div>';
                                        }

                                        countyEntity.description =
                                            '<h2 class="text-center">' + columnCountyName + ' County</h2>' +
                                            '<div class="row" style="margin-bottom:20px">'+
                                                '<div class="col-xs-6 text-right">' +
                                                    infoBoxMessage +
                                                '</div>' +
                                                '<div class="col-xs-6">' +
                                                    valueOfInterest +
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row">'+
                                                '<div class="col-xs-4 text-right" style="padding-right:0px">' +
                                                    '<div class="row" style="height:150px"><div class="col-xs-12">' + "1" + '&nbsp;&nbsp;&mdash;'+'</div></div>'+
                                                    '<div class="row" style="height:150px"><div class="col-xs-12"></div></div>'+
                                                    '<div class="row" style="height:22px"><div class="col-xs-12">'+ "-1" + '&nbsp;&nbsp;&mdash;'+'</div></div>'+
                                                '</div>' +
                                                '<div class="col-xs-4" style="margin-top:12px">' +
                                                    '<div style="height:300px;background-image: linear-gradient(rgba(255,0,0),rgba(0,0,0,0),rgba(0,0,255))">' +
                                                        
                                                    '</div>' +
                                                '</div>' +
                                                '<div class="col-xs-4" style="padding-left:0px">' +
                                                    valueOfInterestLegendOffsetText +
                                                    '<div class="row"><div class="col-xs-12"><span style="font-size:18px">&larr;</span>&nbsp;&nbsp;' + valueOfInterest +'</div></div>'+
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row" style="margin-top:20px">'+
                                                '<div class="col-xs-4 text-right">' +
                                                    infoBoxMessage +
                                                '</div>' +
                                                '<div class="col-xs-4 text-center">' +
                                                    'Correlation' +
                                                '</div>' +
                                                '<div class="col-xs-4 text-left">' +
                                                    columnCountyName +
                                                '</div>' +
                                            '</div>' 
                                            ;
                                        
                                        countyEntity.polygon.heightReference = Cesium.HeightReference.CLAMP_TO_GROUND;
                                        countyEntity.polygon.shadows = Cesium.ShadowMode.CAST_ONLY;

                                        var countyPolygonPositions = countyEntity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                                        //var countyCenter = Cesium.BoundingSphere.fromPoints(countyPolygonPositions).center;
                                        //countyEntity.position = countyCenter;

                                        var countyPolygonBoundingSphere = Cesium.BoundingSphere.fromPoints(countyPolygonPositions);
                                        var countyCartographicCenter = Cesium.Cartographic.fromCartesian(countyPolygonBoundingSphere.center);
                                        var countyExtrusionHeightOffset = Cesium.Cartesian3.fromRadians(countyCartographicCenter.longitude, countyCartographicCenter.latitude, countyEntity.polygon.extrudedHeight.getValue(Cesium.JulianDate.now()) + 4000);
                                        countyEntity.position = countyExtrusionHeightOffset;
                                        
                                        countyEntity.label = {
                                            show: chkShowLabels,
                                            text : valueOfInterest + '',
                                            font : '30px "Helvetiva Neue", Helvetica, Arial, sans-serif',
                                            fillColor : Cesium.Color.WHITE,
                                            outlineColor : Cesium.Color.BLACK,
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
                    
                    var heading = Cesium.Math.toRadians(0);
                    var pitch = Cesium.Math.toRadians(-90);
                    viewer.flyTo(countyGeoEntitiesValues, {
                        duration: 2.0,
                        offset: new Cesium.HeadingPitchRange(heading, pitch)
                    });
                    viewer.dataSources.add(countyDataSource);
                    globalRefCountyDataSource = countyDataSource;

                    
                    var date1 = new Date();
                    var time1 = date1.getTime();
                    //console.log("Retrieving the data took " + (time1 - time0) + " milliseconds.");

                }).otherwise(function(error){
                    //Display any errrors encountered while loading.
                    window.alert(error + " Pearson Heatmap");
                });
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
                        '<div class="row" style="margin-bottom:10px">'+
                            '<div class="col-xs-6 text-right">' +
                                    'County' +
                            '</div>' +
                            '<div class="col-xs-6">' +
                                    trapMarker.properties.County +
                            '</div>' +
                        '</div>' +
                        '<div class="row" style="margin-bottom:10px">'+
                            '<div class="col-xs-6 text-right">' +
                                    'Latitude' +
                            '</div>' +
                            '<div class="col-xs-6">' +
                                    trapLatitude +
                            '</div>' +
                        '</div>' +
                        '<div class="row" style="margin-bottom:10px">'+
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
                setTimeout(function () { caller.style.pointerEvents = "auto";}, 350);
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
        </script>
    </div>
</asp:Content>
