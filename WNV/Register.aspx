<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WNV.Register" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <br />
    <br />
<div class="container py-4">
        <div class="col-md-5 offset-md-4">
            <div class="card border-secondary rounded">
                <div class="card-header bg-light rounded">
                    <h4 class="text-center text-uppercase text-black">Register</h4>
                </div>
                <div class="card-body">
                    <div class="col-12"></div>
                    <div class="col offset-sm-1">
                        <div class="form-group justify-content-center align-content-center">
                            
                            Email: <asp:TextBox ID="emailTxt" class="form-control" runat="server" placeholder="johndoe@email.com"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmailtxt" runat="server" forecolor="Red" controlToValidate="emailTxt" ErrorMessage="Please enter an email address" />
                            <asp:RegularExpressionValidator ID="revEmailText" runat="server" controlToValidate="emailTxt" CssClass="text-danger" ErrorMessage="Enter a valid email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"/>  
                        </div>
                        <div class="form-group justify-content-center">
                            Password:
                            <asp:TextBox ID="passwordTxt" class="form-control" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPasswordtxt" runat="server" forecolor="Red" controlToValidate="passwordTxt" ErrorMessage="Please enter a password" />
                        </div>
                         <div class="form-group justify-content-center">
                            Retype Password:
                            <asp:TextBox ID="confirmPasswordTxt" class="form-control" runat="server" TextMode="Password" placeholder="Retype Password"></asp:TextBox>
                            <asp:CompareValidator ID="cvConfirmPasswordTxt" runat="server" ControlToValidate="confirmPasswordTxt" CssClass="ValidationError" ForeColor="Red" ControlToCompare="passwordTxt" ErrorMessage="Passwords do not Match" ToolTip="Password must be the same" />
                           
                        </div>
                        <div class="form-group justify-content-center align-content-center">
                            <asp:Button ID="loginButton" runat="server" Text="Register" class="btn btn-lg btn-success btn-block" OnClick="userRegister"/>
                        </div>
                    </div>

                    <div class="col"></div>
                    <div class="form-group text-center">
                       
                        <asp:HyperLink ID="alreadyMember" NavigateUrl="Login.aspx" CssClass ="text-primary btn-link col-2" runat="server">Already have an account?</asp:HyperLink>
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
