<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WNV._Default" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>West Nile Virus Visualizations</h1>
        <p class="lead">Below are some visualizations representing data</p>
        <%-- <p><a href="http://www.asp.net" class="btn btn-primary btn-lg">Learn more &raquo;</a></p> --%>
    </div>
    
    <div class="row">

        <%-- Average Temperatures --%>
        <asp:UpdatePanel runat="server" ID="upnlNDTemps" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="yearDDL" />
            </Triggers>
            <ContentTemplate>
                <div class="col-xs-4">
                    <h2>North Dakota Temperatures</h2>
                    <asp:DropDownList ID="yearDDL" CssClass="form-control" AutoPostBack="true" style="width:140px;" runat="server" OnSelectedIndexChanged="yearDDL_SelectedIndexChanged"></asp:DropDownList>
            
                    <p>
                        <asp:Chart ID="Chart1" runat="server">
                            <Series>
                                <asp:Series Name="Series1" ToolTip="Month: #VALX, Temp:#VALY" BorderWidth=6 ChartType="Line"></asp:Series>
                            </Series>
                            <ChartAreas>
                                <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                            </ChartAreas>
                        </asp:Chart>
                    </p>
                    <asp:Label ID="weatherErrMsg" runat="server" Text=""></asp:Label>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <%-- Grand Forks Mosquitos --%>
        <div class="col-md-5">
            <h2>Grand Forks Mosquito Data</h2>
            <p>
                <asp:Chart ID="Chart2" runat="server">
                    <Series>
                        <asp:Series Name="Series1" BorderWidth=6 ToolTip="Year: #VALX, WNV Cases:#VALY" ChartType="Line"></asp:Series>
                        <asp:Series Name="Series2"  ToolTip="Year: #VALX, Total Mosquitoes:#VALY" ChartType="Column"></asp:Series>
                        <asp:Series Name="Series3" ToolTip="Year: #VALX, Total Culex Tarsalis:#VALY" ChartType="Column"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </p>
            <asp:Label ID="gfErrMsg" runat="server" Text=""></asp:Label>
        </div>

        <%-- WNV Cases --%>
        <div class="col-md-4">
            <h2>WNV Cases</h2>
            <p>
                <asp:Chart ID="Chart3" runat="server" BorderlineWidth="10">
                    <Series>
                        <asp:Series Name="Series1" ToolTip="Year: #VALX, Humans:#VALY" BorderWidth=6 ChartType="Line"></asp:Series>
                        <asp:Series Name="Series2" ToolTip="Year: #VALX, Birds:#VALY" BorderWidth=6 ChartType="Line"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </p>
            <asp:Label ID="caseErrMsg" runat="server" Text=""></asp:Label>
        </div>
    </div>

</asp:Content>
