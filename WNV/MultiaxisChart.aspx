<%@ Page Title="WNV | Multivariate Trends by County" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MultiaxisChart.aspx.cs" Inherits="WNV._MultiaxisChart" %>

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
    <div class="text-center mt-3">
        <h3>Multivariate Trends - North Dakota West Nile Virus Forecasting</h3>
    </div>
    <div class="jumbotron" style="padding:10px;">
        <div class="text-center">
            <asp:UpdatePanel runat="server" ID="upnlMultiaxisChart" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnRender" />
                </Triggers>
                <ContentTemplate>
                    <asp:Chart ID="chrtMultivariate" runat="server" CssClass="col-lg-12 form-control chart" Width="1000px" Height="750px">
                        <Titles>
                            <asp:Title Name="WNVChartTitle" Alignment="BottomCenter"></asp:Title>
                        </Titles>
                    </asp:Chart>
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
        <div class="col-lg-4">
            <h4>Mean Weather Variables</h4>
        </div>
        <div class="col-lg-2">
            <input id="chkSplineWeather" runat="server" class="form-check-input" type="checkbox" />
            <label class="form-check-label" for="<%= chkSplineWeather.ClientID %>">Use Splines</label>
        </div>
        <div class="col-lg-4">
            <h4>Mean Mosquito Count Variables</h4>
        </div>
        <div class="col-lg-2">
            <input id="chkSplineCount" runat="server" class="form-check-input" type="checkbox" />
            <label class="form-check-label" for="<%= chkSplineCount.ClientID %>">Use Splines</label>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <div class="form-check">
                <input id="chkMeanTemp" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTemp.ClientID %>">Mean Temp (F&deg;)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanMaxTemp" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanMaxTemp.ClientID %>">Max Temp (F&deg;)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanMinTemp" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanMinTemp.ClientID %>">Min Temp (F&deg;)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanBareSoilTemp" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanBareSoilTemp.ClientID %>">Bare Soil Temp (F&deg;)</label>
            </div>
        </div>
        <div class="col-lg-2">
            <div class="form-check">
                <input id="chkMeanTurfSoilTemp" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTurfSoilTemp.ClientID %>">Turf Soil Temp (F&deg;)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanWindChill" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanWindChill.ClientID %>">Wind Chill (F&deg;)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanWindSpeed" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanWindSpeed.ClientID %>">Wind Speed (mph)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanMaxWindSpeed" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanMaxWindSpeed.ClientID %>">Max Wind Speed (mph)</label>
            </div>
        </div>
        <div class="col-lg-2">
            <div class="form-check">
                <input id="chkMeanDewPoint" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanDewPoint.ClientID %>">Dew Point (F&deg;)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanTotalRainfall" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTotalRainfall.ClientID %>">Total Rainfall (in)</label>
            </div>
            <div class="form-check">
                <input id="chkMeanTotalSolarRad" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTotalSolarRad.ClientID %>">Total Solar Rad. (W/m<sup>2</sup>)</label>
            </div>
        </div>
        <div class="col-lg-2">
            <div class="form-check">
                <input id="chkMeanTotalMosquitoes" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTotalMosquitoes.ClientID %>">Total Mosquitoes</label>
            </div>
            <div class="form-check">
                <input id="chkMeanTotalMales" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTotalMales.ClientID %>">Total Males</label>
            </div>
            <div class="form-check">
                <input id="chkMeanTotalFemales" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanTotalFemales.ClientID %>">Total Females</label>
            </div>
            <div class="form-check">
                <input id="chkMeanOther" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanOther.ClientID %>">Other</label>
            </div>
        </div>
        <div class="col-lg-2">
            <div class="form-check">
                <input id="chkMeanAedes" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanAedes.ClientID %>">Aedes</label>
            </div>
            <div class="form-check">
                <input id="chkMeanAedesVexans" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanAedesVexans.ClientID %>">Aedes Vexans</label>
            </div>
            <div class="form-check">
                <input id="chkMeanAnopheles" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanAnopheles.ClientID %>">Anopheles</label>
            </div>
            <div class="form-check">
                <input id="chkMeanCulex" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanCulex.ClientID %>">Culex</label>
            </div>
        </div>
        <div class="col-lg-2">
            <div class="form-check">
                <input id="chkMeanCulexSalinarius" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanCulexSalinarius.ClientID %>">Culex Salinarius</label>
            </div>
            <div class="form-check">
                <input id="chkMeanCulexTarsalis" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanCulexTarsalis.ClientID %>">Culex Tarsalis</label>
            </div>
            <div class="form-check">
                <input id="chkMeanCuliseta" runat="server" class="form-check-input" type="checkbox" />
                <label class="form-check-label" for="<%= chkMeanCuliseta.ClientID %>">Culiseta</label>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-3">
            <asp:UpdatePanel runat="server" ID="upnlDropdowns" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlYear" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>County</h4>
                    <asp:DropDownList ID="ddlCounty" runat="server" CssClass="form-control" Width="100%"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCounty" runat="server" Text="County is required." ForeColor="Red" Display="Static" ControlToValidate="ddlCounty" ValidationGroup="vgMultiaxisChart" EnableClientScript="true"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="col-lg-3">
            <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlYear" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>Year</h4>
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control" Width="100%" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvYear" runat="server" Text="Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYear" ValidationGroup="vgMultiaxisChart" EnableClientScript="true"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="col-lg-3">
            <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlYear" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>Start Date</h4>
                    <asp:DropDownList ID="ddlWeekStart" runat="server" CssClass="form-control" Width="100%" DataTextFormatString="{0:MMMM d, yyyy}"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" Text="Start Date is required." ForeColor="Red" Display="Static" ControlToValidate="ddlWeekStart" ValidationGroup="vgMultiaxisChart" EnableClientScript="true"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="col-lg-3">
            <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="ddlYear" />
                    <asp:AsyncPostBackTrigger ControlID="chkStatewide" />
                </Triggers>
                <ContentTemplate>
                    <h4>End Date</h4>
                    <asp:DropDownList ID="ddlWeekEnd" runat="server" CssClass="form-control" Width="100%" DataTextFormatString="{0:MMMM d, yyyy}"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" Text="End Date is required." ForeColor="Red" Display="Static" ControlToValidate="ddlWeekEnd" ValidationGroup="vgMultiaxisChart"></asp:RequiredFieldValidator>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="row">
        <br />
        <div class="col-lg-3">
            <asp:Button ID="btnRender" runat="server" Text="Render Graph" CssClass="btn btn-success btn-lg btn-block" ValidationGroup="vgMultiaxisChart" OnClick="btnRender_Click"/>
        </div>
        <div class="col-lg-3">
            <asp:CheckBox ID="chkStatewide" runat="server" Text="&nbsp;Statewide Data" CssClass="checkbox" AutoPostBack="true" OnCheckedChanged="chkStatewide_CheckChanged" />
        </div>
        <div class="col-lg-6">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </div>
</asp:Content>
