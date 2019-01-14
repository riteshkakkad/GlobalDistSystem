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

public partial class AdminMaster : System.Web.UI.MasterPage
{
    private String _selectedtab;
    public String selectedtab
    {
        get { return _selectedtab; }
        set { _selectedtab = value; }
    }
    private String _bodyclass;
    public String bodyclass
    {
        get { return _bodyclass; }
        set { _bodyclass = value; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
}
