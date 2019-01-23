﻿<%@ Page Title="Tree Map" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TreeMap2.aspx.cs" Inherits="WNV.TreeMap2" %>

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
            min-width: 17em;
            text-align:center;
            border-radius:5px;
            font-size: 18px;
            box-sizing:border-box !important;
        }

        .tooltip.stationary {
            height: 12.5rem;
            margin-top:-.25rem;
            border-radius:0 0  .25rem .25rem;
            box-shadow: 0 1px 0 1px #ced4da;
        }

    </style>
    <asp:HiddenField ID="selectedGradient" runat="server" Value="YlGn" />
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
    <asp:HiddenField ID="gradientDropdownValue" Visible="false" runat="server" Value="YlGn" />
    <div class="row">
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-12">
                    <asp:UpdatePanel runat="server" ID="upnlDropdowns" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                            <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-lg-5">
                                    <div class="col-form-label align-right">
                                        <span class="required">*</span>Trap Location
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 align-right">
                                    <asp:RequiredFieldValidator ID="rfvLocation" runat="server" Text="Trap Location is required." ForeColor="Red" Display="Static" ControlToValidate="ddlLocation" ValidationGroup="vgTreeMap" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                            <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-lg-5">
                                    <div class="col-form-label align-right">
                                        <span class="required">*</span>Start Year
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <asp:DropDownList ID="ddlYearStart" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 align-right">
                                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" Text="Start Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYearStart" ValidationGroup="vgTreeMap" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                            <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-lg-5">
                                    <div class="col-form-label align-right">
                                        <span class="required">*</span>End Year
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <asp:DropDownList ID="ddlYearEnd" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 align-right">
                                    <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" Text="End Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYearEnd" ValidationGroup="vgTreeMap" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                            <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-lg-5">
                                    <div class="col-form-label align-right">
                                        <span class="required">*</span>Categorize By
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control aspnet-width-fix" Width="100%">
                                        <asp:ListItem Text="Trap Location" Value="0" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="County" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Species" Value="2"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 align-right">
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Text="Category is required." ForeColor="Red" Display="Static" ControlToValidate="ddlLocation" ValidationGroup="vgTreeMap" EnableClientScript="true"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel4" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                            <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-lg-5">
                                    <div class="col-form-label align-right">
                                        <span class="required">*</span>
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 align-right">
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Text=" is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYearStart" ValidationGroup="vgTreeMap" EnableClientScript="true"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <asp:UpdatePanel runat="server" ID="UpdatePanel5" UpdateMode="Conditional">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                            <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="row">
                                <div class="col-lg-5">
                                    <div class="col-form-label align-right">
                                        <span class="required">*</span>
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <asp:DropDownList ID="DropDownList3" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 align-right">
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Text=" is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYearEnd" ValidationGroup="vgTreeMap" EnableClientScript="true"></asp:RequiredFieldValidator>--%>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
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
                <div class="col-lg-6">
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
            <asp:CheckBox ID="chkStatewide" runat="server" Text="&nbsp;Statewide Data" CssClass="checkbox" AutoPostBack="true" OnCheckedChanged="chkStatewide_CheckChanged"/>
        </div>
        <div class="col-lg-4">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>

    <script>
        d3.json("/Scripts/TreeMapJSON/TreeMapData.json", function () { });
        console.log("start()");
        var bckgrndImgSelector = "background-image: linear-gradient(90deg,";
        var gradientColorList = "";
        var activeGradient = '<%= gradientDropdownValue.Value %>';
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
            console.log("generateTreeMap()");

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
                    console.log(data);
                    node = root = data;
                
                      var nodes = treemap.nodes(root)
                          .filter(function(d) {return !d.children; });

                      var cell = svg.selectAll("g")
                          .data(nodes)
                        .enter().append("svg:g")
                          .attr("class", "cell")
                          .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
                          .on("click", function(d) { return zoom(node == d.parent ? root : d.parent); });

                    color.domain([data.min, data.max]);

                    document.getElementById("minValueLabel").innerHTML = data.min;
                    document.getElementById("middleValueLabel").innerHTML = Math.round((data.max / 2) * 100) / 100;
                    document.getElementById("maxValueLabel").innerHTML = data.max;

                    cell.append("svg:rect")
                        .attr("width", function (d) {if(d.parent.dx) d.xRatioToParent = d.dx / d.parent.dx; return d.dx - 1; })
                        .attr("height", function (d) {if(d.parent.dy) d.yRatioToParent = d.dy / d.parent.dy; return d.dy - 1; })
                        .style("fill", function (d) {
                            if (d.name != "Culex Tarsalis") {
                                return color(d.size);
                            } else {
                                return color(d.size);
                                //return "#F00";
                            }
                        })
                          .on("mouseover", function (d) {
                              tooltip.style("opacity", "1");
                              tooltip.style("border", function () {
                                  if (d.name != "Culex Tarsalis") {
                                      return "7px solid " + color(d.size);
                                  } else {
                                      return "7px solid " + color(d.size);
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
                                  "Count: " +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  d.size +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-6 align-right'>" +
                                  "% of Total: " +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  Math.round((d.size/d.parent.parent.value * 100) * 100)/100 + "%" +
                                  "</div>" +
                                  "</div>" +
                                  "<div class='row'>" +
                                  "<div class='col-lg-6 align-right'>" +
                                  "% of this Trap:" +
                                  "</div>" +
                                  "<div class='col-lg-6 align-left'>" +
                                  Math.round((d.size/d.parent.value * 100) * 100)/100 + "%" +
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
                            var rectColor = hexToRgb(color(d.size));
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
                    console.log(gradientName);
                    gradientSelectHTML += "<div class='gradientDropdown-item' id='" + gradientName + "' onclick='changeGradient(\""+gradientName+"\",$(\"#valLabelSize\").val())' style='"+bckgrndImgSelector;
                    for (var gradientResolution in gradientOptions) {
                        if (gradientOptions.hasOwnProperty(gradientResolution)) {
                            console.log(gradientResolution + " -> " + gradientOptions[gradientResolution]);
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
                        console.log(gradientColors[i] + ",");
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
            console.log("changeGradient()");
            activeGradient = gradient;
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
