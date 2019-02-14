<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WNV.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <div class="row">
        <div class="col-lg-12">
            <h2>About the Website</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            This website is used to display the data that the North Dakota Department of Health has gathered on Mosquito populations across the state since 2002.
            On this page you can find history of the program and the statistical methods to show relationships between weather variables and the mosquito species in the state.
        </div>
    </div>
    <hr />
    <div class="row">
        <div class="col-lg-12">
            <h2>History</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
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
    </div>
    <hr />
    <div class="row">
        <div class="col-lg-12">
            <h2>Website Goals</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            This website has two primary objectives that it was designed to accomplish. The first objective is to display historical data of past years
            data. The second objective is to be able to use the data to predicate future population counts and determine if there are trends that can 
            pinpoint when the next outbreak of West Nile Virus will occur. The website in its current state is displaying mosquito trap and weather 
            data from 2005-2018. In order to display the data in meaningful ways we integrated an open-source JavaScript library called 
            <a href="https://cesiumjs.org/about/" target="_blank">CesiumJS</a> that allowed us to display the trap counts by county on an <a href="InteractiveGlobe.aspx" target="_blank">
            interactive 3D globe</a>. The globe uses <a href="https://en.wikipedia.org/wiki/Pearson_correlation_coefficient" target="_blank">Pearson Correlation Coefficent</a> 
            to determine if there is strong or weak relationship against certain weather variables in a short term period and a long term period. We also built a
            custom treemap that displays the breakdown of each species to the overall count against weather respectively. In addition to these tools on the website
            we have also built a report viewer tool which allows vistors to the site to be able to access certain raw data that is used for the site. 
            <br />
            <br />
            The website currently does not have any features that model or predict future counts as of February 2019.
        </div>
    </div>
    <hr />
    <div class="row">
        <div class="col-lg-12">
            <h2>How the Data was Collected</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-4">
            This website has two categories of data, mosquito numbers and weather data. To collect the mosquito data, every year between Memorial day and 
            Labor day, the North Dakota Department of Health sets up New Jersey Light Traps across the state. Each week, the traps are taken down and the 
            mosquitoes captured within the trap are collected and sent off to the state lab to be identified and counted. Once the mosquitos have been 
            sorted by gender and then by species, the numbers are published by the North Dakota Department of Health on their website. At the end of the
            year, the Department of Health publishes a yearly summery of the data from the statewide traps. The dependability of these traps is extremely
            important as they are the primary means of data collection regarding mosquito species.
        </div>
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-12 align-center">
                    <img src="./photos/trap-images/NJ-light-trap.jpg" class="img-fluid rounded" style="max-height: 400px;"/>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    A New Jersey Stainless Steel Light Trap similar to those used throughout ND.
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-12 align-center">
                    <img src="./photos/trap-images/NJ-trap-diagram.jpg" class="img-fluid rounded" style="max-height: 430px;"/>
                </div>
            </div>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-12 align-center">
                    <img src="./photos/weather-station-images/station.jpg" class="img-fluid rounded" style="max-height: 470px;"/>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    An NDAWN weather station located in Rugby, ND. 
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="row">
                <div class="col-lg-12 align-center">
                    <img src="./photos/weather-station-images/station-diagram.jpg" class="img-fluid rounded" style="max-height: 430px;"/>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            The weather data was gained from the North Dakota Argiculture Weather Network or NDAWN for short. The network started in 1989 and consists of 91 stations
            scattered throughout the state that record various weather factors such as temperature, rainfall, and wind speed and report these values 
            every 5 minutes. Each station within the network is meant to accurately reflect a radius of 20 miles around the station itself. The network 
            uses a program that fills in any missing data with approximations of the data using surrounding stations. Every Monday-Friday the data is 
            cross checked to ensure that the weather data is accurate and catch any mistakes that the computer program that fills in the missing data 
            can not catch itself. The same goes for weekly and monthly data to determine if any instruments need to be recalibrated or other problems.
            important as they are the primary means of data collection regarding mosquito species.
        </div>
    </div>
    <hr />
    <div class="row">
        <div class="col-lg-12">
            <h2>Federal Agencies and National Organizations</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            Below are links that will take you to pages that discuss prevention of mosquito bites.
        </div>
    </div>
    <br />
    <br />
    <div class="row">
        <div class="col-lg-5 align-center">
            <a href="https://www.cdc.gov/westnile/prevention/index.html?CDC_AA_refVal=https%3A%2F%2Fwww.cdc.gov%2Fwestnile%2Ffaq%2Frepellent.html" target="_blank"><img src="./photos/agencies-orgs-logos/m-cdc-logo.png" /></a>
        </div>
        <div class="col-lg-offset-onehalf">
            <br />
            <br />
        </div>
        <div class="col-lg-3 align-center">
            <a href="https://www.epa.gov/insect-repellents" target="_blank"><img src="./photos/agencies-orgs-logos/epa-logo.jpg" style="max-width: 250px; max-height: 250px;"/></a>
            <br />
            <br />
        </div>
        <div class="col-lg-3 align-center">
            <a href="http://npic.orst.edu/factsheets/DEETgen.pdf" target="_blank"><img src="./photos/agencies-orgs-logos/npic-logo-horiz-hi.png" style="max-height: 250px; max-width: 315px;"/></a>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-lg-6 align-center">
            <a href="https://www.mosquito.org/default.aspx"><img src="./photos/agencies-orgs-logos/amca-logo.png" style="max-width: 380px; max-height: 250px;" /></a>
            <br />
            <br />
        </div>
        <div class="col-lg-6 align-center">
            <a href="http://north-central-mosquito.org/WPSite/"><img src="./photos/agencies-orgs-logos/NCMCALogo.png" style="max-height: 380px; max-width: 250px;" /></a>
        </div>
    </div>
    <hr />
    <div class="row">
        <div class="col-lg-12">
            <h2>About the Development Team</h2>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            We are Computer Science undergraduate students at the University of North Dakota working with Dr. Prakash Ranganathan 
            in the College of Engineering &amp; Mines at the University of North Dakota. We strive to create innovative software to
            visualize data that provides useful results to researchers of West Nile Virus in the state of North Dakota. The goal behind
            our software is to aid in the development of a forecast model that can predict West Nile Virus incidences, which will allow 
            Mosquito Control services throughout North Dakota to optimize their use of resources in a timely and efficient manner.
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-lg-4 align-center">
            <h3>Aaron Johnson</h3>
            
        </div>
        <div class="col-lg-4 align-center">
            <h3>Alex Marquette</h3>
        </div>
        <div class="col-lg-4 align-center">
            <h3>Tyler Clark</h3>
        </div>
    </div>
    
</asp:Content>
