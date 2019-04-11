<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WNV.Login" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <div class="wrapper">
        <div class="row">
            <label for="email" class="sr-only"></label>
            <asp:TextBox ID="emailTxt" class="form-control" runat="server" placeholder="Your Email"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmailtxt" runat="server" controlToValidate="emailTxt" ErrorMessage="Please enter an email address" />
        </div>
        <br />
        <div class="row">
            <label for="password" class="sr-only"></label>
            <asp:TextBox ID="passwordTxt" class="form-control" runat="server" TextMode="Password" placeholder="Your Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPasswordtxt" runat="server" controlToValidate="passwordTxt" ErrorMessage="Please enter a password" />
        </div>
    
        <br />
        <div class="row">
                <asp:Button ID="loginButton" runat="server" Text="Render User" class="btn btn-lg btn-success btn-block" />
        </div>
    </div>
    
</asp:Content>
