using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Helper;

namespace Entities
{
    public class Admin
    {
        private String _AdminID;
        private String _AdminPassword;
      

        
        public String AdminID
        {

            get { return _AdminID; }
            set { _AdminID = value; }
        }
        public String AdminPassword
        {
            get { return _AdminPassword; }
            set { _AdminPassword = value; }
        }

        public Admin()
        {

        }
    }
}
