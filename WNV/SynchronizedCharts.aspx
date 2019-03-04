﻿<%@ Page Title="Synchronized Charts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SynchronizedCharts.aspx.cs" Inherits="WNV.SynchronizedCharts1" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

     <div class="text-center mt-3">
        <h3>Synchronized Charts - North Dakota West Nile Virus Forecasting</h3>
    </div>
    <div class="jumbotron mb-1" style="padding:0px;background-color:white;height:750px;width:1140px">
        <div id="chart1"></div>
        <div id="chart2"></div>
        <div id="chart3"></div>
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
                                Trap County
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <asp:UpdatePanel runat="server" ID="UpdatePanel3" UpdateMode="Conditional">
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="ddlTrapCounty" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlTrapCounty" runat="server" AutoPostBack="true" CssClass="form-control aspnet-width-fix" Width="100%" OnSelectedIndexChanged="ddlTrapCounty_SelectedIndexChanged"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvTrapCounty" runat="server" Text="Trap County is required." ForeColor="Red" Display="Static" ControlToValidate="ddlTrapCounty" ValidationGroup="vgSynchronizedCharts" EnableClientScript="true"></asp:RequiredFieldValidator>
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
                                        <asp:ListItem Text="Rainfall (in)" Value="Rainfall1" ></asp:ListItem>
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
                                        <asp:ListItem Text="Humans" Value="Humans"></asp:ListItem>
                                        <asp:ListItem Text="Avian" Value="Avain"></asp:ListItem>
                                        <asp:ListItem Text="Equine" Value="Equine" ></asp:ListItem>
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





</asp:Content>
