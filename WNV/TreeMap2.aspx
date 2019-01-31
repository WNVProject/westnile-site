<%@ Page Title="Tree Map" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TreeMap2.aspx.cs" Inherits="WNV.TreeMap2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery.ui.treemap.js"></script>
    <script type="text/javascript" src="Scripts/colorbrewer.js"></script>
    <script src="//d3js.org/d3.v3.min.js"></script>
    
    <style>

        #treemap {
            height:750px;
        }

        #treemap.rect {
            fill: none;
            transition:filter ease 0.25s;
        }

        rect:hover {
            transition:filter ease 0.25s;
            filter: brightness(125%);
            cursor:pointer;
            stroke:#00FF66;
            stroke-width:2;
            z-index:1000;
        }
        
        .treemapArea {
          display: block;
          margin: auto;
        }

        text {
          font-weight:600;
          text-overflow:clip;
          white-space:pre;
          overflow:hidden;
          fill:white;
          pointer-events:none;
        }

        svg div {
          text-align: center;
          line-height: 150px;
        }

        .tooltip {
            pointer-events:none;
            opacity:0;
            transition: opacity 0.3s;
            padding:5px;
            box-shadow:0px 0px 3px #555;
        }

        div.tooltip {
            background: white;
            position: absolute;
            min-width: 26em;
            text-align:center;
            border-radius:5px;
            font-size: 18px;
            box-sizing:border-box !important;
            z-index:1003;
        }

        .tooltip.stationary {
            height: 12.5rem;
            margin-top:-.25rem;
            border-radius:0 0  .25rem .25rem;
            box-shadow: 0 1px 0 1px #ced4da;
            z-index:1002;
        }

        .category rect {
            fill:gray;
        }

    </style>
    <div class="text-center mt-3">
        <h3>Interactive Tree Map - North Dakota West Nile Virus Forecasting</h3>
    </div>
    <div class="jumbotron mb-1" style="padding:0px;background-color:white;">
        <div id="treemap">
        </div>
        <div class="mouse tooltip">
        </div>
    </div>
    <div class="row">
        <div class="col-lg-4">
            <div id="minValueLabel" class="align-left">
            </div>
        </div>
        <div class="col-lg-4">
            <div id="middleValueLabel" class="align-center">
            </div>
        </div>
        <div class="col-lg-4">
            <div id="maxValueLabel" class="align-right">
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-0">
            <div id="gradientDropdownToggle" class="form-control p-0" data-toggle="collapse" data-target="#pnlGradientDropdown" aria-expanded="false" aria-controls="pnlGradientDropdown" onclick="toggleDropdownCaret(this);">
                <span class="dropdown-caret mr-3 mt-3"></span>
                <%--<span style="padding-left:100px;font-size:1.5rem;font-family:sans-serif;">|</span>--%>
            </div>
        </div>
    </div>
    <div class="row w-100">
        <div class="col-lg-12">
            <div class="mouse tooltip stationary w-100">
            </div>
        </div>
    </div>
    <div class="row aspnet-rfv-heightOffset-fix">
        <div id="pnlGradientDropdown" class="col-lg-12 collapse">
            <div id="gradientDropdownContainer">
                <div id="gradientDropdown">
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="gradientDropdownValue" runat="server" EnableViewState="false" ClientIDMode="Static"/>
    <div class="row">  
        <div class ="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Location Type
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:DropDownList ID="ddlLocationType" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlLocationType_SelectedIndexChanged">
                                <asp:ListItem Text="Counties" Value="Counties" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Trap Locations" Value="TrapLocations"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>      
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Time Type
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:DropDownList ID="ddlTimeType" AutoPostBack="true" runat="server" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlTimeType_SelectedIndexChanged">
                                <asp:ListItem Text="Years" Value="Years" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Weeks" Value="Weeks"></asp:ListItem>
                                <asp:ListItem Text="Week of Summer" Value="Weeks"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                <label class="form-check-label" >Statewide</label>
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:CheckBox ID="chkStatewide" runat="server" AutoPostBack="true" OnCheckedChanged="chkStatewide_CheckedChanged"  />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Location
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                                    <asp:AsyncPostBackTrigger ControlID="ddlLocationType" />
                                </Triggers>
                                    <ContentTemplate>
                                    <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-control aspnet-width-fix" Width="100%">
                                        <asp:ListItem Text="Placeholder" Value="Counties" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Start Time
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:DropDownList ID="ddlYearStart" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                End Time
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:DropDownList ID="ddlYearEnd" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Size Represents
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlSizeRepresents" />
                                    <asp:AsyncPostBackTrigger ControlID="ddlColorRepresents" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlSizeRepresents" runat="server" CssClass="form-control aspnet-width-fix" Width="100%">
                                        <asp:ListItem Text="All Species" Value="Species" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Aedes" Value="Aedes" ></asp:ListItem>
                                        <asp:ListItem Text="Aedes Vexans" Value="Aedes Vexans" ></asp:ListItem>
                                        <asp:ListItem Text="Anopheles" Value="Anopheles" ></asp:ListItem>
                                        <asp:ListItem Text="Culex" Value="Culex" ></asp:ListItem>
                                        <asp:ListItem Text="Culex Salinarius" Value="Culex Salinarius" ></asp:ListItem>
                                        <asp:ListItem Text="Culex Tarsalis" Value="Culex Tarsalis" ></asp:ListItem>
                                        <asp:ListItem Text="Culiseta" Value="Culiseta" ></asp:ListItem>
                                        <asp:ListItem Text="Other Species" Value="Other" ></asp:ListItem>
                                        <asp:ListItem Text="Mean Temp (F&deg;)" Value="Mean Temp1" ></asp:ListItem>
                                        <asp:ListItem Text="Max Temp (F&deg;)" Value="Max Temp1" ></asp:ListItem>
                                        <asp:ListItem Text="Min Temp (F&deg;)" Value="Min Temp1" ></asp:ListItem>
                                        <asp:ListItem Text="Bare Soil Temp (F&deg;)" Value="Bare Soil Temp1" ></asp:ListItem>
                                        <asp:ListItem Text="Turf Soil Temp (F&deg;)" Value="Turf Soil Temp1" ></asp:ListItem>
                                        <asp:ListItem Text="Dew Point (F&deg;)" Value="Dew Point1" ></asp:ListItem>
                                        <asp:ListItem Text="Wind Chill (F&deg;)" Value="Wind Chill1" ></asp:ListItem>
                                        <asp:ListItem Text="Mean Wind Speed (mph)" Value="Mean Wind Speed1" ></asp:ListItem>
                                        <asp:ListItem Text="Max Wind Speed (mph)" Value="Max Wind Speed1" ></asp:ListItem>
                                        <asp:ListItem Text="Solar Rad (W/m&sup2;)" Value="Solar Rad1" ></asp:ListItem>
                                        <asp:ListItem Text="Rainfall (in)" Value="Rainfall" ></asp:ListItem>
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Color Represents
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel ID="upDdlColorRepresents" runat="server">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlSizeRepresents" />
                                    <asp:AsyncPostBackTrigger ControlID="ddlColorRepresents" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlColorRepresents" runat="server" CssClass="form-control aspnet-width-fix" Width="100%">
                                        <asp:ListItem Text="Species Count" Value="Species"></asp:ListItem>
                                        <asp:ListItem Text="Mean Temp (F&deg;)" Value="Mean Temp" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Max Temp (F&deg;)" Value="Max Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Min Temp (F&deg;)" Value="Min Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Bare Soil Temp (F&deg;)" Value="Bare Soil Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Turf Soil Temp (F&deg;)" Value="Turf Soil Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Dew Point (F&deg;)" Value="Dew Point" ></asp:ListItem>
                                        <asp:ListItem Text="Wind Chill (F&deg;)" Value="Wind Chill" ></asp:ListItem>
                                        <asp:ListItem Text="Mean Wind Speed (mph)" Value="Mean Wind Speed" ></asp:ListItem>
                                        <asp:ListItem Text="Max Wind Speed (mph)" Value="Max Wind Speed" ></asp:ListItem>
                                        <asp:ListItem Text="Solar Rad (W/m&sup2;)" Value="Solar Rad" ></asp:ListItem>
                                        <asp:ListItem Text="Rainfall (in)" Value="Rainfall" ></asp:ListItem>
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Background Color
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <select id="ddlBackgroundColor" class="form-control" onchange="changeBackgroundColor();">
                                <option value="white">White</option>
                                <option value="black">Black</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-7">
                    <div class="slideContainer">
                        <input id="rngLabelSize" class="form-control m-0 w-100" type="range" value="16" min="10" max="25" step="1" onmouseover="toggleTooltip('valLabelSize');" onmouseout="toggleTooltip('valLabelSize');" onmousemove="updateSlideOutputLive(this,'valLabelSize');valLabelSize.value=value;if(!this.disabled){changeLabelSize(value,'txtLabelSize')};"/>
                        <output id="valLabelSize" class="formTooltip-hide text-white p-1 m-0 w-100 text-center">16</output>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div id="txtLabelSize" class="col-form-label align-center">
                        Label Size
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-6">
                    <div class="form-check-inline">
                        <input id="chkShowLabels" type="checkbox" checked="checked" class="form-check-input" onchange="toggleLabels();" />
                        <label class="form-check-label" for="chkShowLabels">Show Labels</label>
                    </div>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-6">
                    <div class="form-check-inline">
                        <input id="chkShowTrackingTooltip" type="checkbox" checked="checked" class="form-check-input" onchange="toggleTrackingTooltip();" />
                        <label class="form-check-label" for="chkShowTrackingTooltip">Tracking Tooltip</label>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="form-check-inline">
                        <input id="chkShowStationaryTooltip" type="checkbox" checked="checked" class="form-check-input" onchange="toggleStationaryTooltip();" />
                        <label class="form-check-label" for="chkShowStationaryTooltip">Stationary Tooltip</label>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <br />
        <div class="col-lg-4">
            <asp:Button ID="renderBtn" runat="server" Text="Generate Tree Map" CssClass="btn btn-success btn-lg btn-block aspnet-width-fix" ValidationGroup="vgTreeMap" OnClick="renderBtn_Click" />
        </div>
        <div class="col-lg-4">
            <%--<asp:CheckBox ID="chkStatewide" runat="server" Text="&nbsp;Statewide Data" CssClass="checkbox" AutoPostBack="true" OnCheckedChanged="chkStatewide_CheckChanged"/>--%>
        </div>
        <div class="col-lg-4">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>

    <script>
        d3.json("/Scripts/TreeMapJSON/TreeMapData.json", function () { });
        var bckgrndImgSelector = "background-image: linear-gradient(90deg,";
        var gradientColorList = "";
        var zoomed = false;
        var treeMapWidth = document.getElementById("treemap").clientWidth,
            treeMapHeight = 750;
        var x = d3.scale.linear().range([0, treeMapWidth]),
            y = d3.scale.linear().range([0, treeMapHeight]),
            root,
            node,
            svg;

        function generateTreeMap(gradient, labelSize) {
            zoomed = false;
            treemap = d3.layout.treemap()
                .round(false)
                .size([treeMapWidth, treeMapHeight])
                .value(function (d) { return d.size; });
                //.mode("slice-dice");
        
            $("#gradientDropdown").children().addClass("noPointerEvents");

            var color = d3.scale.quantize()
                .range(colorbrewer[gradient][1]);
            var tooltip = d3.selectAll(".tooltip:not(.css)");
            var HTMLmouseTip = d3.select("div.mouse.tooltip");
            
            $.when($("#treemap").fadeOut("fast", function () {
                document.getElementById("treemap").innerHTML = "";
            })).done(function () {
                svg = d3.select("#treemap").append("div")
                    .attr("class", "treemapArea")
                    .style("width", treeMapWidth)
                    .style("height", treeMapHeight)
                  .append("svg:svg")
                    .attr("width", treeMapWidth)
                    .attr("height", treeMapHeight)
                    .attr("style", "background-color:"+$("#ddlBackgroundColor").val())
                  .append("svg:g")
                    .attr("transform", "translate(.5,.5)");
        
                d3.json("/Scripts/TreeMapJSON/TreeMapData.json", function (data) {
                    //console.log(data);
                    node = root = data;

                    var categories = treemap.nodes(root).filter(function(d) {
                        return d.children;
                    });
                    //console.log(categories);

                    //var parents = svg.selectAll("g").data(categories).enter()
                    //    .append("svg:g")
                    //    .attr("class", "category")
                    //    .append("svg:rect")
                    //    .attr("width", function (d) {
                    //        return d.dx - 1;
                    //    })
                    //    .attr("height", "0.5rem");
                    
                      var nodes = treemap.nodes(root)
                          .filter(function(d) {return !d.children; });
                      
                      var cell = svg.selectAll("g")
                          .data(nodes)
                        .enter()
                          .append("svg:g")
                          .attr("class", "cell")
                          .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
                          .on("click", function(d) { return zoom(node == d.parent ? root : d.parent); });
                    //console.log(cell);
                    color.domain([data.min, data.max]);
                    var middle = ((data.max - data.min) / 2) + Number(data.min);
                    document.getElementById("minValueLabel").innerHTML = data.min
                    document.getElementById("middleValueLabel").innerHTML = String(Math.round(Number(middle) * 1000) / 1000)
                    document.getElementById("maxValueLabel").innerHTML = data.max + data.colorUnit;

                    cell.append("svg:rect")
                        .attr("width", function (d) {if(d.parent.dx) d.xRatioToParent = d.dx / d.parent.dx; return d.dx - 1; })
                        .attr("height", function (d) {if(d.parent.dy) d.yRatioToParent = d.dy / d.parent.dy; return d.dy - 1; })
                        .style("fill", function (d) {
                            if (d.name != "Culex Tarsalis") {
                                return color(d.colorValue);
                            } else {
                                return color(d.colorValue);
                                //return "#F00";
                            }
                        })
                          .on("mouseover", function (d) {
                              tooltip.style("opacity", "1");
                              tooltip.style("border", function () {
                                  if (d.name != "Culex Tarsalis") {
                                      return "9px solid " + color(d.colorValue);
                                  } else {
                                      return "9px solid " + color(d.colorValue);
                                      //return "7px solid #F00";
                                  }
                              });
                              tooltip.style("color", this.getAttribute("fill"));
                              tooltip.html(
                                  "<div class='row'>" +
                                  "<div class='col-lg-12 align-center'>" +
                                  "<h4>" + d.parent.name + "</h4>" +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-12 align-center'>" +
                                  "<h5>" + d.name + "</h5>" +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-6 align-right'>" +
                                  d.sizeUnit + ": " +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  d.size +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-6 align-right'>" +
                                  d.colorUnit + ": " +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  d.colorValue +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-6 align-right'>" +
                                  "% of this "+ d.category + ": " +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  Math.round((d.size/d.parent.value * 100) * 100)/100 + "%" +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-6 align-right'>" +
                                  "% of "+ d.categoryPlural + ": " +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  Math.round((d.size/d.parent.parent.value * 100) * 100)/100 + "%" +
                                  "</div>" +
                                  "</div>");
                          })
                          .on("mousemove", function () {
                
                                HTMLmouseTip
                                    .style("left", Math.max(0, d3.event.pageX + 30) + "px")
                                    .style("top", (d3.event.pageY - 30) + "px");
                          })
                          .on("mouseout", function () {
                                return tooltip.style("opacity", "0");
                          })
            
                    cell.append("svg:text")
                        .attr("x", function (d) { return d.dx / 2; })
                        .attr("y", function (d) { return d.dy / 2; })
                        .attr("dy", ".35em")
                        .attr("text-anchor", "middle")
                        .text(function (d) { return d.name; })
                        .style("font-size", labelSize + "px")
                        .style("opacity", function (d) {
                            d.labelWidth = this.getComputedTextLength();
                            d.labelHeight = this.getBBox().height;
                            return d.dx > d.labelWidth && d.dy > d.labelHeight ? 1 : 0;
                        })
                        .style("fill", function (d) {
                            var rectColor = hexToRgb(color(d.colorValue));
                            var brightness = (0.2126 * rectColor.r) + (0.7152 * rectColor.g) + (0.0722 * rectColor.b);
                            if (brightness >= 127.5) {
                                return "#000";
                            } else {
                                return "#FFF";
                                //return "#F00";
                            }
                        })
                        .style("display", function () {
                            if ($("#chkShowLabels").is(":checked")) {
                                return "inline-block";
                            } else {
                                return "none";
                            }
                        });
                      d3.select(document.getElementById("treemap")).on("click", function() { zoom(root); });

                      //d3.select("select").on("change", function() {
                      //  //treemap.value(this.value == "size" ? size : count).nodes(root);
                      //  treemap.value((this.value == "total") ? total : (this.value == "building") ? building : (this.value == "ground") ? ground : cash).nodes(root);
                      //  zoom(node);
                      //});
                });
                $("#treemap").fadeIn("fast", function () { });
                setTimeout(function () { $("#gradientDropdown").children().removeClass("noPointerEvents"); }, 500);
            });

        }

        $("#gradientDropdown").ready(function () {
            var gradientSelectHTML = "";
            for (var gradientName in colorbrewer) {
                if (colorbrewer.hasOwnProperty(gradientName)) {
                    var gradientOptions = colorbrewer[gradientName];
                    //console.log(gradientName);
                    gradientSelectHTML += "<div class='gradientDropdown-item' id='" + gradientName + "' onclick='changeGradient(\""+gradientName+"\",$(\"#valLabelSize\").val())' style='"+bckgrndImgSelector;
                    for (var gradientResolution in gradientOptions) {
                        if (gradientOptions.hasOwnProperty(gradientResolution)) {
                            //console.log(gradientResolution + " -> " + gradientOptions[gradientResolution]);
                            var gradientColors = gradientOptions[gradientResolution];
                            for (var i = 0; i < gradientColors.length; i++) {
                                gradientSelectHTML += gradientColors[i] + ",";
                                gradientColorList += gradientColors[i] + ",";
                            }
                            gradientSelectHTML = gradientSelectHTML.slice(0, -1) + ");height:calc(2.25rem + 2px);' />";
                            gradientColorList = gradientColorList.slice(0, -1) + ");";
                        }
                    }
                }
            }
            $("#gradientDropdown").append(gradientSelectHTML);
        });

        function updateGradientDropdownToggleBackground(gradient) {
            gradientColorList = "";
            var gradientOptions = colorbrewer[gradient];
            for (var gradientResolution in gradientOptions) {
                if (gradientOptions.hasOwnProperty(gradientResolution)) {
                    var gradientColors = gradientOptions[gradientResolution];
                    for (var i = 0; i < gradientColors.length; i++) {
                        gradientColorList += gradientColors[i] + ",";
                        //console.log(gradientColors[i] + ",");
                    }
                    gradientColorList = gradientColorList.slice(0, -1) + ");";
                }
            }
            $("#gradientDropdownToggle").removeAttr('style');
            $("#gradientDropdownToggle").attr("style",bckgrndImgSelector+gradientColorList);
        }

        function setActiveGradient(gradient) {
            $(".gradientDropdown-active").removeClass("gradientDropdown-active");
            $("#" + gradient).addClass("gradientDropdown-active");
            document.getElementById(gradient).classList.add("gradientDropdown-active");
        }

        function changeGradient(gradient,labelSize) {
            document.getElementById("gradientDropdownValue").value = gradient;
            generateTreeMap(gradient,labelSize);
            setActiveGradient(gradient);
            updateGradientDropdownToggleBackground(gradient);
        }

        function size(d) {
          return d.size;
        }

        function total(d) {
          return d.total;
        }

        function building(d) {
          return d.building;
        }

        function ground(d) {
          return d.ground;
        }

        function cash(d) {
          return d.cash;
        }

        function count(d) {
          return 1;
        }

        function zoom(d) {
            if (zoomed) {
                zoomed = false;
            } else {
                zoomed = true;
            }

          var kx = treeMapWidth / d.dx, ky = treeMapHeight / d.dy;
          x.domain([d.x, d.x + d.dx]);
          y.domain([d.y, d.y + d.dy]);

          
          var t = svg.selectAll("g.cell").transition()
              .duration(d3.event.altKey ? 7500 : 750)
              .attr("transform", function(d) { return "translate(" + x(d.x) + "," + y(d.y) + ")"; });

          t.select("rect")
              .attr("width", function (d) { return kx * d.dx - 1; })
              .attr("height", function (d) { return ky * d.dy - 1; })

          t.select("text")
              .attr("x", function(d) { return kx * d.dx / 2; })
              .attr("y", function(d) { return ky * d.dy / 2; })
              .style("opacity", function(d) { return kx * d.dx > d.labelWidth && ky * d.dy > d.labelHeight ? 1 : 0; });

          node = d;
          d3.event.stopPropagation();
        }

        function hexToRgb(hex) {
            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
                r: parseInt(result[1], 16),
                g: parseInt(result[2], 16),
                b: parseInt(result[3], 16)
            } : null;
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
        function changeLabelSize(pixelSize,ctrlID) {
            var ctrl = document.getElementById(ctrlID);
            ctrl.style.fontSize = pixelSize + 'px';
            $("text").css("font-size",pixelSize + 'px');
            svg.selectAll("g.cell").selectAll("text").style("opacity", function (d) {
                if (zoomed) {
                    d.labelWidth = this.getComputedTextLength();
                    d.labelHeight = this.getBBox().height;
                    return d.xRatioToParent * treeMapWidth > d.labelWidth && d.yRatioToParent * treeMapHeight > d.labelHeight ? 1 : 0;
                } else {
                    d.labelWidth = this.getComputedTextLength();
                    d.labelHeight = this.getBBox().height;
                    return d.dx > d.labelWidth && d.dy > d.labelHeight ? 1 : 0;
                }
            });
        }
        function toggleTooltip(ctrlID) {
            var ctrl = document.getElementById(ctrlID);
            if (ctrl.classList.contains("formTooltip-hide")) {
                ctrl.classList.replace("formTooltip-hide", "formTooltip-show");
            } else if (ctrl.classList.contains("formTooltip-show")) {
                ctrl.classList.replace("formTooltip-show", "formTooltip-hide");
            }
        }
        function updateSlideOutputLive(ctrlInput,ctrlOutputID) {
            var ctrlOutputID = document.getElementById(ctrlOutputID);
            ctrlOutputID.innerText = ctrlInput.value;
        }
        function toggleLabels() {
            $("text").toggle("slow", function () { });
            if ($("#rngLabelSize").is(":disabled")) {
                $("#rngLabelSize").prop("disabled", false);
                $("#txtLabelSize").css("color","black");
            } else {
                $("#rngLabelSize").prop("disabled", true);
                $("#txtLabelSize").css("color","lightgrey");
            }
        }
        function toggleTrackingTooltip() {
            $("div.mouse.tooltip:not(.stationary)").toggle();
        }
        function toggleStationaryTooltip() {
            $("div.mouse.tooltip.stationary").toggle();
        }
        function changeBackgroundColor() {
            $(".treemapArea svg:first-child").attr("style", "background-color:" + $("#ddlBackgroundColor").val());
        }
        generateTreeMap('<%= gradientDropdownValue.Value %>', $("#valLabelSize").val());
        updateGradientDropdownToggleBackground('<%= gradientDropdownValue.Value %>');
        setActiveGradient('<%= gradientDropdownValue.Value %>');

    </script>
</asp:Content>
