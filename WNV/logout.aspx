<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="logout.aspx.cs" Inherits="WNV.logout" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   
    
    <div class="container py-4">
        <div class="col-md-5 offset-md-4">
            <div class="card border-secondary rounded">
                <div class="card-header bg-light rounded">
                    <asp:Label ID="Label2" CSSclass="form-group justify-content-center align-content-center" Text="Logging Out Please Wait" runat="server" />
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick">
                            </asp:Timer>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
