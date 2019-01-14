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
using Entities;
using DataAccessLayer;

using System.Collections.Generic;

using System.IO;
using BusinessLayer;
using System.Text;
using Iesi.Collections;
using Newtonsoft.Json;
public partial class Operators_Test : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        BookRequest b = BookRequestDAO.FindBookRequestByID((long)28);
        Response.Write(GetBidJson(b,OperatorBO.GetLoggedinOperator()));
       
    }
    public String GetBidJson(BookRequest b, Operator op)
    {
        String resp = "";
        IList<OperatorBid> bidlist = BookRequestDAO.GetBidsForRequest(b);
        ListSet opbids = new ListSet();
        OperatorBid minbid = null;
        Currency targetcurr = AdminDAO.GetCurrencyByID("USD");
        Double minval = double.PositiveInfinity;
        foreach (OperatorBid ob in bidlist)
        {
            if (ob.Operator.Equals(op))
                opbids.Add(ob);

            Double temp = ob.Currency.ConvertTo(ob.BidAmount, targetcurr);
            if (temp < minval)
            {
                minval = temp;
                minbid = ob;
            }

        }
        resp += "{\"TotalBids\":" + bidlist.Count + ",\"OperatorBids\":" + JavaScriptConvert.SerializeObject(opbids) + ",\"MinBid\":" + JavaScriptConvert.SerializeObject(minbid) + "}";
        return resp;

    }
}
