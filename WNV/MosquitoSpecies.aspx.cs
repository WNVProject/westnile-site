using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using Newtonsoft.Json;

namespace WNV
{
    
    public class pageval
    {
        public int pageid { get; set; }
        public int ns { get; set; }
        public string title { get; set; }
        public string extract { get; set; }
    }


    public class Query
    {
        public Dictionary<string, pageval> pages { get; set; }
    }

    public class Limits
    {
        public int extracts { get; set; }
    }

    public class RootObject
    {
        public string batchcomplete { get; set; }
        public Query query { get; set; }
        public Limits limits { get; set; }
    }

    public partial class MosquitoSpecies : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            using (WebClient wc = new WebClient())
            {
                var client = new WebClient();
                var response = client.DownloadString("https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exsentences=1&exintro&titles=Culex&redirects=");
                var responseJson = JsonConvert.DeserializeObject<RootObject>(response);
                var firstKey = responseJson.query.pages.First().Key;
                var extract = responseJson.query.pages[firstKey].extract;

                rslt.Text = extract;
            }
        }
    }
}