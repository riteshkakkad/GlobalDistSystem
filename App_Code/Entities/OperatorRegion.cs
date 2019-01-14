using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace Entities{
public class OperatorRegion
{
    private Int64 _OperatorRegionID;
    private Operator _Operator;
    private String _Country;

    public Int64 OperatorRegionID
    {
        get { return _OperatorRegionID; }
        set { _OperatorRegionID = value; }
    }
    public Operator Vendor
    {
        get { return _Operator; }
        set { _Operator = value; }
    }
    public String Country
    {
        get { return _Country; }
        set { _Country = value; }
    }
    public OperatorRegion()
	{
		
	}
}
}