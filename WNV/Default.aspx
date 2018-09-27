<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WNV._Default" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Visualizations</h1>
        <p class="lead">Below are some visualizations representing data</p>
        <%-- <p><a href="http://www.asp.net" class="btn btn-primary btn-lg">Learn more &raquo;</a></p> --%>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>North Dakota Temperature Averages</h2>
            <p>
                <asp:Chart ID="Chart1" runat="server">
                    <Series>
                        <asp:Series Name="Series1" ChartType="Line"></asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </p>
            <p>
                <asp:DropDownList ID="yearDDL" CssClass="form-control" AutoPostBack="true" style="width:140px;" runat="server" OnSelectedIndexChanged="yearDDL_SelectedIndexChanged">
                </asp:DropDownList>
            </p>
            <asp:Label ID="weatherErrMsg" runat="server" Text=""></asp:Label>
        </div>
        <div class="col-md-4">
            <h2>Get more libraries</h2>
            <p>
                NuGet is a free Visual Studio extension that makes it easy to add, remove, and update libraries and tools in Visual Studio projects.
            </p>
            <p>
                <a class="btn btn-default" href="https://go.microsoft.com/fwlink/?LinkId=301949">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Web Hosting</h2>
            <p>
                You can easily find a web hosting company that offers the right mix of features and price for your applications.
            </p>
            <p>
                <a class="btn btn-default" href="https://go.microsoft.com/fwlink/?LinkId=301950">Learn more &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
