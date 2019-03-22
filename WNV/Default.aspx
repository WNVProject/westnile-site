<%@ Page Title="WNV | Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WNV._Default" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
    <div class="jumbotron">
        <div id="Welcome-Banner">
            <h1 id="Welcome-Header">
                Welcome
            </h1>
            <p id="Welcome-Paragraph">
                This is a site that visualizes mosquito trap counts and tracking from data provided by the
                North Dakota Department of Health. 
            </p>
        </div>
        
        <!--
        <div id="map" style="width:1000px;height:600px;">
                <script src="/Scripts/Map2.js" type="text/javascript"></script>
                <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBymYK85pOpWP-KShxoECrUQd_0kG3X3CE&callback=initMap">
    </script>
            </div>-->
    </div>
    
    
</asp:Content>
