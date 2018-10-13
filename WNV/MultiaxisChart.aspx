<%@ Page Title="WNVF | Multivariate Trends by County" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MultiaxisChart.aspx.cs" Inherits="WNV._MultiaxisChart" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .chart {
            width:100% !important;
            height:750px !important;
        }
    </style>
    <asp:HiddenField ID="chartWidth" runat="server" Value="" />
    <asp:HiddenField ID="chartHeight" runat="server" Value="" />
    <asp:Button ID="btnRedraw" runat="server" Visible="false" />
    <div class="text-center">
        <h3>Multivariate Trends - North Dakota West Nile Virus Forecasting</h3>
    </div>
    <div class="jumbotron" style="padding:10px;">
        <div class="text-center">
            <asp:UpdatePanel runat="server" ID="upnlMultiaxisChart" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnRender" />
                </Triggers>
                <ContentTemplate>
                    <asp:Chart ID="chrtMultivariate" runat="server" CssClass="col-lg-12 form-control chart" Width="1000px" Height="750px"></asp:Chart>
                <asp:Label ID="weatherErrMsg" runat="server" Text=""></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <script type="text/javascript">
        (function () {
            var upnlChart = document.getElementById('<%= upnlMultiaxisChart.ClientID %>');
            var upnlWidth = document.getElementById('<%= chartWidth.ClientID %>');
            var upnlHeight = document.getElementById('<%= chartHeight.ClientID %>');
            var initialWidth = upnlChart.offsetWidth;
            var initialHeight = upnlChart.offsetHeight;

            function getChangeRatio(val1, val2) {
                return Math.abs(val2 - val1) / val1;
            };

            function redrawChart() {
                setTimeout(function () {
                    initialWidth = upnlChart.offsetWidth;
                    initialHeight = upnlChart.offsetHeight;
                    document.getElementById('<%= btnRedraw.ClientID %>').click();
                }, 0);
            };

            function savePanelSize() {
                var isFirstDisplay = upnlWidth.value == '';
                upnlWidth.value = upnlChart.offsetWidth;
                upnlHeight.value = upnlChart.offsetHeight;
                var widthChange = getChangeRatio(initialWidth, upnlChart.offsetWidth);
                var heightChange = getChangeRatio(initialHeight, upnlChart.offsetHeight);
                if (isFirstDisplay || widthChange > 0.2 || heightChange > 0.2) {
                    redrawChart();
                }
            };

            savePanelSize();
            window.addEventListener('resize', savePanelSize, false);
        })();
    </script>
    <div class="row">
        <div class="col-lg-6">
            <h4>Mean Weather Variables</h4>
        </div>
        <div class="col-lg-6">
            <h4>Mean Mosquito Count Variables</h4>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <asp:CheckBox ID="chkMeanTemp" runat="server" CssClass="checkbox" Text="Temp (F&deg;)" />
            <asp:CheckBox ID="chkMeanMaxTemp" runat="server" CssClass="checkbox" Text="Max Temp (F&deg;)" />
            <asp:CheckBox ID="chkMeanMinTemp" runat="server" CssClass="checkbox" Text="Min Temp (F&deg;)" />
            <asp:CheckBox ID="chkMeanBareSoilTemp" runat="server" CssClass="checkbox" Text="Bare Soil Temp (F&deg;)" />
        </div>
        <div class="col-lg-2">
            <asp:CheckBox ID="chkMeanTurfSoilTemp" runat="server" CssClass="checkbox" Text="Turf Soil Temp (F&deg;)" />
            <asp:CheckBox ID="chkMeanWindChill" runat="server" CssClass="checkbox" Text="Wind Chill (F&deg;)" />
            <asp:CheckBox ID="chkMeanWindSpeed" runat="server" CssClass="checkbox" Text="Wind Speed (mph)" />
            <asp:CheckBox ID="chkMeanMaxWindSpeed" runat="server" CssClass="checkbox" Text="Max Wind Speed (mph)" />
        </div>
        <div class="col-lg-2">
            <asp:CheckBox ID="chkMeanDewPoint" runat="server" CssClass="checkbox" Text="Dew Point (F&deg;)" />
            <asp:CheckBox ID="chkMeanTotalRainfall" runat="server" CssClass="checkbox" Text="Total Rainfall (in)" />
            <asp:CheckBox ID="chkMeanTotalSolarRad" runat="server" CssClass="checkbox" Text="Total Solar Rad. (W/m<sup>2</sup>)" />
        </div>
        <div class="col-lg-2">
            <asp:CheckBox ID="chkMeanTotalMosquitoes" runat="server" CssClass="checkbox" Text="Total Mosquitoes" />
            <asp:CheckBox ID="chkMeanTotalMales" runat="server" CssClass="checkbox" Text="Total Males" />
            <asp:CheckBox ID="chkMeanTotalFemales" runat="server" CssClass="checkbox" Text="Total Females" />
            <asp:CheckBox ID="chkMeanOther" runat="server" CssClass="checkbox" Text="Other" />
        </div>
        <div class="col-lg-2">
            <asp:CheckBox ID="chkMeanAedes" runat="server" CssClass="checkbox" Text="Aedes" />
            <asp:CheckBox ID="chkMeanAedesVexans" runat="server" CssClass="checkbox" Text="Aedes Vexans" />
            <asp:CheckBox ID="chkMeanAnopheles" runat="server" CssClass="checkbox" Text="Anopheles" />
            <asp:CheckBox ID="chkMeanCulex" runat="server" CssClass="checkbox" Text="Culex" />
        </div>
        <div class="col-lg-2">
            <asp:CheckBox ID="chkMeanCulexSalinarius" runat="server" CssClass="checkbox" Text="Culex Salinarius" />
            <asp:CheckBox ID="chkMeanCulexTarsalis" runat="server" CssClass="checkbox" Text="Culex Tarsalis" />
            <asp:CheckBox ID="chkMeanCuliseta" runat="server" CssClass="checkbox" Text="Culiseta" />
        </div>
    </div>
    <div class="row">
        <asp:UpdatePanel runat="server" ID="upnlDropdowns" UpdateMode="Conditional">
            <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlYear" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
            </Triggers>
            <ContentTemplate>
                <div class="col-lg-3">
                    <h4>County</h4>
                    <asp:DropDownList ID="ddlCounty" runat="server" CssClass="form-control" Width="100%"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCounty" runat="server" Text="County is required." ForeColor="Red" Display="Static" ControlToValidate="ddlCounty" ValidationGroup="vgMultiaxisChart"></asp:RequiredFieldValidator>
                </div>
                <div class="col-lg-3">
                    <h4>Year</h4>
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control" Width="100%" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvYear" runat="server" Text="Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYear" ValidationGroup="vgMultiaxisChart"></asp:RequiredFieldValidator>
                </div>
                <div class="col-lg-3">
                    <h4>Start Date</h4>
                    <asp:DropDownList ID="ddlWeekStart" runat="server" CssClass="form-control" Width="100%" DataTextFormatString="{0:MMMM d, yyyy}"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" Text="Start Date is required." ForeColor="Red" Display="Static" ControlToValidate="ddlWeekStart" ValidationGroup="vgMultiaxisChart"></asp:RequiredFieldValidator>
                </div>
                <div class="col-lg-3">
                    <h4>End Date</h4>
                    <asp:DropDownList ID="ddlWeekEnd" runat="server" CssClass="form-control" Width="100%" DataTextFormatString="{0:MMMM d, yyyy}"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" Text="End Date is required." ForeColor="Red" Display="Static" ControlToValidate="ddlWeekEnd" ValidationGroup="vgMultiaxisChart"></asp:RequiredFieldValidator>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="row">
        <br />
        <div class="col-lg-3">
            <asp:Button ID="btnRender" runat="server" Text="Render Graph" CssClass="btn btn-success btn-lg btn-block" ValidationGroup="vgMultiaxisChart" OnClick="btnRender_Click"/>
        </div>
        <div class="col-lg-3">
            <asp:CheckBox ID="chkStatewide" runat="server" Text="Statewide Data" CssClass="checkbox" AutoPostBack="true" OnCheckedChanged="chkStatewide_CheckChanged" />
        </div>
        <div class="col-lg-6">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>
</asp:Content>
