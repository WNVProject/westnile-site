<%@ Page Title="Tree Map" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TreeMap2.aspx.cs" Inherits="WNV.TreeMap2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery.ui.treemap.js"></script>
    <script src="//d3js.org/d3.v3.min.js"></script>
    
    <style>

        rect {
          fill: none;
            transition:filter ease 0.25s;
        }

        rect:hover {
            transition:filter ease 0.25s;
            filter: brightness(120%);
            cursor:pointer;
        }
        
        .chart {
          display: block;
          margin: auto;
        }

        text {
          font-size: 10px;
          font-weight:600;
          text-overflow:clip;
          white-space:pre;
          overflow:hidden;
          fill:black;
          pointer-events:none;
        }

        svg div {
          text-align: center;
          line-height: 150px;
        }

        .tooltip {
            pointer-events:none; /*let mouse events pass through*/
            opacity:0;
            transition: opacity 0.3s;
            transition-delay: 0.2s;
            padding:5px;
            box-shadow:0px 0px 3px #555;
        }

        div.tooltip {
            background: white;
            position: absolute;
            max-width: 20em;
            text-align:center;
            border-radius:5px;
          font-size: 18px;
        }
    </style>

    <div class="text-center mt-3">
        <h3>Interactive Tree Map - North Dakota West Nile Virus Forecasting</h3>
    </div>
    <div class="jumbotron" style="padding:0px;background-color:white;">
        <div id="treemap">
        </div>
        <div id="universalTooltip" class="mouse tooltip">Test Tooltip!</div>
    </div>

    <script>
        var treeMapWidth = document.getElementById("treemap").clientWidth,
            treeMapHeight = 750,
            x = d3.scale.linear().range([0, treeMapWidth]),
            y = d3.scale.linear().range([0, treeMapHeight]),
            color = d3.scale.category20c(),
            root,
            node;

        var treemap = d3.layout.treemap()
            .round(false)
            .size([treeMapWidth, treeMapHeight])
            .value(function (d) { return d.size; });
            //.mode("slice-dice");

        var tooltip = d3.selectAll(".tooltip:not(.css)");
        var HTMLmouseTip = d3.select("div.mouse.tooltip");

        var svg = d3.select("#treemap").append("div")
            .attr("class", "chart")
            .style("width", treeMapWidth)
            .style("height", treeMapHeight)
          .append("svg:svg")
            .attr("width", treeMapWidth)
            .attr("height", treeMapHeight)
          .append("svg:g")
            .attr("transform", "translate(.5,.5)");
        
        d3.json("/Scripts/TreeMapJSON/TreeMapData.json", function (data) {

            node = root = data;
            console.log(data);

              var nodes = treemap.nodes(root)
                  .filter(function(d) {return !d.children; });

              var cell = svg.selectAll("g")
                  .data(nodes)
                .enter().append("svg:g")
                  .attr("class", "cell")
                  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
                  .on("click", function(d) { return zoom(node == d.parent ? root : d.parent); });

            cell.append("svg:rect")
                .attr("width", function (d) { return d.dx - 1; })
                .attr("height", function (d) { return d.dy - 1; })
                .style("fill", function (d) { return color(d.parent.name); })
                  .on("mouseover", function (d) {
                      tooltip.style("opacity", "1");
                      tooltip.style("border", "7px solid " + color(d.parent.name));
                      tooltip.style("color", this.getAttribute("fill"));
                      tooltip.text(d.parent.name + ": " +d.name + " - " + d.size);
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
                  .attr("x", function(d) { return d.dx / 2; })
                  .attr("y", function(d) { return d.dy / 2; })
                  .attr("dy", ".35em")
                  .attr("text-anchor", "middle")
                  .text(function(d) { return d.name; })
                  .style("opacity", function(d) { d.treeMapWidth = this.getComputedTextLength(); return d.dx > d.treeMapWidth ? 1 : 0; });
            
              d3.select(window).on("click", function() { zoom(root); });

              //d3.select("select").on("change", function() {
              //  //treemap.value(this.value == "size" ? size : count).nodes(root);
              //  treemap.value((this.value == "total") ? total : (this.value == "building") ? building : (this.value == "ground") ? ground : cash).nodes(root);
              //  zoom(node);
              //});
        });

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
          var fontsEnlarged = false;
          var kx = treeMapWidth / d.dx, ky = treeMapHeight / d.dy;
          x.domain([d.x, d.x + d.dx]);
          y.domain([d.y, d.y + d.dy]);

          
          var t = svg.selectAll("g.cell").transition()
              .duration(d3.event.altKey ? 7500 : 750)
              .attr("transform", function(d) { return "translate(" + x(d.x) + "," + y(d.y) + ")"; });

          t.select("rect")
              .attr("width", function(d) { return kx * d.dx - 1; })
              .attr("height", function(d) { return ky * d.dy - 1; })

          t.select("text")
              .attr("x", function(d) { return kx * d.dx / 2; })
              .attr("y", function(d) { return ky * d.dy / 2; })
              .style("opacity", function(d) { return kx * d.dx > d.treeMapWidth ? 1 : 0; });

          node = d;
          d3.event.stopPropagation();
        }

            


//{
//  "name": "Mosquito Species",
//    "children": [
//      {
//        "name": "Aedes",
//        "size": 50
//      },
//      {
//        "name": "Aedes Vexans",
//        "size": 50
//      },
//      {
//        "name": "Anopheles",
//        "size": 50
//      },
//      {
//        "name": "Culex",
//        "size": 50
//      },
//      {
//        "name": "Culex Salinarius",
//        "size": 50
//      },
//      {
//        "name": "Culex Tarsalis",
//        "size": 50
//      },
//      {
//        "name": "Culiseta",
//        "size": 50
//      },
//      {
//        "name": "Other",
//        "size": 50
//      }
//    ]
//}


    </script>
    
    <div class="row">
        <div class="col-lg-4">
            <asp:UpdatePanel runat="server" ID="upnlDropdowns" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>Trap Location</h4>
                    <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvLocation" runat="server" Text="Trap Location is required." ForeColor="Red" Display="Static" ControlToValidate="ddlLocation" ValidationGroup="vgTreeMap"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="col-lg-4">
            <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>Start Year</h4>
                    <asp:DropDownList ID="ddlYearStart" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" Text="Start Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYearStart" ValidationGroup="vgTreeMap"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="col-lg-4">
            <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlLocation" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>End Year</h4>
                    <asp:DropDownList ID="ddlYearEnd" runat="server" CssClass="form-control aspnet-width-fix" Width="100%"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" Text="End Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYearEnd" ValidationGroup="vgTreeMap"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="row">
        <br />
        <div class="col-lg-4">
            <asp:Button ID="renderBtn" runat="server" Text="Generate Tree Map" CssClass="btn btn-success btn-lg btn-block aspnet-width-fix" ValidationGroup="vgTreeMap" OnClick="renderBtn_Click"/>
        </div>
        <div class="col-lg-4">
            <asp:CheckBox ID="chkStatewide" runat="server" Text="&nbsp;Statewide Data" CssClass="checkbox" AutoPostBack="true" OnCheckedChanged="chkStatewide_CheckChanged"/>
        </div>
        <div class="col-lg-4">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>


</asp:Content>
