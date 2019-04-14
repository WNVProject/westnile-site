<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WNV.Login" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
    <div class="container py-4">
        <div class="col-md-5 offset-md-4">
            <div class="card border-secondary rounded">
                <div class="card-header bg-light rounded">
                    <h4 class="text-center text-uppercase text-black">Login</h4>
                </div>
                <div class="card-body">
                    <div class="col"></div>
                    <div class="col offset-sm-1">
                        <div class="form-group justify-content-center align-content-center">
                            <label for="emailTxt" class="sr-only"></label>
                            <asp:TextBox ID="emailTxt" class="form-control" runat="server" placeholder="johndoe@email.com"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmailtxt" runat="server" forecolor="Red" controlToValidate="emailTxt" ErrorMessage="Please enter an email address" />
                            <asp:RegularExpressionValidator ID="revEmailText" runat="server" controlToValidate="emailTxt" CssClass="text-danger" ErrorMessage="Enter a valid email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"/>  
                        </div>
                        <div class="form-group justify-content-center">
                            <label for="passwordTxt" class="sr-only"></label>
                            <asp:TextBox ID="passwordTxt" class="form-control" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPasswordtxt" runat="server" forecolor="Red" controlToValidate="passwordTxt" ErrorMessage="Please enter a password" />
                        </div>
                        <div class="form-group justify-content-center align-content-center">
                            <asp:Button ID="loginButton" runat="server" Text="Login" class="btn btn-lg btn-success btn-block" OnClick="userLogin"/>
                        </div>
                    </div>

                    <div class="col">
                        
                    </div>
                    <div class="form-group text-center">
                        <asp:HyperLink ID="newUserRegistration" NavigateUrl="~/Register.aspx" CssClass="text-primary btn-link" runat="server">New User</asp:HyperLink>
                        <asp:HyperLink ID="ForgotPassword" NavigateUrl="ForgetPassword.aspx" CssClass ="text-primary btn-link col-2" runat="server">Forgot Password?</asp:HyperLink>
                    </div>
                    
                </div>
                
            </div>
        </div>

        <div id="dvMessage" runat="server" visible="false" class="alert alert-danger">
            <strong>Error!</strong>
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </div>

        <div id="dbError" runat="server" Visible="false" class="alert alert-danager" role="alert">
            <asp:Label ID="lblDBError" runat="server" forecolor="red" Font-Bold="true"></asp:Label>
        </div>
    </div>

    
</asp:Content>
