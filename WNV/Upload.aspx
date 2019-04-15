<%@ Page Title="WNV | Upload" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Upload.aspx.cs" Inherits="WNV.Upload" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <br />
        <div class="row">
            <asp:FileUpload ID="FileUpload1"  CssClass="button"  runat="server" />  
            <asp:Button ID="btnImport" CssClass="button" runat="server" Text="Import" OnClick="ImportCSV" />  
        </div>

</asp:Content>
