<%@ Page Title="Synchronized Charts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SynchronizedCharts.aspx.cs" Inherits="WNV.SynchronizedCharts1" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <div class="text-center mt-3">
        <h3>Synchronized Charts - North Dakota West Nile Virus Forecasting</h3>
    </div>
    <asp:HiddenField ID="hfTrapCountJSON" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfWeatherJSON" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hfCasesJSON" runat="server" ClientIDMode="Static" />
    <div class="jumbotron mb-1" style="padding:0px;background-color:white;width:1140px">
        <div class="row">
            <div class="col-lg-12">
                <h6>Mosquito Count</h6>
            </div>
        </div>
        <div id="chrtTrapCount"></div>
        <div class="row">
            <div class="col-lg-12">
                <h6>WNV Cases</h6>
            </div>
        </div>
        <div id="chrtCases"></div>
        <div class="row">
            <div class="col-lg-12">
                <h6>Weather</h6>
            </div>
        </div>
        <div id="chrtWeather"></div>
    </div>
    <div class="row">
        <div class="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Mosquito Species
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlMosquitoSpecies" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlMosquitoSpecies" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlMosquitoSpecies_SelectedIndexChanged">
                                        <asp:ListItem Text="All Species" Value="Species" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="All Males" Value="Males"></asp:ListItem>
                                        <asp:ListItem Text="All Females" Value="Females"></asp:ListItem>
                                        <asp:ListItem Text="Aedes" Value="Aedes" ></asp:ListItem>
                                        <asp:ListItem Text="Aedes Vexans" Value="Aedes Vexans" ></asp:ListItem>
                                        <asp:ListItem Text="Anopheles" Value="Anopheles" ></asp:ListItem>
                                        <asp:ListItem Text="Culex" Value="Culex" ></asp:ListItem>
                                        <asp:ListItem Text="Culex Salinarius" Value="Culex Salinarius" ></asp:ListItem>
                                        <asp:ListItem Text="Culex Tarsalis" Value="Culex Tarsalis" ></asp:ListItem>
                                        <asp:ListItem Text="Culiseta" Value="Culiseta" ></asp:ListItem>
                                        <asp:ListItem Text="Other Species" Value="Other" ></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvMosquitoSpecies" runat="server" Text="Mosquito Species is required." ForeColor="Red" Display="Static" ControlToValidate="ddlMosquitoSpecies" ValidationGroup="vgSynchronizedCharts" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <%-- Year DDL --%>
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                Trap Year
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel2" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlYear" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlYear" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvYear" runat="server" Text="Trap Year is required." ForeColor="Red" Display="Static" ControlToValidate="ddlYear" ValidationGroup="vgSynchronizedCharts" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                            </asp:UpdatePanel>
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
                                County
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlCounty" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlCounty" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlCounty_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvTrapCounty" runat="server" Text="Trap County is required." ForeColor="Red" Display="Static" ControlToValidate="ddlCounty" ValidationGroup="vgSynchronizedCharts" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                            </asp:UpdatePanel>
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
                                Weather Variable
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel4" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlWeather" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlWeather" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlWeather_SelectedIndexChanged">
                                        <asp:ListItem Text="Mean Temp (F&deg;)" Value="Avg Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Max Temp (F&deg;)" Value="Max Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Min Temp (F&deg;)" Value="Min Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Bare Soil Temp (F&deg;)" Value="Avg Bare Soil Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Turf Soil Temp (F&deg;)" Value="Avg Turf Soil Temp" ></asp:ListItem>
                                        <asp:ListItem Text="Dew Point (F&deg;)" Value="Avg Dew Point" ></asp:ListItem>
                                        <asp:ListItem Text="Wind Chill (F&deg;)" Value="Avg Wind Chill" ></asp:ListItem>
                                        <asp:ListItem Text="Mean Wind Speed (mph)" Value="Avg Wind Speed" ></asp:ListItem>
                                        <asp:ListItem Text="Max Wind Speed (mph)" Value="Max Wind Speed" ></asp:ListItem>
                                        <asp:ListItem Text="Solar Rad (W/m&sup2;)" Value="Total Solar Radiation" ></asp:ListItem>
                                        <asp:ListItem Text="Rainfall (in)" Value="Total Rainfall" ></asp:ListItem>
                                        <asp:ListItem Text="Mean Penman PET" Value="Avg Penman PET" ></asp:ListItem>
                                        <asp:ListItem Text="Total Penman PET" Value="Total Penman PET" ></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvWeather" runat="server" Text="Weather Variable is required." ForeColor="Red" Display="Static" ControlToValidate="ddlWeather" ValidationGroup="vgSynchronizedCharts" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-3">
            <div class="row aspnet-rfv-heightOffset-fix">
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="col-form-label align-right">
                                WNV Cases
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel5" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlWNVCases" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlWNVCases" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlWNVCases_SelectedIndexChanged">
                                        <asp:ListItem Text="All Cases" Value="All Cases" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Humans" Value="Human Cases"></asp:ListItem>
                                        <asp:ListItem Text="Avian" Value="Bird Cases"></asp:ListItem>
                                        <asp:ListItem Text="Equine" Value="Horse Cases" ></asp:ListItem>
                                        <asp:ListItem Text="Other" Value="Other Cases" ></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Text="Mosquito Species is required." ForeColor="Red" Display="Static" ControlToValidate="ddlMosquitoSpecies" ValidationGroup="vgSynchronizedCharts" EnableClientScript="true"></asp:RequiredFieldValidator>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <br />
        <div class="col-lg-4">
            <asp:Button ID="renderBtn" runat="server" Text="Render" CssClass="btn btn-success btn-lg btn-block aspnet-width-fix" ValidationGroup="vgSynchronizedCharts" OnClick="renderBtn_Click" />
        </div>
        <div class="col-lg-6">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>
   </div>
    <script>
        Apex = {
            "chart": {
                "height": '230px',
                "background": '#FDFDFD',
                animations: {
                    enabled: true,
                    easing: 'easeinout',
                    speed: 800,
                    animateGradually: {
                        enabled: true,
                        delay: 150
                    },
                    dynamicAnimation: {
                        enabled: true,
                        speed: 350
                    }
                }
            },
            "toolbar": {
                "tools": {
                    "selection": false
                }
            },
            "dataLabels": {
                "enabled": false
            },
            "stroke": {
                "curve": 'smooth'
            },
            "markers": {
                "size": 6,
                "hover": {
                    "size": 10
                }
            },
            "tooltip": {
                "followCursor": false,
                "theme": 'dark',
                "x": {
                    "show": false
                },
                "marker": {
                    "show": false
                },
                "y": {
                    "title": {
                        "formatter": function (d) {
                            return ''
                        }
                    }
                }
            },
            "grid": {
                "clipMarkers": false
            },
            "yaxis": {
                "tickAmount": 1
            },
            "xaxis": {
                "tickAmount": 1,
                "type": 'datetime'
            },
            dataLabels: {
                enabled: true,
                formatter: function (val, opts) {
                    return val
                },
                textAnchor: 'middle',
                offsetX: 0,
                offsetY: -5,
                style: {
                    fontSize: '14px',
                    fontFamily: 'Helvetica, Arial, sans-serif',
                    colors: undefined
                },
                dropShadow: {
                    enabled: false,
                    top: 1,
                    left: 1,
                    blur: 1,
                    opacity: 0.45
                }
            }
        };

        // Use these for now until JSON generation algorithm is working
        var chrtTrapCountOptions = {
            chart: {
                id: 'chrtTrapCountOptions',
                group: 'syncChartGroup',
                type: 'line',
            },
            "legend": {
                "show": true,
                "showForSingleSeries": true,
                "position": 'top',
            },
            colors: ['#00FF00'],
            series: [{
                name: 'Mosquito Variable',
                data: generateDayWiseTimeSeries(new Date('11 Feb 2017').getTime(), 20, {
                    min: 10,
                    max: 60
                })
            }],
            yaxis: {
                labels: {
                    minWidth: 40
                }
            }
        };
        var chrtWeatherOptions = {
            chart: {
                id: 'chrtWeatherOptions',
                group: 'syncChartGroup',
                type: 'line',
            },
            "legend": {
                "show": true,
                "showForSingleSeries": true,
                "position": 'top'
            },
            colors: ['#0000FF'],
            series: [{
                name: 'Weather Variable',
                data: generateDayWiseTimeSeries(new Date('11 Feb 2017').getTime(), 20, {
                    min: 10,
                    max: 60
                })
            }],
            yaxis: {
                labels: {
                    minWidth: 40
                }
            }
        };
        var chrtCasesOptions = {
            chart: {
                id: 'chrtCasesOptions',
                group: 'syncChartGroup',
                type: 'line',
            },
            "legend": {
                "show": true,
                "showForSingleSeries": true,
                "position": 'top'
            },
            colors: ['#FF0000'],
            series: [{
                name: 'West Nile Virus Cases',
                data: generateDayWiseTimeSeries(new Date('11 Feb 2017').getTime(), 20, {
                    min: 10,
                    max: 60
                })
            }],
            yaxis: {
                labels: {
                    minWidth: 40
                }
            }
        };

        // Use these once JSON generation algorithm is in place
        console.log('<%= hfCasesJSON.Value %>');
        var chrtTrapCount = new ApexCharts(document.querySelector("#chrtTrapCount"), JSON.parse('<%= hfTrapCountJSON.Value %>'));
        var chrtWeather = new ApexCharts(document.querySelector("#chrtWeather"), JSON.parse('<%= hfWeatherJSON.Value %>'));
        var chrtCases = new ApexCharts(document.querySelector("#chrtCases"), JSON.parse('<%= hfCasesJSON.Value %>'));
        
        //var chrtTrapCount = new ApexCharts(document.querySelector("#chrtTrapCount"), chrtTrapCountOptions);
        //var chrtWeather= new ApexCharts(document.querySelector("#chrtWeather"), chrtWeatherOptions);
        //var chrtCases = new ApexCharts(document.querySelector("#chrtCases"), chrtCasesOptions);

        chrtTrapCount.render();
        chrtWeather.render();
        chrtCases.render();

        // Temporary for data rendition before JSON generation
        function generateDayWiseTimeSeries(baseval, count, yrange) {
            var i = 0;
            var series = [];
            while (i < count) {
                var x = baseval;
                var y = Math.floor(Math.random() * (yrange.max - yrange.min + 1)) + yrange.min;

                series.push([x, y]);
                baseval += 86400000;
                i++;
            }
            return series;
        };
    </script>




</asp:Content>
