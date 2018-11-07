﻿<%@ Page Title="Tree Map" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TreeMap.aspx.cs" Inherits="WNV.TreeMap" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery.ui.treemap.js"></script>
    <asp:DropDownList ID="yearDDL" runat="server"></asp:DropDownList>

    <asp:HiddenField ID="hiddenVals" runat="server" />

    <div id="treemap"></div>
        <script type="text/javascript">
            $(document).ready(function () {
                var hv = $("#"+ '<%= hiddenVals.ClientID %>').val();
                var array = hv.split(',');
                console.log(array);
                $("#treemap").treemap({
                    "nodeData": {
                        "id":"2fc414e2", "children":[
                            {"id":"Aedes", "size":[array[0]], "color":[.74]},
                            {"id":"Aedes Vexans", "size":[array[1]], "color":[.98]},
                            {"id":"Anopheles", "size":[array[2]], "color":[.39]},
                            {"id":"Culex", "size":[array[3]], "color":[.19]},
                            {"id":"Culex Salinarius", "size":[array[4]], "color":[.52]},
                            {"id": "Culex Tarsalis", "size": [array[5]], "color": [.98] },
                            {"id": "Culiseta", "size": [array[6]], "color": [.98] },
                            {"id": "Other", "size": [array[7]], "color": [.98] }
                        ]
                    }
                });
            });
        </script>

    <asp:Label ID="errMsg" runat="server" Text=""></asp:Label>


</asp:Content>
