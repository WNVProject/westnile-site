<%@ Page Title="WNVF | Species" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MosquitoSpecies.aspx.cs" Inherits="WNV.MosquitoSpecies" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script>
        
    </script>

       
    <div class="jumbotron">
        <h1>Mosquito Species in North Dakota</h1>
    </div>

    <div id="results">
        <asp:Label runat="server" id="rslt" Text=""></asp:Label>
    </div>

    <div class="row">
        <div class="card-deck">
            <div class="col-md-3">
                <div class="card">
                    <img class="card-img-top" src="https://bugguide.net/images/cache/YRI/QCR/YRIQCR7Q9R90OQM03Q803Q80TQ3KDR7QQ0KQDR7QDRFK1RIQL0W0H07QTR903Q90JRXQYRXQORIQZ060DQHQBRJK.jpg" alt="Card image cap">
                    <div class="card-body">
                        <h5 class="card-title">Culex</h5>
                        <p class="card-text">Mosquito</p>
                    </div>
                </div>
            </div>
            <div class ="col-md-3">
                <div class="card">
                    <img class="card-img-top" src="http://www.co.galveston.tx.us/mosquito_control/salinarius.jpg" alt="Card image cap">
                    <div class="card-body">
                        <h5 class="card-title">Culex Salinarius</h5>
                        <p class="card-text">This card has supporting text below as a natural lead-in to additional content.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <img class="card-img-top" src="http://nathistoc.bio.uci.edu/diptera/DSCF0002b.jpg" alt="Card image cap">
                    <div class="card-body">
                        <h5 class="card-title">Culex Tarsalis</h5>
                        <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This card has even longer content than the first to show that equal height action.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

        <div class="row">
        <div class="card-deck">
          <div class="card">
            <img class="card-img-top" src="https://bugguide.net/images/raw/SHX/RCZ/SHXRCZSROZIRELJL1LMZAL7ZQH8RBLER0HSZDL6RFZSRHH4ROL4RLHIZWL7RJZERVLYL6LLZ3ZXR.jpg" alt="Card image cap">
            <div class="card-body">
              <h5 class="card-title">Culiseta</h5>
              <p class="card-text">This is a longer card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
            </div>
          </div>
          <div class="card">
            <img class="card-img-top" src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Anopheles_stephensi.jpeg/1200px-Anopheles_stephensi.jpeg" alt="Card image cap">
            <div class="card-body">
              <h5 class="card-title">Anopheles</h5>
              <p class="card-text">This card has supporting text below as a natural lead-in to additional content.</p>
            </div>
          </div>
          <div class="card">
            <img class="card-img-top" src="https://www.dailybreeze.com/wp-content/uploads/2018/08/0822_NWS_TDB-L-NEWMOSQUITO.1-1.jpg?w=521" alt="Card image cap">
            <div class="card-body">
              <h5 class="card-title">Aedes</h5>
              <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This card has even longer content than the first to show that equal height action.</p>
            </div>
          </div>
        </div>
    </div>

        <div class="row">
        <div class="card-deck">
          <div class="card">
            <img class="card-img-top" src="https://bugguide.net/images/cache/WRJ/KBR/WRJKBR3KFR70K020Z0E0L0E0K080JQ40YQX0URHQNR3KOQM0OQ3KTQ509RSQYRXQ3RSQYRSQYRW0YRMQJRN0JQRQ.jpg" alt="Card image cap">
            <div class="card-body">
              <h5 class="card-title">Aedes Vexans</h5>
              <p class="card-text">This is a longer card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
            </div>
          </div>
        </div>
    </div>
    

</asp:Content>
