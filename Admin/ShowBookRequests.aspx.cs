using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Specialized;
using BusinessLayer;

public partial class ShowBookRequests : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminMaster m = (AdminMaster)Page.Master;
        m.selectedtab = "bookrequests";
        if (Request.Params.Get("requestsearchbtn") != null)
        {
            NameValueCollection nvc = new NameValueCollection();
            String tempkey = null;
            String tempval = null;
            Boolean flag = true;
            for (int i = 0; i < Request.QueryString.Count; i++)
            {

                tempkey = Request.QueryString.GetKey(i);
                tempval = Request.QueryString.Get(i);

                if (tempkey != "requestsearchbtn")
                {

                    if (tempval != "all" && tempval != "")
                    {
                        flag = true;
                    }
                    else
                    {
                        flag = false;
                    }
                }
                else
                {
                    flag = false;
                }

                if (flag)
                {
                    nvc.Add(tempkey, tempval);
                }



            }
            nvc.Remove("pageid");

            if (AdminBO.Serialize(nvc) != "")
            {
                Response.Redirect("ShowBookRequests.aspx?" + AdminBO.Serialize(nvc));
            }
            else
            {
                Response.Redirect("ShowBookRequests.aspx");
            }
        }
    }
}
