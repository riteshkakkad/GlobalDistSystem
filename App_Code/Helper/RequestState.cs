using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Net;
namespace Helper
{
    public class RequestState
    {
        public WebRequest Request; 
        public Object Data1;
        public Object Data2;
        public String SiteUrl; 
        

        public RequestState()
        {
           
        }
        public RequestState(WebRequest request, Object data1,Object data2, String siteUrl)
        {
            this.Request = request;
            this.Data1 = data1;
            this.Data2 = data2;
            this.SiteUrl = siteUrl;
        }

    }
}
