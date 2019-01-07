<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WNV.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="about-greeting">
    <h2>About the website</h2>
    <br />
    <p>This website is used to display the data that the North Dakota Department of Health has gathered on Mosquito populations across the state since 2002.
        On this page you can find history of the program, the statistical methods to show relationships between weather variables and the specie of mosquitoes that are in the state.
    </p>
    </div>
    <ul class="About-list">
        <li>
            <a href="#History">History of the program</a>
        </li>
        <li>
            <a href="#Statistical-Methods">Statistical Methods</a>
        </li>
        <li>
            <a href="#Traps">Types Traps of Used</a>
        </li>
    </ul>
    <hr />
    <div class="History-Class"> 
        <a id="History"></a>
        <h2>History</h2>
        <p>
            Starting in 1975 following the outbreak the arboviral diseases
            of the Western Equine Encephalitis (WEE) and St. Louis Encephalitis(SLE), 
            the North Dakota Department of Health has been monitoring the mosquito 
            populations of various mosquito species. 
           
            In 1977, the program was renamed the <i>North Dakota Arboviral Encephalitis Surveillance Program</i>
            and was housed with the Division of Environmental Sanitation and Food Protection and was
            responsible for quine and human arbovirus surveillance until 1989. 

            In 2000 the program was reinstated as a response to the 1999 West Nile Virus (WNV) outbreak in New York. 
            The program discovered its first confrimed human case of WNV in 2002. In the same year the virus was able
            to be detected through lab testing in birds, horses and mosquitoes. In the following years the program was
            expanded from 50 to 87 New Jersey traps in additional to 18 Center for Disease Control (CDC) miniature light 
            traps. At it's peak collection in 2005 the program used a total of 103 New Jersery traps and 39 CDC miniature 
            light mosquito traps. This is was enough traps to have 2 traps for every county in the state at the time. 
            
            Over the next ten years the New Jersey traps were used each year running essentially unchanged, with varying numbers
            of New Jersey Light traps being used each year. However, during the same period the live trapping portion of the program 
            was done only when seasonal weather conditions and funding were avaialble for the program.  


    </div>
    <hr />
    <br />
    <div class="Stat-method class">
        <a id="Statistical-Methods"></a>
        <h2>Statistical Methods Used</h2>
        <p>Placeholder</p>
        <hr />
        <div class="Pearson">
            <h3>Pearson's Correlation</h3>
            <p>pearson placeholder</p>
        </div>
        <br />
    </div>
    <hr />
    <br />
    <div class="Traps">
        <a id="Traps"></a>
        <h2>Traps used for mosquito collection</h2>
        <hr />
        <div class=" NJLT">
            <h3>New Jersey Light Trap</h3>
            <br />
            <p>The New Jersey Light Trap is one of the original mosquito traps 
                that was developed in the 1930's in response to disease outbreaks. 
                To this day it reamins among the most productive and efficient traps 
                available for mosquito trap population count.
                <br />
                <img src="https://johnwhock.com/wp-content/uploads/2012/10/11122.jpg" alt="A New Jersey Stainless Steel Light Trap" style="width:250px; height:250px;"/>
            </p>
        </div>
    </div>
</asp:Content>
